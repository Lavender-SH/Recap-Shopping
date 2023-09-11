//
//  LikeViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit
import RealmSwift

class LikeViewController: BaseViewController{

    let likeView = LikeView()
    
    override func loadView() {
        self.view = likeView
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
    //서치바 관련 변수
    var isSearchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeMakeNavigationUI()
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        likeView.collectionView.prefetchDataSource = self
        //좋아요 데이터 불러오기
        likedItems = repository.fetchFilter()
        likeView.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likeView.collectionView.reloadData()
    }
    // MARK: - 네트워킹
    func loadData(query: String) {
        shopManager.ShoppingCallRequest(query: query) { items in
            guard let items = items else { return }
            self.shopItems.append(contentsOf: items)
            self.likeView.collectionView.reloadData()
            //print(#function)
            //print(items)
        }
    }
    // MARK: - 네비게이션UI
    func likeMakeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "좋아요 목록"
    }
    
    override func configureView() {}
    
    override func setConstraints() {}
    
}
// MARK: - 확장: 컬렉션뷰 관련 함수
extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchActive ? shopItems.count : likedItems.count //⭐️⭐️⭐️
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as? LikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if isSearchActive {
            guard indexPath.row < shopItems.count else {
                return UICollectionViewCell()
            }
            let shopItem = shopItems[indexPath.row]
            cell.configure(with: shopItem)
            likeView.collectionView.reloadData()
 
        } else {
            guard indexPath.row < likedItems.count else {
                return UICollectionViewCell()
            }
            let item = likedItems[indexPath.row]
            cell.configure(with: item)
            likeView.collectionView.reloadData()
        }
        
        cell.backgroundColor = .clear
        cell.onItemDeleted = { [weak self] in
            self?.likeView.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //print("==66==", #function)
        for indexPath in indexPaths {
            guard let query = likeView.searchBar.text else { return }
            
            if isSearchActive && shopItems.count - 1 == indexPath.row && !isEnd {
                start += 1
                
                shopManager.ShoppingCallRequest(query: query) { items in
                    guard let items = items else { return }
                    self.shopItems.append(contentsOf: items)
                    self.likeView.collectionView.reloadData()
                }
            }
        }
    }
}


// MARK: - 확장: 서치바 관련 함수
extension LikeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = likeView.searchBar.text!
        shopItems.removeAll()
        loadData(query: text)
        isSearchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        likedItems = repository.fetchFilter()
        likeView.collectionView.reloadData()
        isSearchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            likedItems = repository.fetchFilter()
            likeView.collectionView.reloadData()
            isSearchActive = false
        }
    }
}
