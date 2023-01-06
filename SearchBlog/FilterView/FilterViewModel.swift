//
//  FilterViewModel.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import RxSwift
import RxCocoa
import UIKit

struct FilterViewModel {
    let sortButtonTapped = PublishRelay<Void>()
    let shouldUpdateType: Observable<Void>
    
    init() {
        self.shouldUpdateType = sortButtonTapped
            .asObservable()
    }
    
}
