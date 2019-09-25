//
//  FluentRenderInfo.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Common
import RxSwift

final class FluentRenderInfo {

    // MARK: - Property

    private(set) var savedOrigin: CGPoint
    private(set) var savedHidden: Bool

    // MARK: - Private

    private var view: UIView
    let fluentView: UIView?

    private weak var parent: FluentRenderInfo?
    private var children: [FluentRenderInfo]

    private let disposeBag = DisposeBag()

    // MARK: - Private

    private func findSuperviews(from fromView: UIView) -> [UIView] {
        var list = [UIView]()
        var targetParent = fromView

        while true {
            list.append(targetParent)

            guard let superview = targetParent.superview else {
                logger.warning("Not found superview.")
                return []
            }
            guard superview != view else { break }
            targetParent = superview
        }
        return list
    }

    // MARK: - Public

    func observe(_ origin: CGPoint, _ isHidden: Bool) {
        /// Calculate
        var newOrigin = origin
        if let scrollView = view as? UIScrollView {
            newOrigin.x += scrollView.frame.minX - scrollView.contentOffset.x
            newOrigin.y += scrollView.frame.minY - scrollView.contentOffset.y
        } else {
            newOrigin.x += view.frame.minX
            newOrigin.y += view.frame.minY
        }

        /// Saved
        savedOrigin = newOrigin
        savedHidden = isHidden || view.isHidden

        /// Bind
        fluentView?.frame = CGRect(origin: savedOrigin, size: view.frame.size)
        fluentView?.isHidden = savedHidden

        /// Update children
        children.forEach { $0.observe(newOrigin, savedHidden) }
    }

    func addChild(view: UIView) -> FluentRenderInfo {
        /// Search
        let stack = findSuperviews(from: view)

        /// Generate Tree
        var targetInfo = self
        for view in stack.reversed() {
            if let info = targetInfo.children.first(where: { $0.view == view }) {
                targetInfo = info
            } else {
                let info = FluentRenderInfo(view: view, parent: targetInfo)
                targetInfo.children.append(info)
                targetInfo = info
            }
        }

        return targetInfo
    }
    func removeChild(view: UIView) -> FluentRenderInfo? {
        /// Search
        let stack = findSuperviews(from: view)

        /// Found Tree
        var targetInfo = self
        var targetStack = [FluentRenderInfo]()
        for view in stack.reversed() {
            guard let info = targetInfo.children.first(where: { $0.view == view }) else { return nil }
            targetStack.append(info)
            targetInfo = info
        }

        /// Removing
        guard let returnValue = targetStack.popLast() else { return nil }

        var prevInfo = returnValue
        for info in targetStack.reversed() {
            info.children.removeAll { $0 === prevInfo }

            guard info.children.count == 0 else { break }
            prevInfo = info
        }
        return returnValue
    }

    // MARK: - Lifecycle

    init(view: UIView, parent: FluentRenderInfo? = nil) {
        self.view = view
        self.parent = parent
        children = []
        savedOrigin = .zero
        savedHidden = false

        /// Fluent View
        if let view = view as? FluentRenderable {
            let newView = UIView()
            newView.layer.shouldRasterize = true

            fluentView = newView
            view.setupFluentView(newView)
        } else {
            fluentView = nil
        }

        /// Observe
        var observableList: [Observable<Void>] = [
            view.rx.observe(CGRect.self, "frame").map { _ in },
            view.rx.observe(Bool.self, "hidden").map { _ in },
            view.rx.observe(CGAffineTransform.self, "transform").map { _ in }
        ]

        if let scrollView = view as? UIScrollView {
            observableList.append(contentsOf: [
                scrollView.rx.observe(CGPoint.self, "contentOffset").map { _ in },
                scrollView.rx.observe(CGSize.self, "contentSize").map { _ in }
            ])
        }

        Observable
            .merge(observableList)
            .subscribe(onNext: { [weak self] in
                guard let ss = self else { return }
                ss.observe(
                    ss.parent?.savedOrigin ?? .zero,
                    ss.parent?.savedHidden ?? false
                )
            })
            .disposed(by: disposeBag)
    }
}
