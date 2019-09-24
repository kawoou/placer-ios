//
//  UIViewController+Rx.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension ObservableType {
    func flatMapAnimate<T: UIView, U>(_ base: T, duration: TimeInterval, animations: @escaping (T, Element) -> U) -> Observable<U> {
        return observeOn(MainScheduler.instance)
            .flatMapLatest { element -> Observable<U> in
                .create { observer in
                    var result: U!
                    UIView.animate(withDuration: duration, animations: {
                        result = animations(base, element)
                    }, completion: { _ in
                        observer.onNext(result)
                        observer.onCompleted()
                    })
                    return Disposables.create()
                }
            }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func flatMapAnimate<T: UIView, U>(_ base: T, duration: TimeInterval, animations: @escaping (T, Element) -> U) -> Single<U> {
        return observeOn(MainScheduler.instance)
            .flatMap { element -> Single<U> in
                .create { observer in
                    var result: U!
                    UIView.animate(withDuration: duration, animations: {
                        result = animations(base, element)
                    }, completion: { _ in
                        observer(.success(result))
                    })
                    return Disposables.create()
                }
            }
    }
}
