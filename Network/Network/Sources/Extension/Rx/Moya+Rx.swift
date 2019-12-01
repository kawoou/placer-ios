//
//  Moya+Rx.swift
//  Network
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import RxSwift
import Moya

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func map<D: Decodable>(
        _ type: D.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder? = nil,
        failsOnEmptyData: Bool = true
    ) -> Single<D> {
        let decoder = decoder ?? {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            return decoder
        }()
        return flatMap {
            .just(
                try $0.map(
                    type,
                    atKeyPath: keyPath,
                    using: decoder,
                    failsOnEmptyData: failsOnEmptyData
                )
            )
        }
    }
}
