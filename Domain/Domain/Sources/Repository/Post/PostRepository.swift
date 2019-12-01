//
//  PostRepository.swift
//  Domain
//
//  Created by Kawoou on 19/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import RxSwift

public protocol PostRepository {
    func getPostsByTime(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>
    func getPostsForMap(latitude: Double, longitude: Double, zoom: Double) -> Single<[PostMap]>

    func getPostDetail(postId: Int) -> Single<PostDetail>

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
    ) -> Single<Post>

    func toggleLikeForPost(postId: Int, userId: Int) -> Single<Bool>
}
