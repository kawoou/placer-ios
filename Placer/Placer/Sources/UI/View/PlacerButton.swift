//
//  PlacerButton.swift
//  Placer
//
//  Created by Kawoou on 24/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxOptional

final class PlacerButton: UIButton {

    // MARK: - Enumerable

    enum Style {
        case line
        case solid
    }

    // MARK: - Property

    var style: Style {
        didSet {
            changeStream.accept(Void())
        }
    }
    override var isEnabled: Bool {
        didSet {
            changeStream.accept(Void())
        }
    }

    // MARK: - Private

    private let disposeBag = DisposeBag()

    private let changeStream = PublishRelay<Void>()

    private func bindEvents() {
        Observable
            .merge(
                rx.controlEvent(.touchUpInside).map { _ in },
                rx.controlEvent(.touchUpOutside).map { _ in },
                rx.controlEvent(.touchDragExit).map { _ in },
                changeStream.asObservable(),
                .just(Void())
            )
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] () in
                guard let ss = self else { return }

                switch ss.style {
                case .line:
                    ss.layer.borderWidth = 1
                    ss.layer.borderColor = Asset.colorGray3.color.cgColor
                    ss.layer.backgroundColor = nil

                case .solid:
                    ss.layer.borderWidth = 0
                    ss.layer.borderColor = nil
                }

                UIView.transition(with: ss, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    switch (ss.style, ss.isEnabled) {
                    case (.line, false):
                        ss.setTitleColor(Asset.colorGray3.color, for: .normal)
                    case (.line, true):
                        ss.setTitleColor(Asset.colorGray5.color, for: .normal)
                    case (.solid, false):
                        ss.setTitleColor(Asset.colorGray1.color, for: .normal)
                        ss.layer.backgroundColor = Asset.colorGray4.color.cgColor
                    case (.solid, true):
                        ss.setTitleColor(Asset.colorGray1.color, for: .normal)
                        ss.layer.backgroundColor = Asset.colorGray6.color.cgColor
                    }
                })
            })
            .subscribe()
            .disposed(by: disposeBag)

        Observable
            .merge(
                rx.controlEvent(.touchDown).map { _ in },
                rx.controlEvent(.touchDragEnter).map { _ in }
            )
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] () in
                guard let ss = self else { return }

                UIView.transition(with: ss, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    switch ss.style {
                    case .line:
                        ss.setTitleColor(Asset.colorGray3.color, for: .normal)
                    case .solid:
                        ss.setTitleColor(Asset.colorGray1.color, for: .normal)
                        ss.layer.backgroundColor = Asset.colorGray4.color.cgColor
                    }
                })
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    init(style: Style) {
        self.style = style

        super.init(frame: .zero)

        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        layer.masksToBounds = true
        layer.cornerRadius = 4

        bindEvents()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
