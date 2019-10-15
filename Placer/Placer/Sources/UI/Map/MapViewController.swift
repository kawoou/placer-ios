//
//  MapViewController.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import MapKit
import Common
import RxSwift
import RxKeyboard
import SnapKit

final class MapViewController: UINavigationController {

    // MARK: - Interface

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        return view
    }()

    private lazy var inputArea: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color
        view.layer.cornerRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.17
        return view
    }()
    private lazy var inputIcon: UIImageView = {
        return UIImageView(image: Asset.iconSearch.image)
    }()
    private lazy var inputField: UITextField = {
        let view = UITextField()
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = Asset.colorGray6.color
        view.placeholder = "검색어를 입력하세요"
        view.returnKeyType = .search
        view.clearButtonMode = .always
        return view
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Asset.iconPlus.image, for: .normal)
        button.tintColor = Asset.colorGray6.color
        button.backgroundColor = Asset.colorGray1.color
        button.layer.cornerRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.17
        return button
    }()

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconLocationLine.image, for: .normal)
        button.setImage(Asset.iconLocationSolid.image, for: .selected)
        button.backgroundColor = Asset.colorGray1.color
        button.layer.cornerRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.17
        return button
    }()

    private lazy var searchBackgroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var searchPannelView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.colorGray1.color
        view.layer.cornerRadius = 8
        return view
    }()
    private lazy var searchListView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    // MARK: - Private

    private let disposeBag = DisposeBag()

    private let viewModel: MainViewModel

    private var searchPannelHeightConstraint: Constraint?
    private var searchPannelBottomConstraint: Constraint?

    private func setupConstraints() {
        mapView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        searchBackgroundOverlayView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        inputIcon.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(16)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(14)
        }
        inputField.snp.makeConstraints { maker in
            maker.leading.equalTo(inputIcon.snp.trailing).offset(10)
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().inset(16)
        }
        inputArea.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(24 + SafeLayoutMargin.top)
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.height.equalTo(48)
        }

        plusButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(92 + SafeLayoutMargin.top)
            maker.leading.equalToSuperview().inset(20)
            maker.size.equalTo(40)
        }

        currentLocationButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(92 + SafeLayoutMargin.top)
            maker.trailing.equalToSuperview().inset(20)
            maker.size.equalTo(40)
        }

        searchPannelView.snp.makeConstraints { maker in
            maker.top.equalTo(inputArea.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(inputArea)
            searchPannelHeightConstraint = maker.height.equalTo(0).constraint
            searchPannelBottomConstraint = maker.bottom.equalToSuperview().inset(0).constraint
        }
        searchListView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        searchPannelBottomConstraint?.deactivate()
    }

    private func bind(viewModel: MainViewModel) {
        /// Output
        let searchHiddenStream = Observable
            .combineLatest(
                viewModel.output.searchQuery.asObservable(),
                RxKeyboard.instance.isHidden.asObservable()
            ) { $0.isEmpty && $1 }
            .distinctUntilChanged()

        searchHiddenStream
            .flatMapAnimate(searchBackgroundOverlayView, duration: 0.3) {
                $0.alpha = $1 ? 0 : 1
            }
            .subscribe()
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                searchHiddenStream,
                RxKeyboard.instance.visibleHeight.asObservable()
            )
            .observeOn(MainScheduler.instance)
            .flatMapAnimate(searchPannelView, duration: 0.3) { [weak self] in
                guard let ss = self else { return }
                if $1.0 {
                    ss.searchPannelBottomConstraint?.deactivate()
                    ss.searchPannelHeightConstraint?.activate()
                } else {
                    ss.searchPannelHeightConstraint?.deactivate()
                    ss.searchPannelBottomConstraint?.update(inset: $1.1 + 10)
                    ss.searchPannelBottomConstraint?.activate()
                }

                ss.view.layoutIfNeeded()
            }
            .subscribe()
            .disposed(by: disposeBag)

        viewModel.output.searchResult
            .bind(to: searchListView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _, element, cell in
                let name = (element.name ?? "") as NSString
                let range = name.range(of: viewModel.output.searchQuery.value)

                let attributedString = NSMutableAttributedString(string: name as String)
                attributedString.setAttributes([
                    .foregroundColor: Asset.colorHighlightRed.color
                ], range: range)
                cell.textLabel?.attributedText = attributedString
            }
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                viewModel.output.isCurrentLocation,
                viewModel.output.currentLocation
            )
            .filter { $0.0 }
            .map { $0.1 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(onNext: { [weak self] in
                guard let ss = self else { return }
                ss.mapView.setCenter(
                    CLLocationCoordinate2D(
                        latitude: $0.latitude,
                        longitude: $0.longitude
                    ),
                    animated: true
                )
            })
            .disposed(by: disposeBag)

        viewModel.output.isCurrentLocation
            .distinctUntilChanged()
            .bind(to: currentLocationButton.rx.isSelected)
            .disposed(by: disposeBag)

        /// Input
        plusButton.rx.tap
            .bind(to: viewModel.input.add)
            .disposed(by: disposeBag)

        inputField.rx.text.orEmpty
            .skip(1)
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        currentLocationButton.rx.tap
            .withLatestFrom(viewModel.output.isCurrentLocation)
            .map { !$0 }
            .bind(to: viewModel.input.setCurrentLocation)
            .disposed(by: disposeBag)

        let selectResultStream = searchListView.rx.itemSelected
            .withLatestFrom(viewModel.output.searchResult) { $1[$0.item] }

        selectResultStream
            .map { _ in false }
            .bind(to: viewModel.input.setCurrentLocation)
            .disposed(by: disposeBag)

        selectResultStream
            .map { _ in "" }
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        selectResultStream
            .scan((nil, nil)) { (tuple, annotation) -> (MKAnnotation?, MKAnnotation?) in
                return (tuple.1, annotation.placemark)
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.inputField.text = ""
                self?.inputField.resignFirstResponder()
            })
            .subscribe(onNext: { [weak self] tuple in
                if let old = tuple.0 {
                    self?.mapView.removeAnnotation(old)
                }
                if let new = tuple.1 {
                    self?.mapView.addAnnotation(new)

                    let region = MKCoordinateRegion(
                        center: new.coordinate,
                        latitudinalMeters: CLLocationDistance(500),
                        longitudinalMeters: CLLocationDistance(500)
                    )
                    self?.mapView.setRegion(region, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Map"

        mapView.addSubview(searchBackgroundOverlayView)
        view.addSubview(mapView)

        inputArea.addSubview(inputIcon)
        inputArea.addSubview(inputField)
        view.addSubview(inputArea)
        view.addSubview(plusButton)
        view.addSubview(currentLocationButton)

        searchPannelView.addSubview(searchListView)
        view.addSubview(searchPannelView)

        setupConstraints()
        bind(viewModel: viewModel)
    }

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        logger.unload(self)
    }
}
