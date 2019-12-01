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
    }
    struct Output {
        let photo = BehaviorRelay<TLPHAsset?>(value: nil)
        let photoExif = BehaviorRelay<PhotoExif?>(value: nil)

        let description = BehaviorRelay<String>(value: "")

        let isError = BehaviorRelay<Bool>(value: false)
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isClose = BehaviorRelay<Bool>(value: false)
    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Public

    func makeUploadViewModel() -> UploadViewModel? {
        guard let photo = output.photo.value?.phAsset else { return nil }
        guard let exif = output.photoExif.value else { return nil }

        let description = output.description.value
        return container.resolve(
            UploadViewModel.self,
            arguments: photo, exif, description
        )
    }

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

        let photoStream = input.selectPhoto
            .do(onNext: { _ in
                output.isError.accept(false)
                output.isLoading.accept(true)
            })
            .flatMap { asset -> Single<(TLPHAsset, PhotoExif)?> in
                guard let phAsset = asset.phAsset else {
                    return .just(nil)
                }
                return photoService.retrieveExif(from: phAsset)
                    .map { $0 }
                    .catchErrorJustReturn(nil)
                    .map { exif in
                        exif.map { (asset, $0) }
                    }
            }
            .do(onNext: { image in
                if image == nil {
                    output.isError.accept(true)
                }
                output.isLoading.accept(false)
            })
            .filterNil()
            .share()

        photoStream
            .map { $0.0 }
            .bind(to: output.photo)
            .disposed(by: disposeBag)

        photoStream
            .map { $0.1 }
            .bind(to: output.photoExif)
            .disposed(by: disposeBag)

        input.setDescription
            .bind(to: output.description)
            .disposed(by: disposeBag)
    }
    deinit {
        logger.debug("deinit: AddViewModel")
    }
}
