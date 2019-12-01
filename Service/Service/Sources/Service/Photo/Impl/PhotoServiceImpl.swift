//
//  PhotoServiceImpl.swift
//  Service
//
//  Created by Kawoou on 03/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import RxSwift

final class PhotoServiceImpl: PhotoService {
    func retrieveExif(from asset: PHAsset) -> Single<PhotoExif> {
        return Single.create { observer in
            let editOptions = PHContentEditingInputRequestOptions()
            editOptions.isNetworkAccessAllowed = true
            asset.requestContentEditingInput(with: editOptions) { (contentEditingInput, info) in
                guard let fileURL = contentEditingInput?.fullSizeImageURL else {
                    observer(.error(PhotoServiceError.failedToLoadFile))
                    return
                }
                guard let image = CIImage(contentsOf: fileURL) else {
                    observer(.error(PhotoServiceError.failedToLoadFile))
                    return
                }
                guard let exif = image.properties[kCGImagePropertyExifDictionary as String] as? [String: Any] else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                guard let gps = image.properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                guard let tiff = image.properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any] else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                guard let latitude = gps[kCGImagePropertyGPSLatitude as String] as? Double else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                guard let longitude = gps[kCGImagePropertyGPSLongitude as String] as? Double else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                guard let timestamp = exif[kCGImagePropertyExifDateTimeOriginal as String] as? String else {
                    observer(.error(PhotoServiceError.notFoundExif))
                    return
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                guard let date = formatter.date(from: timestamp) else {
                   observer(.error(PhotoServiceError.notFoundExif))
                   return
                }
                let model = PhotoExif(
                    aperture: exif[kCGImagePropertyExifMaxApertureValue as String] as? Double,
                    focalLength: exif[kCGImagePropertyExifFNumber as String] as? Double,
                    exposureTime: exif[kCGImagePropertyExifExposureTime as String] as? Double,
                    iso: (exif[kCGImagePropertyExifISOSpeedRatings as String] as? [Int])?.first,
                    flash: exif[kCGImagePropertyExifFlash as String] as? Bool,
                    manufacturer: tiff[kCGImagePropertyTIFFMake as String] as? String,
                    lensModel: tiff[kCGImagePropertyTIFFModel as String] as? String,
                    latitude: latitude,
                    longitude: longitude,
                    altitude: gps[kCGImagePropertyGPSAltitude as String] as? Double,
                    timestamp: date
                )
                observer(.success(model))
            }
            return Disposables.create()
        }
    }
}
