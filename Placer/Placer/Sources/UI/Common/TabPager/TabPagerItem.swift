//
//  TabPagerItem.swift
//  Placer
//
//  Created by Kawoou on 10/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class TabPagerItem: UIView {

    // MARK: - Interface

    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray6.color
        return label
    }()
    private lazy var normalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray4.color
        return label
    }()
    private lazy var dotView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray6.color
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Property

    var isSelected: Bool = false {
        didSet {
            selectedLabel.alpha = isSelected ? 1 : 0
            normalLabel.alpha = isSelected ? 0 : 1
            dotView.alpha = isSelected ? 1 : 0
        }
    }

    // MARK: - Private

    private func setupConstraints() {
        selectedLabel.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        normalLabel.snp.makeConstraints { maker in
            maker.edges.equalTo(selectedLabel)
        }
        dotView.snp.makeConstraints { maker in
            maker.top.equalTo(selectedLabel.snp.bottom).offset(3)
            maker.bottom.equalToSuperview()
            maker.centerX.equalTo(selectedLabel)
            maker.size.equalTo(4)
        }
    }

    // MARK: - Lifecycle

    init(title: String) {
        super.init(frame: .zero)

        normalLabel.text = title
        selectedLabel.text = title

        addSubview(normalLabel)
        addSubview(selectedLabel)
        addSubview(dotView)

        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
