//
//  SafeLayoutMargin.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

public struct SafeLayoutMargin {

    // MARK: - Static

    public static var statusBarHeight: CGFloat {
        return min(UIApplication.shared.statusBarFrame.height, 20)
    }

    public static var top: CGFloat {
        guard #available(iOS 11, *) else { return statusBarHeight }
        guard let window = UIApplication.shared.keyWindow else { return statusBarHeight }

        let safeTopInset = window.safeAreaInsets.top
        return (safeTopInset > 0) ? safeTopInset : statusBarHeight
    }
    public static var bottom: CGFloat {
        guard #available(iOS 11, *) else { return 0 }
        guard let window = UIApplication.shared.keyWindow else { return 0 }
        return window.safeAreaInsets.bottom
    }
    public static var left: CGFloat {
        guard #available(iOS 11, *) else { return 0 }
        guard let window = UIApplication.shared.keyWindow else { return 0 }
        return window.safeAreaInsets.left
    }
    public static var right: CGFloat {
        guard #available(iOS 11, *) else { return 0 }
        guard let window = UIApplication.shared.keyWindow else { return 0 }
        return window.safeAreaInsets.right
    }
}
