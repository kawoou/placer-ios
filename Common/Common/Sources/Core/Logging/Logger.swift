//
//  Logger.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import SwiftyBeaver

public let logger: SwiftyBeaver.Type = {
    let console = ConsoleDestination()
    let file = FileDestination()
    let cloud = SBPlatformDestination(
        appID: LoggerConstant.SwiftBeaver.appId,
        appSecret: LoggerConstant.SwiftBeaver.appSecret,
        encryptionKey: LoggerConstant.SwiftBeaver.encryptionKey
    )

    console.levelString.verbose = "💜 VERBOSE"
    console.levelString.debug = "💚 DEBUG"
    console.levelString.info = "💙 INFO"
    console.levelString.warning = "💛 WARNING"
    console.levelString.error = "❤️ ERROR"

    /// Date Loglevel(Thread) - Message
    /// $N.$F:$l = File, Function, Line
    console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $L($T) - $M"

    $0.addDestination(console)
    $0.addDestination(file)
    $0.addDestination(cloud)
    return $0
}(SwiftyBeaver.self)

public extension SwiftyBeaver {
    static func unload<T>(_ object: T) {
        debug("deinit(): \(String(describing: T.self))")
    }
    static func currentThread() {
        debug("Current Thread: \(Thread.current.name ?? "")")
    }
}
