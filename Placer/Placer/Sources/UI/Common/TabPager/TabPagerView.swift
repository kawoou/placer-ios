//
//  TabPagerView.swift
//  Placer
//
//  Created by Kawoou on 10/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

final class TabPagerView: UIView {

    // MARK: - Interface

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - Property

    private(set) var selectedIndex: Int = 0

    // MARK: - Private

    fileprivate let selectedIndexRelay = PublishRelay<Int>()

    private var itemList: [TabPagerItem] = []
    private let disposeBag = DisposeBag()

    private func setupConstraints() {
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    // MARK: - Public

    func addItem(_ item: TabPagerItem) {
        let index = stackView.subviews.count
        item.isSelected = index == 0

        let button = UIButton(type: .system)
        button.addSubview(item)
        button.rx.tap
            .do(onNext: { [weak self] () in
                self?.selectedIndex = index
                self?.selectedIndexRelay.accept(index)
            })
            .flatMapAnimate(stackView, duration: 0.2) { [weak self] (_, _) -> Void in
                let list = self?.itemList ?? []
                for (i, item) in list.enumerated() {
                    item.isSelected = index == i
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        item.isUserInteractionEnabled = false
        item.snp.makeConstraints { maker in
            maker.top.bottom.centerX.equalToSuperview()
        }

        itemList.append(item)
        stackView.addArrangedSubview(button)
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)

        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: TabPagerView {
    var selectedIndex: ControlEvent<Int> {
        ControlEvent(events: base.selectedIndexRelay)
    }
}
