//
//  UploadViewController.swift
//  Placer
//
//  Created by Kawoou on 24/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxSwift
import JTMaterialSpinner

final class UploadViewController: UIViewController {

    // MARK: - Interface

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 166 / 255, green: 193 / 255, blue: 238 / 255, alpha: 1).cgColor,
            UIColor(red: 251 / 255, green: 194 / 255, blue: 235 / 255, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    private lazy var spinnerView: JTMaterialSpinner = {
        let view = JTMaterialSpinner()
        view.circleLayer.lineWidth = 2.0
        view.circleLayer.strokeColor = UIColor.white.cgColor
        view.animationDuration = 2.5
        return view
    }()

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "uploading"
        return label
    }()

    // MARK: - Private

    private let disposeBag = DisposeBag()

    private let viewModel: UploadViewModel

    private func setupConstraints() {
        spinnerView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(36)
        }

        iconView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(36)
        }

        messageLabel.snp.makeConstraints { maker in
            maker.top.equalTo(spinnerView.snp.bottom).offset(12)
            maker.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func bind(viewModel: UploadViewModel) {
        /// Output
        viewModel.output.isLoading
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isLoading in
                guard let ss = self else { return }
                if isLoading {
                    ss.spinnerView.isHidden = false
                    ss.spinnerView.beginRefreshing()
                } else {
                    ss.spinnerView.isHidden = true
                    ss.spinnerView.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.isDone
            .asDriver()
            .distinctUntilChanged()
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let ss = self else { return }
                ss.iconView.isHidden = false
                ss.iconView.image = Asset.iconDone.image
                ss.messageLabel.text = "done!"
            })
            .disposed(by: disposeBag)

        viewModel.output.isError
            .asDriver()
            .distinctUntilChanged()
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let ss = self else { return }
                ss.iconView.isHidden = false
                ss.iconView.image = Asset.iconError.image
                ss.messageLabel.text = "에러가 발생했습니다!"
            })
            .disposed(by: disposeBag)

        /// Input
        rx.viewWillAppear
            .take(1)
            .map { _ in }
            .bind(to: viewModel.input.initial)
            .disposed(by: disposeBag)
    }

    // MARK: - Public

    // MARK: - Lifecycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradientLayer.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.addSublayer(gradientLayer)

        view.addSubview(spinnerView)
        view.addSubview(iconView)
        view.addSubview(messageLabel)

        setupConstraints()
        bind(viewModel: viewModel)
    }

    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    deinit {
//        logger.debug("deinit: UploadViewController")
//    }
}
