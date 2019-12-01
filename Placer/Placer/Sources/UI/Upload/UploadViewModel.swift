//
//  UploadViewModel.swift
//  Placer
//
//  Created by Kawoou on 24/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Common
import Domain
import Service
import RxSwift
import RxRelay

final class UploadViewModel: ViewModel {

    // MARK: - Dependency

    private let coordinator: CoordinatorPerformable

    // MARK: - ViewModel

    struct Input {
        let initial = PublishRelay<Void>()
    }
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: true)
        let isError = BehaviorRelay<Bool>(value: false)
        let isDone = BehaviorRelay<Bool>(value: false)
        let isClose = BehaviorRelay<Bool>(value: false)
    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        uploadPhoto: PHAsset,
        photoExif: PhotoExif,
        description: String,
        postService: PostService,
        photoService: PhotoService,
        coordinator: CoordinatorPerformable
    ) {
        self.coordinator = coordinator
        self.input = Input()
        self.output = Output()

        let saveStream = input.initial
            .flatMapLatest { () in
                postService
                    .writePost(
                        comment: description,
                        imageAsset: uploadPhoto,
                        photoExif: photoExif
                    )
                    .map { $0 }
                    .catchErrorJustReturn(nil)
            }
            .do(onNext: { [weak self] _ in
                self?.output.isLoading.accept(false)
            })
            .share()

        saveStream
            .map { $0 == nil }
            .bind(to: output.isError)
            .disposed(by: disposeBag)

        saveStream
            .map { $0 != nil }
            .bind(to: output.isDone)
            .disposed(by: disposeBag)

        saveStream
            .delay(.milliseconds(1500), scheduler: MainScheduler.instance)
            .map { _ in true }
            .bind(to: output.isClose)
            .disposed(by: disposeBag)
    }
    deinit {
        logger.debug("deinit: UploadViewModel")
    }

}
