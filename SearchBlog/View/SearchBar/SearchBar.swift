//
//  SearchBar.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import UIKit
import RxSwift
import RxCocoa


final class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let serchButton = UIButton()
    //서치바 버튼 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    //서치바 외부로 보내는 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        
    }
}
