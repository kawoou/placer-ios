//
//  UIView+Keyboard.swift
//  Placer
//
//  Created by Kawoou on 25/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

extension UIView {
    func addTapGestureRecognizerForDismissKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(gesture)
    }

    @objc func dismissKeyboard() {
        endEditing(false)
    }
}
