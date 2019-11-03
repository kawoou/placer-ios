//
//  PhotoServiceError.swift
//  Common
//
//  Created by Kawoou on 03/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public enum PhotoServiceError: Int, AbstractError {
    case failedToLoadFile
    case notFoundExif

    public var baseCode: Int {
        return 2200
    }
    public var reason: String {
        switch self {
        case .failedToLoadFile:
            return "파일을 읽을 수 없습니다."
        case .notFoundExif:
            return "EXIF 정보를 찾을 수 없습니다."
        }
    }
}
