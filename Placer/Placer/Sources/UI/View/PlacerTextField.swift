//
//  PlacerTextField.swift
//  Placer
//
//  Created by Kawoou on 24/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

final class PlacerTextField: UITextField {

    // MARK: - Interface

    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = Asset.colorGray6.color
        label.isHidden = true
        return label
    }()
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = Asset.colorGray3.color.cgColor
        return view
    }()

    // MARK: - Property

    var label: String? {
        didSet {
            labelView.text = label
            labelView.isHidden = (label == nil)
            layoutIfNeeded()
        }
    }

    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }
        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }

            attributedPlaceholder = NSAttributedString(
                string: newValue,
                attributes: [.foregroundColor: Asset.colorGray4.color]
            )
        }
    }

    // MARK: - Private

    private let disposeBag = DisposeBag()

    fileprivate let isFocus = BehaviorRelay<Bool>(value: false)

    private func setupConstraints() {
        labelView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        underlineView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    private func bindEvent() {
        Observable
            .combineLatest(
                rx.text.map { ($0 ?? "").isEmpty },
                isFocus
            ) { !$0 || $1 }
            .map { $0 ? Asset.colorGray6.color : Asset.colorGray3.color }
            .flatMapAnimate(underlineView, duration: 0.2) { (view, color) in
                view.layer.backgroundColor = color.cgColor
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if label != nil {
            return bounds.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        } else {
            return bounds
        }
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    init() {
        super.init(frame: .zero)

        delegate = self
        textColor = Asset.colorGray6.color

        addSubview(labelView)
        addSubview(underlineView)

        setupConstraints()
        bindEvent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlacerTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isFocus.accept(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFocus.accept(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          textField.resignFirstResponder()
       }
       return false
    }
}

extension Reactive where Base: PlacerTextField {
    var isFocus: ControlEvent<Bool> {
        return ControlEvent(events: base.isFocus)
    }
}
