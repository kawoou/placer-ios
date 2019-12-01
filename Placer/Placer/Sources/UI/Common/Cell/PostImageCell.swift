//
//  PostImageCell.swift
//  Placer
//
//  Created by Kawoou on 08/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

final class PostImageCell: UITableViewCell {

    // MARK: - Constant

    private struct Constant {
        static var imageDocumentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("localImage", isDirectory: true)
    }

    // MARK: - Interface

    private lazy var placeImageView: FluentImageView = {
        let view = FluentImageView(image: nil)
        view.blurOffset = CGPoint(x: 0, y: 45)
        view.blurScale = 1
        view.blurSize = 20
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Private

    private func setupConstraints() {
        placeImageView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.top.bottom.equalToSuperview()
            maker.height.equalTo(placeImageView.snp.width).multipliedBy(0.5625).priority(.high)
        }
    }

    // MARK: - Public

    func bind(viewModel: PostCellModel) {
        placeImageView.kf.cancelDownloadTask()

        guard let url = URL(string: viewModel.post.imageUrl) else { return }
        placeImageView.kf.setImage(with: url, placeholder: nil)
    }

    // MARK: - Lifecycle

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview != nil {
            placeImageView.addShadow()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(placeImageView)

        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
