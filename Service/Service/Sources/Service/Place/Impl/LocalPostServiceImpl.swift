//
//  LocalPostServiceImpl.swift
//  Service
//
//  Created by Kawoou on 20/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import RxSwift

enum PostServiceError: Error {
    case notLoggedIn
}

final class LocalPostServiceImpl: PostService {

    // MARK: - Constant

    private struct Constant {
        static let imageDocumentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("localImage", isDirectory: true)

        static let postStorageKey = "io.kawoou.placer.db.posts"
        static let postDetailStorageKey = "io.kawoou.placer.db.postDetails"
    }

    // MARK: - Private

    private let userService: UserService
    private let photoService: PhotoService

    private var storage: [Post] {
        didSet {
            let data = try? JSONEncoder().encode(storage)
            UserDefaults.standard.set(data, forKey: Constant.postStorageKey)
        }
    }

    private var detailStorage: [PostDetail] {
        didSet {
            let data = try? JSONEncoder().encode(detailStorage)
            UserDefaults.standard.set(data, forKey: Constant.postDetailStorageKey)
        }
    }

    // MARK: - Public

    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        return .just(storage.reversed())
    }
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        return .just(storage.sorted { $0.likeCount < $1.likeCount })
    }

    func getPosts(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        return .just(storage)
    }

    func getPost(postId: Int) -> Single<Post> {
        guard let post = storage.first(where: { $0.id == postId }) else {
            return .error(RxError.noElements)
        }
        return .just(post)
    }

    func writePost(comment: String, imageAsset: PHAsset) -> Single<Post> {
        guard case .loggedIn(let user) = userService.userState.value else {
            return .error(PostServiceError.notLoggedIn)
        }

        return Single<String>
            .create { observer in
                PHImageManager.default().requestImage(
                    for: imageAsset,
                    targetSize: CGSize(width: 1500, height: 1500),
                    contentMode: .default,
                    options: nil
                ) { (image, _) in
                    guard let image = image else { return }
                    guard let data = image.pngData() else { return }

                    let fileName = "\(UUID().uuidString)_\(Date().timeIntervalSince1970).png"
                    let url = Constant.imageDocumentPath.appendingPathComponent(fileName)

                    do {
                        try data.write(to: url)
                    } catch let error {
                        observer(.error(error))
                    }
                    observer(.success(fileName))
                }

                return Disposables.create()
            }
            .flatMap { [unowned self] url -> Single<(String, PhotoExif)> in
                return self.photoService.retrieveExif(from: imageAsset)
                    .map { (url, $0) }
            }
            .map { [unowned self] (url, exif) -> Post in
                let post = Post(
                    id: (self.storage.last?.id ?? 0) + 1,
                    writerNickname: user.nickname,
                    imageUrl: url,
                    content: comment,
                    likeCount: 0,
                    isLiked: false,
                    createdAt: Date()
                )

                let postDetail = PostDetail(
                    postId: post.id,
                    aperture: exif.aperture,
                    focalLength: exif.focalLength,
                    exposureTime: exif.exposureTime.map { Int(1 / $0) },
                    iso: exif.iso,
                    flash: exif.flash,
                    manufacturer: exif.manufacturer,
                    lensModel: exif.lensModel,
                    latitude: exif.latitude,
                    longitude: exif.longitude,
                    timestamp: Date()
                )

                self.detailStorage.append(postDetail)
                self.storage.append(post)

                return post
            }
    }

    // MARK: - Lifecycle

    init(
        userService: UserService,
        photoService: PhotoService
    ) {
        self.userService = userService
        self.photoService = photoService

        self.storage = UserDefaults.standard.data(forKey: Constant.postStorageKey).flatMap { data in
            try? JSONDecoder().decode([Post].self, from: data)
        } ?? []

        self.detailStorage = UserDefaults.standard.data(forKey: Constant.postDetailStorageKey).flatMap { data in
            try? JSONDecoder().decode([PostDetail].self, from: data)
        } ?? []
        
        try? FileManager.default.createDirectory(at: Constant.imageDocumentPath, withIntermediateDirectories: false, attributes: nil)
    }
}
