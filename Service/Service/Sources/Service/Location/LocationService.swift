//
//  LocationService.swift
//  Service
//
//  Created by Kawoou on 06/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import MapKit
import RxSwift

public protocol LocationService {
    func observeCurrentLocation() -> Observable<Location>

    func searchLocation(query: String) -> Single<[MKMapItem]>
    func searchSimilarCityName(longitude: Double, latitude: Double) -> Single<String>
}
