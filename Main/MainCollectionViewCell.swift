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
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    override func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
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
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(8)
            make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            make.size.equalTo(36)
        }
        
    }
    
    // MARK: - likeButton을 눌렀을때 하트의 이미직이 바뀌는 로직
    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }

    @objc func toggleLike() {
        isLiked.toggle()
    }

    private func updateLikeButtonImage() {
        let imageName = isLiked ? "suit.heart.fill" : "suit.heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
}
