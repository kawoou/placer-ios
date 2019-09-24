//
//  SplashViewController.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SplashViewController: UIViewController {

    // MARK: - Interface

    private lazy var brandImageView: UIImageView = {
        let view = UIImageView(image: Asset.iconBrandWhite.image)
        return view
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.startAnimating()
        return view
    }()

    // MARK: - Private

    private let viewModel: SplashViewModel

    private let disposeBag = DisposeBag()

    private func setupConstraints() {
        brandImageView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { maker in
            maker.top.equalTo(brandImageView.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
    }
    private func bind(viewModel: SplashViewModel) {
        /// Output
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        /// Input
        rx.viewDidAppear.map { _ in }
            .bind(to: viewModel.input.initial)
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        view.addSubview(brandImageView)
        view.addSubview(activityIndicator)

        setupConstraints()
        bind(viewModel: viewModel)

        Observable.just(Void())
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                container.resolve(UIWindow.self, name: "main")?.rootViewController = container.resolve(LoginViewController.self)
            })
            .disposed(by: disposeBag)
    }

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
