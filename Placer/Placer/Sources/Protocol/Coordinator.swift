//
//  Coordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import ObjectiveC

private var parentKey = "CoordinatorPerformableParentKey"
private var targetKey = "CoordinatorTargetKey"

/// CoordinatorPerformable
///
/// Perform the action. However, if type of the Action is invalid, sent to the parent.
protocol CoordinatorPerformable: class {
    func perform(_ action: Any)
}

extension CoordinatorPerformable {
    fileprivate var parent: CoordinatorPerformable? {
        get {
            return objc_getAssociatedObject(self, &parentKey) as? CoordinatorPerformable
        }
        set {
            objc_setAssociatedObject(self, &parentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// Coordinators
protocol _Coordinator: CoordinatorPerformable {
    associatedtype Target
    associatedtype Action

    func instantiate() -> Target
    func coordinate(_ action: Action) -> [CoordinatorAction<Target>]

    init()
}

extension _Coordinator {
    var target: Target {
        if let target = objc_getAssociatedObject(self, &targetKey) as? Target {
            return target
        }

        let target = instantiate()
        objc_setAssociatedObject(self, &targetKey, target, .OBJC_ASSOCIATION_ASSIGN)
        return target
    }

    func perform(_ action: Any) {
        if let action = action as? Action {
            coordinate(action).forEach { $0.perform(self, target) }
        } else {
            parent?.perform(action)
        }
    }
}

protocol WindowCoordinator: _Coordinator where Target: UIWindow {}
protocol Coordinator: _Coordinator where Target: UIViewController {}

/// CoordinatorAction
struct CoordinatorAction<Target> {
    typealias Peformable = (_ performable: CoordinatorPerformable, _ target: Target) -> Void

    fileprivate let perform: Peformable

    init(perform: @escaping Peformable) {
        self.perform = perform
    }
}

extension CoordinatorAction {
    static func perform<C: Coordinator>(_ target: C, action: C.Action) -> CoordinatorAction {
        return CoordinatorAction { (_, _) in
            target.perform(action)
        }
    }

    static func perform(_ perform: @escaping CoordinatorAction.Peformable) -> CoordinatorAction {
        return CoordinatorAction(perform: perform)
    }
}

extension CoordinatorAction where Target: UIWindow {
    static func move<C: Coordinator>(_ coordinator: C) -> CoordinatorAction {
        return CoordinatorAction { (parent, target) in
            coordinator.parent = parent
            target.rootViewController = coordinator.target
        }
    }

    static func move<C: Coordinator>(_ type: C.Type) -> CoordinatorAction {
        return move(C())
    }

    static func present<V: UIViewController>(_ viewController: V, animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.rootViewController?.present(viewController, animated: animated)
        }
    }
}

extension CoordinatorAction where Target: UIViewController {
    static func present<C: Coordinator>(_ coordinator: C, animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (parent, target) in
            coordinator.parent = parent
            target.present(coordinator.target, animated: animated)
        }
    }

    static func present<C: Coordinator>(_ type: C.Type, animated: Bool = true) -> CoordinatorAction {
        return present(C(), animated: animated)
    }

    static func present<V: UIViewController>(_ viewController: V, animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.present(viewController, animated: animated)
        }
    }

    static func dismiss(animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.dismiss(animated: animated)
        }
    }
}
extension CoordinatorAction where Target: UINavigationController {
    static func push<C: Coordinator>(_ coordinator: C, animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (parent, target) in
            coordinator.parent = parent
            target.pushViewController(coordinator.target, animated: animated)
        }
    }

    static func push<C: Coordinator>(_ type: C.Type, animated: Bool = true) -> CoordinatorAction {
        return push(C(), animated: animated)
    }

    static func pop(animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.popViewController(animated: animated)
        }
    }

    static func popToRoot(animated: Bool = true) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.popToRootViewController(animated: animated)
        }
    }
}
extension CoordinatorAction where Target: UITabBarController {
    static func changeTab(_ index: Int) -> CoordinatorAction {
        return CoordinatorAction { (_, target) in
            target.selectedIndex = index
        }
    }
}

/// Operators
infix operator <-
func <- (left: CoordinatorPerformable, right: Any) {
    left.perform(right)
}
