//
//  PlaceViewController.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Common
import RxDataSources
import RxSwift

final class PlaceViewController: FluentViewController {

    // MARK: - Interface

    private lazy var navigationView: PlacerNavigationView = {
        let view = PlacerNavigationView(height: 90)
        view.title = "서울 강남 인근"
        view.isBackButton = true
        return view
    }()
    private lazy var tabPagerView: TabPagerView = {
        let view = TabPagerView()
        view.addItem(TabPagerItem(title: "newest"))
        view.addItem(TabPagerItem(title: "popular"))
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.allowsSelection = false
        view.register(PostUserCell.self, forCellReuseIdentifier: "user")
        view.register(PostImageCell.self, forCellReuseIdentifier: "image")
        view.register(PostActionCell.self, forCellReuseIdentifier: "action")
        view.register(PostContentCell.self, forCellReuseIdentifier: "content")
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Private

    private let viewModel: PlaceViewModel

    private let disposeBag = DisposeBag()

    private let dataSource = RxTableViewSectionedReloadDataSource<PlaceSection>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case let .user(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? PostUserCell else { return PostUserCell() }
            cell.bind(viewModel: viewModel)
            return cell

        case let .image(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as? PostImageCell else { return PostImageCell() }
            cell.bind(viewModel: viewModel)
            return cell

        case let .content(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as? PostContentCell else { return PostContentCell() }
            cell.bind(viewModel: viewModel)
            return cell

        case let.action(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "action", for: indexPath) as? PostActionCell else { return PostActionCell() }
            cell.bind(viewModel: viewModel)
            return cell
        }
    })

    private func setupConstraints() {
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        navigationView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        tabPagerView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(16)
            maker.leading.trailing.equalToSuperview()
        }
    }
    private func bind(viewModel: PlaceViewModel) {
        /// Output
        viewModel.output.sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        /// Input
        tabPagerView.rx.selectedIndex
            .map { index -> PlaceViewModel.TabType in
                switch index {
                case 1:
                    return .popular
                default:
                    return .newest
                }
            }
            .bind(to: viewModel.input.setTab)
            .disposed(by: disposeBag)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        hidesBottomBarWhenPushed = true

        view.backgroundColor = Asset.colorGray1.color
        view.addSubview(tableView)

        navigationView.contentView.addSubview(tabPagerView)
        view.addSubview(navigationView)

        additionalSafeAreaInsets.top = navigationView.height

        setupConstraints()
        bind(viewModel: viewModel)

        navigationView.follow(scrollView: tableView, delay: 40)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
