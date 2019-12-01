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
    func getPostsByMap(latitude: Double, longitude: Double, zoom: Double) -> Single<[PostMap]>
    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]>

    func getPost(postId: Int) -> Single<PostDetail>

    func writePost(comment: String, imageAsset: PHAsset, photoExif: PhotoExif) -> Single<Post>

    func toggleLikePost(postId: Int) -> Single<Bool>
}
