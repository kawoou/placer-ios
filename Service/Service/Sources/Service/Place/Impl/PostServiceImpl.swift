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

    // MARK: - Public

    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        getPosts(page: page, latitude: latitude, longitude: longitude, zoom: zoom)
    }
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        getPosts(page: page, latitude: latitude, longitude: longitude, zoom: zoom)
    }

    func getPosts(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        postRepository.getPosts(
            page: page,
            latitude: latitude,
            longitude: longitude,
            zoom: zoom
        )
    }
    
    func getPost(postId: Int) -> Single<Post> {
        postRepository.getPostDetail(postId: postId)
    }

    func writePost(comment: String, imageAsset: PHAsset) -> Single<Post> {
        .error(PostServiceError.notLoggedIn)
    }

    // MARK: - Lifecycle

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
}
