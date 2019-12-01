//
//  PostDetailViewController.swift
//  Placer
//
//  Created by Kawoou on 30/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import MapKit
import Common
import Domain
import SnapKit
import RxSwift
import Kingfisher

final class PostDetailViewController: UIViewController {

    // MARK: - Interface

    private lazy var blurImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color.withAlphaComponent(0.7)
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()

    // Info
    private lazy var infoAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var infoNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray6.color
        return label
    }()
    private lazy var infoDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = Asset.colorGray6.color
        return label
    }()
    private lazy var infoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private lazy var infoLikeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconUnliked.image, for: .normal)
        button.setImage(Asset.iconLiked.image, for: .selected)
        button.setTitleColor(Asset.colorGray5.color, for: .normal)
        button.setTitleColor(Asset.colorHighlightRed.color, for: .selected)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.tintColor = Asset.colorHighlightRed.color
        return button
    }()
    private lazy var infoContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Asset.colorGray6.color
        label.numberOfLines = 0
        return label
    }()

    // Map
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    // Exif
    private lazy var exifAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Private

    private let viewModel: PostDetailViewModel

    private let disposeBag = DisposeBag()

    private func setupExifView(_ postDetail: PostDetail) {
        let dict = [
            "조리개": postDetail.aperture.map { String($0) },
            "초점 거리": postDetail.focalLength.map { String($0) },
            "노출 시간": postDetail.exposureTime.map { String($0) },
            "ISO": postDetail.iso.map { String($0) },
            "플래시": postDetail.flash.map { $0 ? "켜짐" : "꺼짐" },
            "제조사": postDetail.manufacturer,
            "모델": postDetail.lensModel,
            "고도": postDetail.altitude.map { String($0) }
        ].compactMapValues { $0 }

        exifAreaView.subviews.forEach { $0.removeFromSuperview() }

        var lastView: UIView?
        dict.forEach { (key, value) in
            let view: UIView = {
                let view = UIView()
                let titleLabel: UILabel = {
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                    label.text = key
                    label.textColor = Asset.colorGray6.color
                    return label
                }()
                let descLabel: UILabel = {
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    label.text = value
                    label.textColor = Asset.colorGray5.color
                    return label
                }()
                view.addSubview(titleLabel)
                view.addSubview(descLabel)

                titleLabel.snp.makeConstraints { maker in
                    maker.top.bottom.equalToSuperview().inset(5)
                    maker.leading.equalToSuperview().inset(14)
                    maker.width.equalTo(74)
                }
                descLabel.snp.makeConstraints { maker in
                    maker.top.bottom.equalToSuperview().inset(5)
                    maker.leading.equalTo(titleLabel.snp.trailing).offset(8)
                    maker.trailing.equalToSuperview().inset(14)
                }

                return view
            }()
            exifAreaView.addSubview(view)

            view.snp.makeConstraints { maker in
                if let lastView = lastView {
                    maker.top.equalTo(lastView.snp.bottom)
                } else {
                    maker.top.equalToSuperview().inset(11)
                }
                maker.leading.trailing.equalToSuperview()
            }
            lastView = view
        }
        if let lastView = lastView {
            lastView.snp.makeConstraints { maker in
                maker.bottom.equalToSuperview().inset(11)
            }
        }
    }

    private var imageHeightConstraints: Constraint?

    private func setupConstraints() {
        blurImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        overlayView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        infoAreaView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(30)
            maker.leading.trailing.equalTo(view).inset(20)
        }

        infoNicknameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(17)
            maker.leading.equalToSuperview().inset(14)
        }

        infoDescLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        infoDescLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(infoNicknameLabel)
            maker.leading.equalTo(infoNicknameLabel.snp.trailing).offset(16)
            maker.trailing.equalToSuperview().inset(14)
        }

        infoImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(52)
            maker.leading.trailing.equalToSuperview()
            imageHeightConstraints = maker.height.equalTo(infoImageView.snp.width).multipliedBy(0.5625).constraint
        }

        infoLikeButton.snp.makeConstraints { maker in
            maker.top.equalTo(infoImageView.snp.bottom).offset(16)
            maker.leading.equalToSuperview()
        }

        infoContentLabel.snp.makeConstraints { maker in
            maker.top.equalTo(infoLikeButton.snp.bottom).offset(20)
            maker.leading.trailing.equalToSuperview().inset(14)
            maker.bottom.equalToSuperview().inset(14)
        }

        mapView.snp.makeConstraints { maker in
            maker.top.equalTo(infoAreaView.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(view).inset(20)
            maker.height.equalTo(166)
        }

        exifAreaView.snp.makeConstraints { maker in
            maker.top.equalTo(mapView.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(view).inset(20)
            maker.bottom.equalToSuperview().inset(60)
            maker.height.equalTo(0).priority(.low)
        }
    }
    private func bind(viewModel: PostDetailViewModel) {
        infoImageView.kf.cancelDownloadTask()
        blurImageView.kf.cancelDownloadTask()

        /// Output
        let postStream = viewModel.output.post.filterNil().share()

        infoNicknameLabel.text = viewModel.post.writerNickname
        infoDescLabel.text = viewModel.post.createdAt.description
        if let url = URL(string: viewModel.post.imageUrl) {
            infoImageView.kf.setImage(with: url, placeholder: nil)

            let processor = ResizingImageProcessor(
                referenceSize: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                ),
                mode: .aspectFill
            ) >> BlurImageProcessor(blurRadius: 20)
            blurImageView.kf.setImage(
                with: url,
                options: [.processor(processor)]
            ) { [weak self] result in
                guard let ss = self else { return }

                switch result {
                case let .success(imageResult):
                    let size = imageResult.image.size
                    ss.imageHeightConstraints?.deactivate()
                    ss.infoImageView.snp.makeConstraints { maker in
                        ss.imageHeightConstraints = maker.height.equalTo(ss.infoImageView.snp.width)
                            .multipliedBy(size.height / size.width).constraint
                    }

                case .failure: break
                }
            }
        }

        infoContentLabel.attributedText = NSAttributedString(
            string: viewModel.post.content ?? "",
            attributes: [
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = 8
                    return style
                }()
            ]
        )

        postStream
            .map { detail -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: detail.latitude, longitude: detail.longitude)
                return annotation
            }
            .observeOn(MainScheduler.instance)
            .scan((nil, nil)) { ($0.1, $1) }
            .subscribe(onNext: { [weak self] (old, new) in
                guard let ss = self else { return }
                if let old = old {
                    ss.mapView.removeAnnotation(old)
                }
                if let new = new {
                    ss.mapView.addAnnotation(new)
                }
            })
            .disposed(by: disposeBag)

        postStream
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let ss = self else { return }

                let region = MKCoordinateRegion(
                    center: $0,
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
                let adjustRegion = ss.mapView.regionThatFits(region)
                ss.mapView.setRegion(adjustRegion, animated: false)
            })
            .disposed(by: disposeBag)

        postStream
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                self?.setupExifView(detail)
            })
            .disposed(by: disposeBag)

        viewModel.output.likeCount
            .map { "  좋아요 \($0)" }
            .bind(to: infoLikeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.output.isLiked
            .bind(to: infoLikeButton.rx.isSelected)
            .disposed(by: disposeBag)

        /// Input
        infoLikeButton.rx.tap
            .bind(to: viewModel.input.toggleLike)
            .disposed(by: disposeBag)

        rx.viewWillAppear.take(1)
            .map { _ in }
            .bind(to: viewModel.input.initial)
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = ""

        view.backgroundColor = Asset.colorGray3.color

        infoAreaView.addSubview(infoNicknameLabel)
        infoAreaView.addSubview(infoDescLabel)
        infoAreaView.addSubview(infoImageView)
        infoAreaView.addSubview(infoLikeButton)
        infoAreaView.addSubview(infoContentLabel)
        scrollView.addSubview(infoAreaView)

        scrollView.addSubview(mapView)
        scrollView.addSubview(exifAreaView)

        view.addSubview(blurImageView)
        view.addSubview(overlayView)
        view.addSubview(scrollView)

        setupConstraints()
        bind(viewModel: viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = Asset.colorGray6.color
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        logger.debug("deinit: PostDetailViewController")
    }
}
