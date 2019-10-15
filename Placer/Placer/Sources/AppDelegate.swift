//
//  AppDelegate.swift
//  Placer
//
//  Created by Kawoou on 13/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appCoordinator = container.resolve(AppCoordinator.self)!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Initialize
        FirebaseApp.configure()

        /// Window
        window = appCoordinator.target
        appCoordinator <- AppCoordinator.Action.presentMap

        return true
    }
}
