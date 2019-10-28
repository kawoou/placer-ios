//
//  RegisterViewController.swift
//  Placer
//
//  Created by Kawoou on 24/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Common
import SnapKit
import RxCocoa
import RxSwift
import RxKeyboard
import RxOptional

final class RegisterViewController: UIViewController {

    // MARK: - Interface

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        view.textColor = Asset.colorGray6.color
        view.text = "회원가입"
        return view
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconClose.image, for: .normal)
        return button
    }()

    private lazy var nicknameField: PlacerTextField = {
        let view = PlacerTextField()
        view.label = "닉네임"
        view.placeholder = "Nickname"
        view.keyboardType = .default
        view.returnKeyType = .next
        view.tag = 0
        return view
    }()
    private lazy var emailField: PlacerTextField = {
        let view = PlacerTextField()
        view.label = "이메일"
        view.placeholder = "E-mail"
        view.keyboardType = .emailAddress
        view.returnKeyType = .next
        view.tag = 1
        return view
    }()
    private lazy var passwordField: PlacerTextField = {
        let view = PlacerTextField()
        view.label = "비밀번호"
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        view.keyboardType = .default
        view.returnKeyType = .next
        view.tag = 2
        return view
    }()
    private lazy var passwordRetypeField: PlacerTextField = {
        let view = PlacerTextField()
        view.label = "비밀번호 확인"
        view.placeholder = "Retype password"
        view.isSecureTextEntry = true
        view.keyboardType = .default
        view.returnKeyType = .done
        view.tag = 3
        return view
    }()

    private lazy var submitButton: PlacerButton = {
        let button = PlacerButton(style: .solid)
        button.setTitle("회원가입", for: .normal)
        return button
    }()

    // MARK: - Private

    private let disposeBag = DisposeBag()

    private let viewModel: RegisterViewModel

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(58)
            maker.leading.equalToSuperview().inset(40)
            maker.trailing.equalTo(closeButton.snp.leading).offset(12)
        }
        closeButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(40)
            maker.centerY.equalTo(titleLabel)
        }

        nicknameField.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(30)
            maker.leading.trailing.equalToSuperview().inset(40)
            maker.height.equalTo(60)
        }
        emailField.snp.makeConstraints { maker in
            maker.top.equalTo(nicknameField.snp.bottom).offset(30)
            maker.leading.trailing.height.equalTo(nicknameField)
        }
        passwordField.snp.makeConstraints { maker in
            maker.top.equalTo(emailField.snp.bottom).offset(30)
            maker.leading.trailing.height.equalTo(nicknameField)
        }
        passwordRetypeField.snp.makeConstraints { maker in
            maker.top.equalTo(passwordField.snp.bottom).offset(30)
            maker.leading.trailing.height.equalTo(nicknameField)
        }

        submitButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview().inset(40)
            maker.height.equalTo(42)
        }
    }

    private func bindEvents() {
        let focusField = Observable
            .merge(
                nicknameField.rx.isFocus.asObservable(),
                emailField.rx.isFocus.asObservable(),
                passwordField.rx.isFocus.asObservable(),
                passwordRetypeField.rx.isFocus.asObservable()
            )
            .filter { $0 }
            .map { [weak self] _ in self?.view.currentFirstResponder() }
            .filterNil()

        Observable
            .combineLatest(
                focusField,
                RxKeyboard.instance.visibleHeight.asObservable()
            ) { [weak self] in
                let area = (self?.view.frame.height ?? 0) - $1 - 20
                return max(0, $0.frame.maxY - area)
            }
            .observeOn(MainScheduler.instance)
            .flatMapAnimate(self.view, duration: 0.2) {
                $0.transform = CGAffineTransform(translationX: 0, y: -$1)
            }
            .subscribe()
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .bind(to: viewModel.input.close)
            .disposed(by: disposeBag)
    }

    private func bind(viewModel: RegisterViewModel) {
        /// Output
        viewModel.output.isSubmitActive
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        /// Input
        nicknameField.rx.text.orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: disposeBag)

        emailField.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        passwordField.rx.text.orEmpty
            .bind(to: viewModel.input.password1)
            .disposed(by: disposeBag)

        passwordRetypeField.rx.text.orEmpty
            .bind(to: viewModel.input.password2)
            .disposed(by: disposeBag)

        submitButton.rx.tap
            .bind(to: viewModel.input.submit)
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }

        view.backgroundColor = Asset.colorGray1.color

        view.addSubview(titleLabel)
        view.addSubview(closeButton)

        view.addSubview(nicknameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(passwordRetypeField)

        view.addSubview(submitButton)

        view.addTapGestureRecognizerForDismissKeyboard()

        setupConstraints()
        bindEvents()
        bind(viewModel: viewModel)
    }

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        logger.unload(self)
    }
}

private extension UIView {
    func currentFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }

        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }

        return nil
     }
}
