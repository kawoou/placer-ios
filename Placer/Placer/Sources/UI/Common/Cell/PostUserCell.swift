//
//  PostUserCell.swift
//  Placer
//
//  Created by Kawoou on 08/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift

final class PostUserCell: UITableViewCell {

    // MARK: - Interface

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray6.color
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = Asset.colorGray5.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Private

    private var disposeBag = DisposeBag()

    private func setupConstraints() {
        nicknameLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.height.equalTo(32)
            maker.leading.equalToSuperview().inset(14)
        }
        timeLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(nicknameLabel.snp.trailing).offset(16)
            maker.centerY.equalTo(nicknameLabel)
            maker.trailing.equalToSuperview().inset(14)
        }
    }

    // MARK: - Public

    func bind(viewModel: PostCellModel) {
        disposeBag = DisposeBag()

        nicknameLabel.text = viewModel.post.writerNickname
        timeLabel.text = viewModel.post.createdAt.description
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        contentView.addSubview(nicknameLabel)
        contentView.addSubview(timeLabel)

        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
