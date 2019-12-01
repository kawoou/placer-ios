//
//  SamplePostServiceImpl.swift
//  Service
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import RxSwift

final class SamplePostServiceImpl: PostService {

    func getPostsByMap(latitude: Double, longitude: Double, zoom: Double) -> Single<[PostMap]> {
        .just([])
    }
    func getPostsByNewest(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        getPosts(page: page, latitude: latitude, longitude: longitude, zoom: zoom)
    }
    func getPostsByPopular(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        getPosts(page: page, latitude: latitude, longitude: longitude, zoom: zoom)
    }

    func getPosts(page: Int, latitude: Double, longitude: Double, zoom: Double) -> Single<[Post]> {
        return .just([Post(
            id: 1,
            writerNickname: "James Kim",
            imageUrl: "http://img.hani.co.kr/imgdb/resize/2018/0723/00501640_20180723.JPG",
            content: "가끔 고라니가 출몰합니다.. 저렇게 빤히 보고 있을 때면 대체 무슨 생각을 하고 있는건지;;",
            likeCount: 201,
            isLiked: true,
            createdAt: Date()
        )])
    }

    func getPost(postId: Int) -> Single<PostDetail> {
        return .error(RxError.noElements)
    }

    func writePost(comment: String, imageAsset: PHAsset, photoExif: PhotoExif) -> Single<Post> {
        return .error(PostServiceError.notLoggedIn)
    }

    func toggleLikePost(postId: Int) -> Single<Bool> {
        return .error(RxError.noElements)
    }
}
