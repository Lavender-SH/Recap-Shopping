//
//  MainCollectionViewCell.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class MainCollectionViewCell: BaseCollectionViewCell {
    
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    let mallNameLabel = {
        let view = UILabel()
        view.textColor = .gray
        view.font = UIFont.systemFont(ofSize: 15)
        view.textAlignment = .left
        return view
    }()
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 18)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .left
        return view
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    
    override func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(170)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
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
    var item: Item?
    // MARK: - likeButton을 눌렀을때 하트의 이미지가 바뀌는 로직
    var onLikeButtonTapped: ((Bool) -> Void)?

    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }

    @objc func toggleLike() {
        print(#function)
        isLiked.toggle()
        onLikeButtonTapped?(isLiked)
        if isLiked {
            guard let item = self.item else { return }
            let repository = LikeTableRepository()
            repository.saveItem(item)
//            if !repository.isItemLiked(item: item) {
//                repository.saveItem(item)
//            }
        } else {
            guard let item = self.item else { return }
            let repository = LikeTableRepository()
            repository.deleteItem(item)
        }
    }


    private func updateLikeButtonImage() {
        let imageName = isLiked ? "suit.heart.fill" : "suit.heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
     
    
    //셀에 데이터를 넣는 함수
    func configure(with item: Item) {
        self.item = item
        mallNameLabel.text = item.mallName
        // <b> 태그 제거
        let cleanTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        titleLabel.text = cleanTitle
        
        // 가격을 콤마로 구분하여 표시
        if let price = Int(item.lprice) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedPrice = numberFormatter.string(from: NSNumber(value: price))
            priceLabel.text = "\(formattedPrice!)원"
        } else {
            priceLabel.text = "\(item.lprice)원"
        }
        
        if let imageURL = URL(string: item.image) {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    
}
