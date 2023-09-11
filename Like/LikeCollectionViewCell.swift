//
//  LikeCollectionViewCell.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/10.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift


class LikeCollectionViewCell: BaseCollectionViewCell {
    
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
    
    // MARK: - 좋아요 버튼 로직
    var item: LikeTable?

    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    //컬렉션뷰 갱신을 위해 클로저 변수 생성
    var onItemDeleted: (() -> Void)?

    @objc func toggleLike() {
        //print(#function)
        //print("==77==", isLiked)
        guard let item = self.item else { return }
        let repository = LikeTableRepository()
        repository.deleteItem(item)
        onItemDeleted?() // 컬렉션뷰 갱신
    }
    
    private func updateLikeButtonImage() {
        let imageName = isLiked ? "suit.heart.fill" : "suit.heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    //셀에 좋아요를 선택한 정보를 넣기
    func configure(with item: DisplayableItem) {
        self.item = item as? LikeTable
        
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
        
        likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        
        if let imageURL = URL(string: item.image) {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
}

