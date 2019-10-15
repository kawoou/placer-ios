//
//  FluentImageView.swift
//  Placer
//
//  Created by Kawoou on 08/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class FluentImageView: UIImageView, FluentRenderable {

    // MARK: - Interface

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.clipsToBounds = false
        return view
    }()

    // MARK: - Property

    override var image: UIImage? {
        didSet {
            blurImage()
        }
    }

    var blurOffset: CGPoint = .zero {
        didSet {
            resetBlurArea()
        }
    }

    var blurScale: CGFloat = 1 {
        didSet {
            blurImage()
        }
    }
    var blurSize: CGFloat = 15 {
        didSet {
            blurImage()
        }
    }

    // MARK: - Private

    private func resetBlurArea() {
        let newSize = CGSize(
            width: bounds.width * blurScale,
            height: bounds.height * blurScale
        )

        if imageView.frame.size != newSize {
            blurImage()
        }

        imageView.frame.size = newSize
        imageView.center = CGPoint(
            x: bounds.width / 2 + blurOffset.x,
            y: bounds.height / 2 + blurOffset.y
        )
    }

    private func blurImage() {
        guard let image = image else {
            imageView.image = nil
            return
        }

        let newSize = CGSize(
            width: bounds.width * blurScale,
            height: bounds.height * blurScale
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let resizeImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        guard let ciImage = CIImage(image: resizeImage) else {
            imageView.image = nil
            return
        }

        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurSize, forKey: kCIInputRadiusKey)

        guard let outputImage = blurFilter?.outputImage else {
            imageView.image = nil
            return
        }

        let newImage = UIImage(ciImage: outputImage)
        UIGraphicsBeginImageContext(newSize)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            imageView.image = nil
            return
        }
        let ciContext = CIContext(options: nil)
        if let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)

            context.concatenate(flipVertical)
            context.draw(cgImage, in: CGRect(origin: .zero, size: newSize))
        }
        guard let cgImage = context.makeImage() else {
           imageView.image = nil
           return
       }
        imageView.image = UIImage(cgImage: cgImage)
    }

    private func updateInterfaceStyle() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .dark:
                imageView.alpha = 0.3

            default:
                imageView.alpha = 1
            }
        }
    }

    // MARK: - Public

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateInterfaceStyle()
    }

    func setupFluentView(_ view: UIView) {
        view.addSubview(imageView)
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        resetBlurArea()
    }

    override init(image: UIImage?) {
        super.init(image: image)

        updateInterfaceStyle()
        blurImage()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
