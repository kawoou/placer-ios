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

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewDidLoad))
                .map { _ in }
        )
    }
    var viewWillAppear: ControlEvent<Bool> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewWillAppear))
                .map { $0.first as? Bool ?? false }
        )
    }
    var viewDidAppear: ControlEvent<Bool> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewDidAppear))
                .map { $0.first as? Bool ?? false }
        )
    }
    var viewWillDisappear: ControlEvent<Bool> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewWillDisappear))
                .map { $0.first as? Bool ?? false }
        )
    }
    var viewDidDisappear: ControlEvent<Bool> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewDidDisappear))
                .map { $0.first as? Bool ?? false }
        )
    }
    var viewWillLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewWillLayoutSubviews))
                .map { _ in }
        )
    }
    var viewDidLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.viewDidLayoutSubviews))
                .map { _ in }
        )
    }
    var didReceiveMemoryWarning: ControlEvent<Void> {
        return ControlEvent(
            events: methodInvoked(#selector(Base.didReceiveMemoryWarning))
                .map { _ in }
        )
    }
}
