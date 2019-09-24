//
//  AppDelegate.swift
//  Placer
//
//  Created by Kawoou on 13/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = container.resolve(UIWindow.self, name: "main")!

        return true
    }
}
