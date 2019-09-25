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

final class MapViewController: UINavigationController {

    // MARK: - Interface

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        return view
    }()

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconLocationLine.image, for: .normal)
        button.backgroundColor = Asset.colorGray1.color
        button.layer.cornerRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.17
        return button
    }()

    // MARK: - Private

    private func setupConstraints() {
        mapView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        currentLocationButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(92 + SafeLayoutMargin.top)
            maker.trailing.equalToSuperview().inset(20)
            maker.size.equalTo(40)
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)

        view.addSubview(currentLocationButton)

        setupConstraints()
    }
}
