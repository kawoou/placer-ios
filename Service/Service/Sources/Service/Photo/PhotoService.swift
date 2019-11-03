//
//  PhotoService.swift
//  Service
//
//  Created by Kawoou on 03/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Domain
import RxSwift

public protocol PhotoService {
    func retrieveExif(from asset: PHAsset) -> Single<PhotoExif>
}
