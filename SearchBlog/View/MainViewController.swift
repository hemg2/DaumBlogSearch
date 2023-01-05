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
    let apikey = "e88ec31b2d9da9e801e939b34db4caf4"
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
        let alertShhetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .dateTime, .cancel], style: .actionSheet)
            }
        
        alertShhetForSorting
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
        case title, dateTime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .dateTime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .dateTime:
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
