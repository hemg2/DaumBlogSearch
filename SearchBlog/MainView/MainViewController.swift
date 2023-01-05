//
//  MainViewController.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import UIKit
import RxCocoa
import RxSwift


final class MainViewContoller: UIViewController {
    let disposeBag = DisposeBag() //할당
    let searchBar = SearchBar()
    let listView = BlogListView()
    let alertActionTapped = PublishRelay<AlertAction>()
    //    알럿을 전달해준다
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        let blogResult = searchBar.shouldLoadResult
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
        .bind(to: listView.cellData)
        .disposed(by: disposeBag)
        
        
        let alertShhetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            . map { message -> Alert in
                return (title: "앗!", message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도 해주세요. \(message)",
                        actions: [.confirm],
                        style: .alert)
            }
        
        Observable.merge(alertShhetForSorting, alertForErrorMessage)
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "다음 블로그 검섹"
        view.backgroundColor = .white
    }
    
    private func layout() {
        [searchBar, listView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



extension MainViewContoller {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    
    //알럿 추가
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController,
                                                                actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            for action in actions {
                alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: { _ in observer.onNext(action)
                    observer.onCompleted()
                })
                )
            }
            self.present(alertController, animated: true)
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
        .asSignal(onErrorSignalWith: .empty())
    }
}
