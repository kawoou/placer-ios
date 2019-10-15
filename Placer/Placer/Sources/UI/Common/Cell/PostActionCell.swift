//
//  PostActionCell.swift
//  Placer
//
//  Created by Kawoou on 08/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift

final class PostActionCell: UITableViewCell {

    // MARK: - Interface

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconUnliked.image, for: .normal)
        button.setImage(Asset.iconLiked.image, for: .selected)
        button.setTitleColor(Asset.colorGray5.color, for: .normal)
        button.setTitleColor(Asset.colorHighlightRed.color, for: .selected)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.tintColor = Asset.colorHighlightRed.color
        return button
    }()

    // MARK: - Private

    private var disposeBag = DisposeBag()

    private func setupConstraints() {
        likeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.bottom.equalToSuperview().inset(2)
        }
    }

    // MARK: - Public

    func bind(viewModel: PostCellModel) {
        disposeBag = DisposeBag()

        likeButton.setTitle("  좋아요 \(viewModel.post.likeCount)", for: .normal)
        likeButton.isSelected = viewModel.post.isLiked
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        contentView.addSubview(likeButton)

        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
