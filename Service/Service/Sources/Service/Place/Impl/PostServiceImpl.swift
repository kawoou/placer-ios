//
//  PostServiceImpl.swift
//  Service
//
//  Created by Kawoou on 19/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import RxSwift

final class PostServiceImpl: PostService {

    // MARK: - Private

    private let postRepository: PostRepository
    private let userService: UserService

    // MARK: - Public

    func getPostsByMap(latitude: Double, longitude: Double, zoom: Double) -> Single<[PostMap]> {
        postRepository.getPostsForMap(latitude: latitude, longitude: longitude, zoom: zoom)
    }
    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        postRepository.getPostsByTime(
            page: page,
            latitude: latitude,
            longitude: longitude,
            zoom: zoom
        )
    }
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        postRepository.getPostsByPopular(
            page: page,
            latitude: latitude,
            longitude: longitude,
            zoom: zoom
        )
    }
    
    func getPost(postId: Int) -> Single<PostDetail> {
        postRepository.getPostDetail(postId: postId)
            .debug()
    }

    func writePost(comment: String, imageAsset: PHAsset, photoExif: PhotoExif) -> Single<Post> {
        guard case .loggedIn(let user) = userService.userState.value else {
            return .error(PostServiceError.notLoggedIn)
        }

        return Single<Data>
            .create { observer in
                let editOptions = PHContentEditingInputRequestOptions()
                editOptions.isNetworkAccessAllowed = true

                imageAsset.requestContentEditingInput(with: editOptions) { (contentEditingInput, info) in
                    guard let fileURL = contentEditingInput?.fullSizeImageURL else {
                        observer(.error(PostServiceError.imageNotFound))
                        return
                    }
                    guard let data = try? Data(contentsOf: fileURL) else {
                        observer(.error(PostServiceError.imageNotFound))
                        return
                    }
                    observer(.success(data))
                }

                return Disposables.create()
            }
            .flatMap { [unowned self] data -> Single<Post> in
                return self.postRepository.uploadPost(
                    nickname: user.nickname,
                    comment: comment,
                    file: data,
                    aperture: photoExif.aperture,
                    focalLength: photoExif.focalLength,
                    exposureTime: photoExif.exposureTime,
                    iso: photoExif.iso,
                    flash: photoExif.flash,
                    manufacturer: photoExif.manufacturer,
                    lensModel: photoExif.lensModel,
                    latitude: photoExif.latitude,
                    longitude: photoExif.longitude,
                    altitude: photoExif.altitude,
                    timestamp: photoExif.timestamp
                )
            }
    }

    func toggleLikePost(postId: Int) -> Single<Bool> {
        guard case .loggedIn(let user) = userService.userState.value else {
            return .error(PostServiceError.notLoggedIn)
        }

        return postRepository.toggleLikeForPost(postId: postId, userId: user.id)
    }

    // MARK: - Lifecycle

    init(
        postRepository: PostRepository,
        userService: UserService
    ) {
        self.postRepository = postRepository
        self.userService = userService
    }
}
