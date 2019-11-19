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

        let setDescription = PublishRelay<String>()

        let savePhoto = PublishRelay<Void>()
    }
    struct Output {
        let photo = BehaviorRelay<TLPHAsset?>(value: nil)
        let photoExif = BehaviorRelay<PhotoExif?>(value: nil)

        let description = BehaviorRelay<String>(value: "")

        let isLoading = BehaviorRelay<Bool>(value: false)
        let isClose = BehaviorRelay<Bool>(value: false)
        let isError = BehaviorRelay<Bool>(value: false)
    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        postService: PostService,
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

        input.setDescription
            .bind(to: output.description)
            .disposed(by: disposeBag)

        let saveStream = input.savePhoto
            .do(onNext: {
                output.isLoading.accept(true)
            })
            .withLatestFrom(output.photo) { $1?.phAsset }
            .filterNil()
            .withLatestFrom(output.description) { ($1, $0) }
            .flatMapLatest { postService.writePost(comment: $0.0, imageAsset: $0.1) }
            .map { $0 }
            .catchErrorJustReturn(nil)
            .do(onNext: { _ in
                output.isLoading.accept(false)
            })
            .share()

        saveStream
            .map { $0 == nil }
            .bind(to: output.isError)
            .disposed(by: disposeBag)

        saveStream
            .filterNil()
            .map { _ in true }
            .bind(to: output.isClose)
            .disposed(by: disposeBag)
    }
    deinit {
        logger.debug("deinit: AddViewModel")
    }
}
