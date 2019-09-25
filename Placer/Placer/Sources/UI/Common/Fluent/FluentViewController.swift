//
//  FluentViewController.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import SnapKit

class FluentViewController: UIViewController {

    // MARK: - Private

    private lazy var supportView = FluentSupportView(frame: .zero)

    // MARK: - Public

    override func loadView() {
        view = supportView
    }

    func updateShadow() {
        supportView.info.observe(.zero, false)
    }
}

private class FluentSupportView: UIView {

    // MARK: - Interface

    private lazy var fluentView: UIView = {
        let view = UIView()
        view.layer.shouldRasterize = true
        return view
    }()

    // MARK: - Private

    private(set) lazy var info = FluentRenderInfo(view: self)

    // MARK: - Public

    func addView(_ view: UIView) {
        let newInfo = info.addChild(view: view)

        if let view = newInfo.fluentView {
            fluentView.addSubview(view)
        }
    }
    func removeView(_ view: UIView) {
        let renderInfo = info.removeChild(view: view)
        renderInfo?.fluentView?.removeFromSuperview()
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(fluentView)

        fluentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FluentRenderable {
    private func findSupportView(from view: UIView) -> FluentSupportView? {
        var oldTarget: UIView? = view

        while let target = oldTarget {
            if let beginTarget = target as? FluentSupportView {
                return beginTarget
            }
            oldTarget = target.superview
        }
        return nil
    }

    func addShadow() {
        guard let view = self as? UIView else { return }
        guard let supportView = findSupportView(from: view) else { return }
        supportView.addView(view)
    }
    func removeShadow() {
        guard let view = self as? UIView else { return }
        guard let supportView = findSupportView(from: view) else { return }
        supportView.removeView(view)
    }
}
