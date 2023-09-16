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
    //Realm 변수
    var likedItems: Results<LikeTable>!
    var filteredLikedItems: Results<LikeTable>!
    let realm = try! Realm()
    let repository = LikeTableRepository()
    //서치바 관련 변수
    var isSearchActive = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeMakeNavigationUI()
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        
        //좋아요 데이터 불러오기
        likedItems = repository.fetchFilter()
        likeView.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likeView.collectionView.reloadData()
        //print("=789=", #function)
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
extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredLikedItems.count
        }
        return likedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
    
            let item: LikeTable
            if isSearchActive {
                item = filteredLikedItems[indexPath.row]
            } else {
                item = likedItems[indexPath.row]
            }
            
            cell.configure(with: item)
            cell.onItemDeleted = {
                self.likedItems = self.repository.fetchFilter()
                collectionView.reloadData()
            }
            
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let likeItem = likedItems[indexPath.row]
        let webVC = WebViewController()
        print("456", likeItem.productID)
        webVC.likeProductID = likeItem.productID
        webVC.likeItem = likeItem
        let cleanTitle = likeItem.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        webVC.webViewTitle = cleanTitle
        
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}

// MARK: - 확장: 서치바 관련 함수
extension LikeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = likeView.searchBar.text, !text.isEmpty else {
            return
        }
        filteredLikedItems = likedItems.filter("title CONTAINS[c] %@", text)
        isSearchActive = true
        likeView.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        likeView.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            likeView.collectionView.reloadData()
        } else {
            filteredLikedItems = likedItems.filter("title CONTAINS[c] %@", searchText)
            isSearchActive = true
            likeView.collectionView.reloadData()
        }
    }
}

