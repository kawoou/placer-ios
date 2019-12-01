//
//  PlacerNavigationView.swift
//  Placer
//
//  Created by Kawoou on 10/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Common
import RxCocoa
import RxSwift

final class PlacerNavigationView: UIVisualEffectView {

    // MARK: - Enumerable

    private enum VisibleState {
        case show
        case hide
    }

    // MARK: - Interface

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = Asset.colorGray6.color
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Asset.btnBack.image, for: .normal)
        button.tintColor = Asset.colorGray6.color
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.isHidden = true
        return button
    }()

    // MARK: - Property

    let height: CGFloat

    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    var isBackButton: Bool {
        get { !backButton.isHidden }
        set { backButton.isHidden = !newValue }
    }

    override var intrinsicContentSize: CGSize {
        internalIntrinsicContentSize
    }

    // MARK: - Private

    private var visibleState: VisibleState = .show

    private var followScrollView: UIScrollView?
    private var followDelay: Double = 0

    private var isDelayAccepted = false
    private var beginLocation: CGPoint = .zero

    private var internalIntrinsicContentSize: CGSize

    private let disposeBag = DisposeBag()

    private func setupConstraints() {
        titleLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().inset(11 + SafeLayoutMargin.top)
            maker.leading.trailing.equalToSuperview().inset(20)
        }
        backButton.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.centerY.equalTo(titleLabel)
        }
    }

    private func animateView(state: VisibleState) {
        guard let scrollView = followScrollView else { return }

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelay(0.1)

        switch state {
        case .show:
            internalIntrinsicContentSize.height = height + SafeLayoutMargin.top
            contentView.alpha = 1
        case .hide:
            internalIntrinsicContentSize.height = SafeLayoutMargin.top + 10
            contentView.alpha = 0
        }
//        scrollView.scrollIndicatorInsets.top = internalIntrinsicContentSize.height - scrollView.adjustedContentInset.top

        invalidateIntrinsicContentSize()
        superview?.layoutIfNeeded()

        UIView.commitAnimations()
    }

    // MARK: - Public

    func follow(scrollView: UIScrollView, delay: Double = 0) {
        followScrollView = scrollView
        followDelay = delay

//        scrollView.scrollIndicatorInsets.top = height

        scrollView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] contentOffset in
                guard let ss = self else { return }
                guard let scrollView = ss.followScrollView else { return }
                guard ss.visibleState == .hide else { return }
                guard contentOffset.y <= scrollView.scrollIndicatorInsets.top else { return }
                ss.visibleState = .show
                ss.animateView(state: ss.visibleState)
            })
            .disposed(by: disposeBag)

        scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    }

    // MARK: - Lifecycle

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        guard newWindow != nil else { return }
        setupConstraints()
    }

    init(height: CGFloat) {
        self.height = height

        internalIntrinsicContentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: height + SafeLayoutMargin.top
        )

        super.init(effect: UIBlurEffect(style: .regular))

        contentView.addSubview(titleLabel)
        contentView.addSubview(backButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        followScrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handlePan(_:)))
    }

    // MARK: - Action

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let scrollView = followScrollView else { return }

        let state = gestureRecognizer.state

        switch state {
        case .began:
            isDelayAccepted = false
            beginLocation = scrollView.contentOffset

        case .changed:
            if !isDelayAccepted {
                let delta = beginLocation.y - scrollView.contentOffset.y
                if fabs(Double(delta)) > followDelay {
                    isDelayAccepted = true
                    beginLocation = scrollView.contentOffset
                } else {
                    return
                }
            }

            let delta = beginLocation.y - scrollView.contentOffset.y
            let offset = (visibleState == .show ? height : 0) + delta
            let percentage = max(min(offset / height, 1), 0)

            let clampOffset = 10 + percentage * (height - 10) + SafeLayoutMargin.top

            contentView.alpha = percentage

            internalIntrinsicContentSize.height = clampOffset
//            scrollView.scrollIndicatorInsets.top = internalIntrinsicContentSize.height - scrollView.adjustedContentInset.top
            invalidateIntrinsicContentSize()

        case .ended, .failed:
            if isDelayAccepted {
                let delta = beginLocation.y - scrollView.contentOffset.y
                if delta > 0 {
                    visibleState = .show
                } else if delta < 0 {
                    visibleState = .hide
                }
            }

            animateView(state: visibleState)

        default: break
        }
    }
}

extension Reactive where Base: PlacerNavigationView {
    var tapBack: ControlEvent<Void> {
        ControlEvent(events: base.backButton.rx.tap)
    }
}
