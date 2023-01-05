//
//  SearchBarViewModel.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import RxSwift
import RxCocoa


struct SearchBarViewModel {
    let queryText = PublishRelay<String?>()
    //서치바 버튼 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    //서치바 외부로 보내는 이벤트
    let shouldLoadResult: Observable<String>
    
    
    init () {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter {!$0.isEmpty }
            .distinctUntilChanged()
        
    }
}
