//
//  PostContentCell.swift
//  Placer
//
//  Created by Kawoou on 08/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift

final class PostContentCell: UITableViewCell {

    // MARK: - Interface

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Asset.colorGray6.color
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Private

    private var disposeBag = DisposeBag()

    private func setupConstraints() {
        contentLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(14)
            maker.top.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview().inset(24)
        }
    }

    // MARK: - Public

    func bind(viewModel: PostCellModel) {
        disposeBag = DisposeBag()

        contentLabel.attributedText = NSAttributedString(
            string: viewModel.post.content ?? "",
            attributes: [
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = 8
                    return style
                }()
            ]
        )
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(contentLabel)

        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
