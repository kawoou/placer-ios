//
//  PostRepositoryImpl.swift
//  Domain
//
//  Created by Kawoou on 19/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Network
import RxSwift
import RxOptional
import Moya

final class PostRepositoryImpl: PostRepository {

    // MARK: - Private

    private let provider: MoyaProvider<PostAPI>

    // MARK: - Public

    func getPostsByTime(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        provider.rx
            .request(.listTime(
                page: page,
                latitude: latitude,
                longitude: longitude,
                zoom: zoom
            ))
            .do(onNext: { response in
                print(response.request)
            })
            .map([Post].self)
    }

    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        provider.rx
            .request(.listPopular(
                page: page,
                latitude: latitude,
                longitude: longitude,
                zoom: zoom
            ))
            .map([Post].self)
    }

    func getPostsForMap(latitude: Double, longitude: Double, zoom: Double) -> Single<[PostMap]> {
        provider.rx
            .request(.listMap(
                latitude: latitude,
                longitude: longitude,
                zoom: zoom
            ))
            .map([PostMap].self)
    }

    func getPostDetail(postId: Int) -> Single<PostDetail> {
        provider.rx
            .request(.getDetail(postId: postId))
            .map(PostDetail.self)
    }

    func uploadPost(
        nickname: String,
        comment: String,
        file: Data,
        aperture: Double?,
        focalLength: Double?,
        exposureTime: Double?,
        iso: Int?,
        flash: Bool?,
        manufacturer: String?,
        lensModel: String?,
        latitude: Double,
        longitude: Double,
        altitude: Double?,
        timestamp: Date
    ) -> Single<Post> {
        provider.rx
            .request(.upload(
                nickname: nickname,
                comment: comment,
                file: file,
                aperture: aperture,
                focalLength: focalLength,
                exposureTime: exposureTime,
                iso: iso,
                flash: flash,
                manufacturer: manufacturer,
                lensModel: lensModel,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                timestamp: timestamp
            ))
            .map(Post.self)
    }

    func toggleLikeForPost(postId: Int, userId: Int) -> Single<Bool> {
        provider.rx
            .request(.toggleLike(postId: postId, userId: userId))
            .map(Bool.self)
    }

    // MARK: - Lifecycle

    init(provider: MoyaProvider<PostAPI>) {
        self.provider = provider
    }
}
