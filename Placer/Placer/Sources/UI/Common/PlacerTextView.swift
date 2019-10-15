//
//  PlacerTextView.swift
//  Placer
//
//  Created by Kawoou on 15/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class PlacerTextView: UITextView {

    // MARK: - Interface

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()

    // MARK: - Property

    var placeholder: String? {
        get { placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            textChanged(nil)
        }
    }
    var placeholderColor: UIColor {
        get { placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    override var text: String! {
        didSet {
            textChanged(nil)
        }
    }

    override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabel.snp.remakeConstraints { maker in
                maker.left.equalToSuperview().inset(textContainerInset.left)
                maker.right.equalToSuperview().inset(textContainerInset.right)
                maker.top.equalToSuperview().inset(textContainerInset.top)
                maker.bottom.equalToSuperview().inset(textContainerInset.bottom)
            }
            layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func bindEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged(_:)),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    // MARK: - Lifecycle

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(textContainerInset.left)
            maker.right.equalToSuperview().inset(textContainerInset.right)
            maker.top.equalToSuperview().inset(textContainerInset.top)
            maker.bottom.equalToSuperview().inset(textContainerInset.bottom)
        }

        bindEvents()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(textContainerInset.left)
            maker.right.equalToSuperview().inset(textContainerInset.right)
            maker.top.equalToSuperview().inset(textContainerInset.top)
            maker.bottom.equalToSuperview().inset(textContainerInset.bottom)
        }

        bindEvents()
    }

    // MARK: - Action

    @objc func textChanged(_ notification: Notification?) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        defer {
            UIView.commitAnimations()
        }

        guard let placeholder = placeholder else {
            placeholderLabel.alpha = 0
            return
        }
        guard !placeholder.isEmpty else {
            placeholderLabel.alpha = 0
            return
        }

        if text.isEmpty {
            placeholderLabel.alpha = 1
        } else {
            placeholderLabel.alpha = 0
        }
    }

}
