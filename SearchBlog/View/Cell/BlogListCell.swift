//
//  BlogListCell.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import UIKit
import SnapKit
import Kingfisher



final class BlogListCell: UITableViewCell {
    let thumbnailIamgeView = UIImageView()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let dateTimeLabel = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbnailIamgeView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        dateTimeLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        [thumbnailIamgeView, nameLabel, titleLabel, dateTimeLabel].forEach {
            addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualTo(thumbnailIamgeView.snp.leading).offset(-8)
        }
        thumbnailIamgeView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(thumbnailIamgeView.snp.leading).offset(-8)
            
        }
        
        dateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(thumbnailIamgeView)
        }
    }
    
    func setData(_ data: BlogListCellData) {
        
        thumbnailIamgeView.kf.setImage(with: data.thumbnailURL, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = data.name
        titleLabel.text = data.tilte
        
        
        var dateTime: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let contenDate = data.dateTime ?? Date()
            
            return dateFormatter.string(from: contenDate)
        }
        dateTimeLabel.text = dateTime
    }
}
