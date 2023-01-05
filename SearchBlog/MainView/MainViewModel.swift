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
    
    init () {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest { query in
                SearchBlogNetwork().searchBlog(query: query)
            }
            .share()
        
        let blogValue = blogResult
            .compactMap { data -> DKBlog? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
        
        let blogError = blogResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.localizedDescription
            }
        
        
        let cellData = blogValue
            .map { blog -> [BlogListCellData] in
                return blog.documents
                    .map { doc in
                        let thumbnailURL = URL(string: doc.thumbnail ?? "")
                        return BlogListCellData(thumbnailURL: thumbnailURL, name: doc.name, tilte: doc.title, datetime: doc.datetime)
                    }
            }
        
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
        
        
        Observable.combineLatest(sortedType, cellData) { type, data -> [BlogListCellData] in
            switch type {
            case .title:
                return data.sorted { $0.tilte ?? "" < $1.tilte ?? "" }
            case .datetime:
                return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
            default:
                return data
            }
        }
        .bind(to: blogListViewModel.blogCellData)
        .disposed(by: disposBag)
        
        
        let alertShhetForSorting =
        blogListViewModel.filterViewModel.srtButtonTapped
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
