//
//  MainViewModel.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/06.
//

import RxSwift
import RxCocoa
import UIKit

struct MainViewModel {
    let disposBag = DisposeBag()
    
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewContoller.AlertAction>()
    //    알럿을 전달해준다
    
    let shouldPresentAlert: Signal<MainViewContoller.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        
        let cellData = blogValue
            .compactMap(model.getBlogListCellData)
        
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        
        Observable
            .combineLatest(sortedType, cellData, resultSelector: (model.sort))
        .bind(to: blogListViewModel.blogCellData)
        .disposed(by: disposBag)
        
        
        let alertShhetForSorting =
        blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewContoller.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            . map { message -> MainViewContoller.Alert in
                return (title: "앗!", message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도 해주세요. \(message)",
                        actions: [.confirm],
                        style: .alert)
            }
        self.shouldPresentAlert = Observable.merge(alertShhetForSorting, alertForErrorMessage)
            .asSignal(onErrorSignalWith: .empty())
    }
}
