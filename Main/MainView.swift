//
//  MainView.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit

class MainView: BaseView {
    
    lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.showsCancelButton = true
        searchBar.barTintColor = .black
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            cancelButton.tintColor = .white
        }
        return searchBar
    }()
    
    let accuracyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("정확도", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("날짜순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let upPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격높은순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let downPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격낮은순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()

    
    override func configureView() {
        [searchBar, accuracyButton, dateButton, upPriceButton, downPriceButton, collectionView].forEach {
            addSubview($0)
        }

    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.equalTo(0)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(7)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        upPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(dateButton.snp.trailing).offset(7)
            make.width.equalTo(80)
            make.height.equalTo(38)
        }
        downPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(upPriceButton.snp.trailing).offset(7)
            make.width.equalTo(80)
            make.height.equalTo(38)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(accuracyButton.snp.bottom).offset(20)
        }
    }
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        let size = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: size / 2, height: 250)
        layer.cornerRadius = 20
        return layout
    }
                                   
    
    
    
    
}

