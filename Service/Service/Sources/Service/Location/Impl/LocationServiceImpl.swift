//
//  LocationServiceImpl.swift
//  Service
//
//  Created by Kawoou on 06/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import RxRelay
import RxOptional

final class LocationServiceImpl: NSObject, LocationService {

    // MARK: - Private

    private let locationManager: CLLocationManager

    private let locationHandleCount = BehaviorRelay<Int>(value: 0)
    private let currentLocation = BehaviorRelay<Location?>(value: nil)

    private let disposeBag = DisposeBag()

    // MARK: - Public

    func observeCurrentLocation() -> Observable<Location> {
        return currentLocation
            .do(onSubscribe: { [unowned self] in
                self.locationHandleCount
                    .accept(self.locationHandleCount.value + 1)
            }, onDispose: { [unowned self] in
                self.locationHandleCount
                    .accept(self.locationHandleCount.value - 1)
            })
            .filterNil()
    }

    func searchLocation(query: String) -> Single<[MKMapItem]> {
        return .create { observer in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query

            let search = MKLocalSearch(request: request)
            search.start { response, error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.success(response?.mapItems ?? []))
            }

            return Disposables.create()
        }
    }

    // MARK: - Lifecycle

    override init() {
        locationManager = CLLocationManager()

        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        locationHandleCount
            .subscribe(onNext: { [unowned self] count in
                switch count {
                case 0:
                    self.locationManager.startUpdatingLocation()
                case 1:
                    self.locationManager.stopUpdatingLocation()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        currentLocation.accept(
            Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        )
    }
}
