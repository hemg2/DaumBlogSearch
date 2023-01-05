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
        
    }
    
    private func attribute() {
        title = "다음 블로그 검섹"
        view.backgroundColor = .white
    }
    
    private func layout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



