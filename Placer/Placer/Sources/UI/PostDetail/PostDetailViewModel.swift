//
//  PostDetailViewModel.swift
//  Placer
//
//  Created by Kawoou on 30/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import Service
import RxSwift
import RxRelay

final class PostDetailViewModel: ViewModel {

    // MARK: - Dependency

    private let postService: PostService

    // MARK: - ViewModel

    struct Input {
        let initial = PublishRelay<Void>()

        let toggleLike = PublishRelay<Void>()
    }
    struct Output {
        let post = BehaviorRelay<PostDetail?>(value: nil)

        let likeCount = BehaviorRelay<Int>(value: 0)
        let isLiked = BehaviorRelay<Bool>(value: false)
    }

    // MARK: - Property

    let post: Post

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        post: Post,
        postService: PostService,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.postService = postService

        self.post = post
        self.input = input
        self.output = output

        output.likeCount.accept(post.likeCount)
        output.isLiked.accept(post.isLiked ?? false)

        input.initial
            .flatMapLatest { () -> Single<PostDetail?> in
                postService.getPost(postId: post.id)
                    .map { $0 }
                    .catchErrorJustReturn(nil)
            }
            .filterNil()
            .bind(to: output.post)
            .disposed(by: disposeBag)

        input.toggleLike
            .withLatestFrom(output.isLiked) { !$1 }
            .do(onNext: {
                output.isLiked.accept($0)
            })
            .flatMapLatest { _ -> Observable<Bool> in
                postService.toggleLikePost(postId: post.id)
                    .asObservable()
                    .catchError { _ in .empty() }
            }
            .bind(to: output.isLiked)
            .disposed(by: disposeBag)

        output.isLiked
            .scan((false, false)) { old, new in (old.1, new) }
            .skip(1)
            .withLatestFrom(output.likeCount) { ($0.0, $0.1, $1) }
            .map { (old, new, likeCount) in
                switch (old, new) {
                case (false, false), (true, true):
                    return likeCount
                case (false, true):
                    return likeCount + 1
                case (true, false):
                    return likeCount - 1
                }
            }
            .bind(to: output.likeCount)
            .disposed(by: disposeBag)
    }
}
