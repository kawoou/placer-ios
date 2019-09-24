//
//  LoginViewController.swift
//  Placer
//
//  Created by Kawoou on 24/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class LoginViewController: UIViewController {

    // MARK: - Interface

    private lazy var brandImageView: UIImageView = {
        let view = UIImageView(image: Asset.iconBrandBlack.image)
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.colorGray5.color
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "Sign in to continue"
        return label
    }()

    private lazy var formView = UIView()
    private lazy var emailField: PlacerTextField = {
        let view = PlacerTextField()
        view.placeholder = "E-mail"
        view.keyboardType = .emailAddress
        view.returnKeyType = .next
        view.tag = 0
        return view
    }()
    private lazy var passwordField: PlacerTextField = {
        let view = PlacerTextField()
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        view.returnKeyType = .done
        view.tag = 1
        return view
    }()

    private lazy var submitButton: PlacerButton = {
        let button = PlacerButton(style: .solid)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    private lazy var registerButton: PlacerButton = {
        let button = PlacerButton(style: .line)
        button.setTitle("회원가입", for: .normal)
        return button
    }()

    // MARK: - Private

    private let disposeBag = DisposeBag()

    private let viewModel: LoginViewModel

    private func setupConstraints() {
        brandImageView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(40)
            maker.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(41)
            maker.bottom.equalTo(formView.snp.top).offset(-70)
        }

        formView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(40)
            maker.centerY.equalToSuperview().offset(10)
        }
        emailField.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }
        passwordField.snp.makeConstraints { maker in
            maker.top.equalTo(emailField.snp.bottom).offset(10)
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }

        submitButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(40)
            maker.bottom.equalTo(registerButton.snp.top).offset(-6)
            maker.height.equalTo(42)
        }
        registerButton.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview().inset(40)
            maker.height.equalTo(42)
        }
    }

    private func bind(viewModel: LoginViewModel) {
        /// Output
        viewModel.output.isSubmitActive
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        /// Input
        emailField.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        passwordField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] () in
                self?.present(container.resolve(RegisterViewController.self)!, animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Asset.colorGray1.color

        view.addSubview(brandImageView)
        view.addSubview(descriptionLabel)

        formView.addSubview(emailField)
        formView.addSubview(passwordField)
        view.addSubview(formView)

        view.addSubview(submitButton)
        view.addSubview(registerButton)

        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)

        setupConstraints()
        bind(viewModel: viewModel)
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
