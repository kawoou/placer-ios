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

    func getPosts(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        provider.rx
            .request(.list(
                page: page,
                latitude: latitude,
                longitude: longitude,
                zoom: zoom
            ))
            .map([PostWithLikeResponse].self)
            .map { list in
                list.map { $0.toPost() }
            }
    }

    func getPostDetail(postId: Int) -> Single<Post> {
        provider.rx
            .request(.getDetail(postId: postId))
            .map(PostWithLikeResponse.self)
            .map { $0.toPost() }
    }

    // MARK: - Lifecycle

    init(provider: MoyaProvider<PostAPI>) {
        self.provider = provider
    }
}

private extension PostWithLikeResponse {
    func toPost() -> Post {
        Post(
            id: id,
            writerNickname: writerNickName,
            imageUrl: address,
            content: comment,
            likeCount: like,
            isLiked: myLike,
            createdAt: Date(timeIntervalSince1970: Double(createdAt))
        )
    }
}
