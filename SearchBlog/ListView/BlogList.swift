//
//  BlogList.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import UIKit
import RxSwift
import RxCocoa


final class BlogListView: UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    
        attribute()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: BlogListViewModel) {
        
        headerView.bind(viewModel.filterViewModel)
        viewModel.cellData.asDriver(onErrorJustReturn: []).drive(self.rx.items) {
            tv, row, data in
            let index = IndexPath(row: row, section: 0)
            let cell = tv.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
            cell.setData(data)
            return cell
        }
        .disposed(by: disposeBag)
        // 여기 까지 셀포 로우엣 대신해서 쓴다.
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
    
    private func layout() {
        
    }
}
