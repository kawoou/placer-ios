//
//  BehaviorObservable.swift
//  Common
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import RxCocoa
import RxSwift

/// BehaviorObservable is a readable wrapper for `BehaviorRelay`.
public struct BehaviorObservable<Element>: ObservableType, ObserverType {
    private let _behavior: BehaviorRelay<Element>

    public var value: Element {
        return _behavior.value
    }

    public init(_ behaviorRelay: BehaviorRelay<Element>) {
        _behavior = behaviorRelay
    }
    public init(value: Element) {
        _behavior = BehaviorRelay(value: value)
    }

    public mutating func accept(_ event: Element) {
        _behavior.accept(event)
    }

    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        return _behavior.subscribe(observer)
    }
    public func asObservable() -> Observable<Element> {
        return _behavior.asObservable()
    }

    public func on(_ event: Event<Element>) {
        switch event {
        case .next(let element):
            _behavior.accept(element)
        default:
            break
        }
    }
}
