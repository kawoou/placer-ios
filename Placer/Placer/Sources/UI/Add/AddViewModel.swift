//
//  AddViewModel.swift
//  Placer
//
//  Created by Kawoou on 11/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import Service
import RxSwift
import RxRelay
import TLPhotoPicker

final class AddViewModel: ViewModel {

    // MARK: - Dependency

    private let coordinator: CoordinatorPerformable

    // MARK: - ViewModel

    struct Input {
        let selectPhoto = PublishRelay<TLPHAsset>()
    }
    struct Output {
        let photo = BehaviorRelay<TLPHAsset?>(value: nil)
        let photoExif = BehaviorRelay<PhotoExif?>(value: nil)
    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        photoService: PhotoService,
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.coordinator = coordinator
        self.input = input
        self.output = output

        input.selectPhoto
            .bind(to: output.photo)
            .disposed(by: disposeBag)

        input.selectPhoto
            .map { $0.phAsset }
            .filterNil()
            .flatMap { photoService.retrieveExif(from: $0) }
            .map { $0 }
            .catchError { _ in .just(nil) }
            .bind(to: output.photoExif)
            .disposed(by: disposeBag)
    }
    deinit {
        logger.debug("deinit: AddViewModel")
    }
}
