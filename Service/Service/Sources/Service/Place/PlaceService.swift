//
//  PlaceService.swift
//  Service
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import RxSwift

public protocol PlaceService {
    func getPost(placeId: Int) -> Single<[Post]>
}
