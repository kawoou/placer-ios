//
//  SamplePlacerServiceImpl.swift
//  Service
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Domain
import RxSwift

final class SamplePlaceServiceImpl: PlaceService {

    func getPost(placeId: Int) -> Single<[Post]> {
        return .just((0..<50).map {
            Post(
                id: $0,
                writerId: 1,
                writerNickname: "James Kim",
                imageUrl: "http://img.hani.co.kr/imgdb/resize/2018/0723/00501640_20180723.JPG",
                content: "가끔 고라니가 출몰합니다.. 저렇게 빤히 보고 있을 때면 대체 무슨 생각을 하고 있는건지;;",
                likeCount: 201,
                isLiked: $0 % 2 == 0 ? true : false,
                createdAt: Date()
            )
        })
    }

}
