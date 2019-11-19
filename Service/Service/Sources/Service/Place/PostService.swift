//
//  PostService.swift
//  Service
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Domain
import RxSwift

public protocol PostService {
    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>

    func getPost(postId: Int) -> Single<Post>

    func writePost(comment: String, imageAsset: PHAsset) -> Single<Post>
}
