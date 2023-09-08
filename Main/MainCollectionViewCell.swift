//
//  MainCollectionViewCell.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit

class MainCollectionViewCell: BaseCollectionViewCell {
    
    
    
    
    let imageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .gray
        view.font = UIFont.systemFont(ofSize: 15)
        view.textAlignment = .left
        view.text = "월드캠핑카"
        return view
    }()
    let detailLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.text = "[대한캠핑카] 쌍용 렉스턴스포츠칸 캠핑카 미니어쩌구"
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    let priceLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 18)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .left
        view.text = "19,000,0000"
        return view
    }()
    

    
    
    
    
    override func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(170)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        
    }
    
    
}
