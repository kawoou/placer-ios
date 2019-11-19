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
    func getPosts(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>

    func getPostDetail(postId: Int) -> Single<Post>
}
