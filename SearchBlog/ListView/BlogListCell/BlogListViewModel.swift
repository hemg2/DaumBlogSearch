//
//  BlogListViewModel.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    let filterViewModel = FilterViewModel()
    
    
    //mainViewController -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init () {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}
