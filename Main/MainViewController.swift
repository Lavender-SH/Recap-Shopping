//
//  MainViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    var shopManager = NetworkManager.shared
    var shopItems: [Item] = []
    var isEnd = false
    var start = 1
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationUI()
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.backgroundColor = .black
        mainView.collectionView.prefetchDataSource = self
        //loadData(query: "자전거")
        
    }
    func loadData(query: String) {
        shopManager.ShoppingCallRequest(query: query) { items in
            guard let items = items else { return }
            self.shopItems.append(contentsOf: items)
            self.mainView.collectionView.reloadData()
            print(#function)
            print(items)
        }
    }
    
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "쇼핑 검색"
    }
    
    
    override func configureView() {
        super.configureView()
        
        [mainView.accuracyButton, mainView.dateButton, mainView.upPriceButton, mainView.downPriceButton].forEach {
            $0.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        }
        
        [mainView.accuracyButton, mainView.dateButton, mainView.upPriceButton, mainView.downPriceButton].forEach {
            $0.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        }
        
        if let cancelButton = mainView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: UIControl.Event.touchUpInside)
        }
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
        
    @objc func toggleButtonColor(sender: UIButton) {
        // 모든 버튼의 상태를 초기화
        let allButtons = [mainView.accuracyButton, mainView.dateButton, mainView.upPriceButton, mainView.downPriceButton]
        for button in allButtons {
            button.isSelected = false
            button.backgroundColor = .black
            button.setTitleColor(.gray, for: .normal)
        }
        
        // 선택된 버튼의 상태만 변경
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
    
    @objc func changeSort(sender: UIButton) {
        
        guard let query = mainView.searchBar.text else { return }
        
        var sortValue: String
        switch sender {
        case mainView.accuracyButton:
            sortValue = "sim"
        case mainView.dateButton:
            sortValue = "date"
        case mainView.upPriceButton:
            sortValue = "dsc"
        case mainView.downPriceButton:
            sortValue = "asc"
        default:
            return
        }
        
        self.shopItems.removeAll()
        
        NetworkManager.shared.ShoppingCallRequest(query: query, sort: sortValue) { items in
            guard let items = items else { return }
            self.shopItems.append(contentsOf: items)
            self.mainView.collectionView.reloadData()
        }
    }
    
    
    override func setConstraints() {
        
    }
    
}
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = mainView.searchBar.text!
        loadData(query: text)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        guard indexPath.row < shopItems.count else {
            return UICollectionViewCell()
        }
        let item = shopItems[indexPath.row]
        cell.configure(with: item)
        cell.backgroundColor = .clear
        cell.toggleLike()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //print("=====99999999999======", shopItems.count, start)
            guard let query = mainView.searchBar.text else { return }
            
            if shopItems.count - 1 == indexPath.row && !isEnd {
                start += 1
                
                NetworkManager.shared.ShoppingCallRequest(query: query, start: start) { items in
                    guard let items = items else { return }
                    self.shopItems.append(contentsOf: items)
                    self.mainView.collectionView.reloadData()
                }
            }
        }
    }

}





