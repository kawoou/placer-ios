//
//  PlaceAnnotationView.swift
//  Placer
//
//  Created by Kawoou on 26/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import MapKit
import Kingfisher

final class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    let postId: Int
    let imageUrl: String
    let imageCount: Int

    init(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String,
        postId: Int,
        imageUrl: String,
        imageCount: Int
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle

        self.postId = postId
        self.imageUrl = imageUrl
        self.imageCount = imageCount
    }
}

final class PlaceAnnotationView: MKAnnotationView {

    // MARK: - Enumerable

    enum SizeType {
        case small
        case normal
        case large

        static func of(imageCount: Int) -> SizeType {
            switch imageCount {
            case ..<3:
                return .small
            case ..<10:
                return .normal
            default:
                return .large
            }
        }

        var size: CGFloat {
            switch self {
            case .small:
                return 42
            case .normal:
                return 64
            case .large:
                return 108
            }
        }
        var borderSize: CGFloat {
            switch self {
            case .small:
                return 2
            case .normal:
                return 3
            case .large:
                return 4
            }
        }
    }

    // MARK: - Interface

    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.21
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Asset.colorGray6.color
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Private

    private func setupConstraints() {
        guard let annotation = annotation as? PlaceAnnotation else { return }

        let sizeType = SizeType.of(imageCount: annotation.imageCount)

        let size = sizeType.size
        let borderSize = sizeType.borderSize

        if let url = URL(string: annotation.imageUrl) {
            let resize = ResizingImageProcessor(
                referenceSize: CGSize(width: 100, height: 100),
                mode: .aspectFill
            )

            imageView.kf.setImage(with: url, options: [.processor(resize)])
        }

        frame.size = CGSize(width: size, height: size)

        borderView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(size)
        }
        imageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview().inset(borderSize)
        }

        borderView.layer.cornerRadius = size * 0.5
        imageView.layer.cornerRadius = (size - borderSize) * 0.5

        layoutIfNeeded()
    }

    // MARK: - Lifecycle

    override var annotation: MKAnnotation? {
        didSet {
            imageView.kf.cancelDownloadTask()
            imageView.image = nil

            setupConstraints()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        borderView.addSubview(imageView)
        addSubview(borderView)

        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
