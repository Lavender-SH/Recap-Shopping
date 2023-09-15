//
//  MainViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit
import RealmSwift

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    //Networking 변수
    var shopManager = NetworkManager.shared
    var shopItems: [Item] = []
    //Realm 변수
    var likedItems: Results<LikeTable>!
    let realm = try! Realm()
    let repository = LikeTableRepository()
    //pagination 변수
    var isEnd = false
    var start = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationUI()
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        //loadData(query: "전체 상품")
        print(realm.configuration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.collectionView.reloadData()
    }

    // MARK: - 네트워킹
    func loadData(query: String) {
        shopManager.ShoppingCallRequest(query: query) { items in
            guard let items = items else { return }
            self.shopItems.append(contentsOf: items)
            self.mainView.collectionView.reloadData()
            print(#function)
            //print(items)
        }
    }
    // MARK: - 네비게이션UI
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
    override func setConstraints() { }

    // MARK: - 취소버튼 초기화
    @objc func cancelButtonTapped() {
        shopItems.removeAll()
        mainView.collectionView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 정렬버튼 컬러변경
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
    
    // MARK: - 정렬버튼 로직
    @objc func changeSort(sender: UIButton) {
        
        //guard let query = mainView.searchBar.text else { return }
        guard let query = mainView.searchBar.text, !query.isEmpty else { return }
        
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
}

// MARK: - 확장: 서치바 관련 함수
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = mainView.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        loadData(query: text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shopItems.removeAll()
        mainView.collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            shopItems.removeAll()
            mainView.collectionView.reloadData()
        }
    }
}

// MARK: - 확장: 컬렉션뷰 관련 함수
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //print("==999==", shopItems.count, start)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = shopItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = item.productID
        webVC.item = item
        let cleanTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        webVC.webViewTitle = cleanTitle
        
        navigationController?.pushViewController(webVC, animated: true)
    }
}
