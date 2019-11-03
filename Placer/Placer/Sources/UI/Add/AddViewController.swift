//
//  AddViewController.swift
//  Placer
//
//  Created by Kawoou on 11/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import MapKit
import Common
import SnapKit
import RxSwift
import RxKeyboard
import TLPhotoPicker

final class AddViewController: UIViewController {

    // MARK: - Interface

    private lazy var closeBarButton = UIBarButtonItem(title: "닫기", style: .plain, target: nil, action: nil)
    private lazy var doneBarButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray6.color
        label.text = "photo"
        return label
    }()
    private lazy var photoList: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private lazy var photoStack: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()

    private lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 14
        view.isHidden = true
        return view
    }()
    private lazy var photoSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Asset.btnAdd.image, for: .normal)
        button.tintColor = Asset.colorGray4.color
        button.layer.borderColor = Asset.colorGray4.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 14
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.colorGray6.color
        label.text = "description"
        return label
    }()

    private lazy var descriptionTextView: PlacerTextView = {
        let view = PlacerTextView()
        view.placeholder = "본문을 입력해주세요"
        view.placeholderColor = Asset.colorGray4.color
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textColor = Asset.colorGray5.color
        view.textContainerInset = UIEdgeInsets(top: 18, left: 14, bottom: 18, right: 14)
        view.backgroundColor = Asset.colorGray2.color
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Private

    private let viewModel: AddViewModel

    private var descriptionBottomConstraint: Constraint?

    private let disposeBag = DisposeBag()

    private func setupConstraints() {
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        mapView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalTo(view)
            maker.height.equalTo(130)
        }

        photoLabel.snp.makeConstraints { maker in
            maker.top.equalTo(mapView.snp.bottom).offset(26)
            maker.leading.trailing.equalTo(view).inset(20)
        }
        photoList.snp.makeConstraints { maker in
            maker.top.equalTo(photoLabel.snp.bottom).offset(8)
            maker.leading.trailing.equalTo(view)
            maker.height.equalTo(100)
        }
        photoStack.snp.makeConstraints { maker in
            maker.height.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(20)
        }
        photoView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(160)
        }
        photoSelectButton.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(160)
        }

        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(photoList.snp.bottom).offset(40)
            maker.leading.trailing.equalTo(photoLabel)
        }
        descriptionTextView.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            descriptionBottomConstraint = maker.bottom.equalTo(view).inset(40).constraint
            maker.leading.trailing.equalTo(photoLabel)
        }
    }
    private func bind(viewModel: AddViewModel) {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .skip(1)
            .flatMapAnimate(view, duration: 0.35) { [weak self] (view, height) in
                self?.descriptionBottomConstraint?.update(inset: height + 40)
                view.layoutIfNeeded()
            }
            .subscribe()
            .disposed(by: disposeBag)

        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .asObservable()
            .skip(1)
            .map { $0 ? 0 : 200 }
            .flatMapAnimate(scrollView, duration: 0.35) {
                $0.contentOffset.y = $1
            }
            .subscribe()
            .disposed(by: disposeBag)

        /// Output
        viewModel.output.photo
            .map { $0?.fullResolutionImage }
            .filterNil()
            .bind(to: photoView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.photo
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] state in
                self?.photoView.isHidden = !state
                self?.photoSelectButton.isHidden = state
                self?.photoStack.layoutIfNeeded()
            })
            .disposed(by: disposeBag)

        viewModel.output.photoExif
            .filterNil()
            .map { exif -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: exif.latitude, longitude: exif.longitude)
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

        viewModel.output.photoExif
            .filterNil()
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let ss = self else { return }

                let region = MKCoordinateRegion(center: $0, latitudinalMeters: 500, longitudinalMeters: 500)
                let adjustRegion = ss.mapView.regionThatFits(region)
                ss.mapView.setRegion(adjustRegion, animated: true)
            })
            .disposed(by: disposeBag)

        /// Input
        photoSelectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let ss = self else { return }
                let viewController = TLPhotosPickerViewController()
                viewController.delegate = ss
                viewController.configure.allowedLivePhotos = false
                viewController.configure.allowedVideo = false
                viewController.configure.allowedVideoRecording = false
                viewController.configure.allowedAlbumCloudShared = false
                viewController.configure.mediaType = .image
                viewController.configure.usedCameraButton = false
                return ss.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        closeBarButton.rx.tap
            .asObservable()
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "사진 업로드"
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItem = doneBarButton

        view.backgroundColor = Asset.colorGray1.color

        scrollView.addSubview(mapView)
        scrollView.addSubview(photoLabel)

        photoStack.addArrangedSubview(photoView)
        photoStack.addArrangedSubview(photoSelectButton)
        photoList.addSubview(photoStack)
        scrollView.addSubview(photoList)

        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionTextView)
        view.addSubview(scrollView)

        setupConstraints()
        bind(viewModel: viewModel)
    }

    init(viewModel: AddViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        logger.debug("deinit: AddViewController")
    }
}

extension AddViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let asset = withTLPHAssets.first else { return }
        viewModel.input.selectPhoto.accept(asset)
    }
}
