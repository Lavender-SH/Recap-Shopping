//
//  LikeViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit
import RealmSwift

class LikeViewController: BaseViewController {
    
    let likeView = LikeView()
    var shopManager = NetworkManager.shared
    //⭐️⭐️⭐️ Realm 데이터베이스 필수 변수
    var likedItems: Results<LikeTable>!
    let realm = try! Realm()
    let repository = LikeTableRepository()
    
    override func loadView() {
        self.view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeMakeNavigationUI()
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        //⭐️⭐️⭐️ 좋아요 데이터 불러오기
        likedItems = repository.fetchFilter()
        likeView.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likeView.collectionView.reloadData()
    }

    
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
    
    override func configureView() {
        
        
    }
    
    override func setConstraints() {

        
    }

    
    
}


extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedItems.count //⭐️⭐️⭐️
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as? LikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard indexPath.row < likedItems.count else {
            return UICollectionViewCell()
        }
        //⭐️⭐️⭐️
        let item = likedItems[indexPath.row]
        cell.configure(with: item)
        cell.backgroundColor = .clear
        cell.onItemDeleted = { [weak self] in
            self?.likeView.collectionView.reloadData()
        }
        return cell
    }
}


extension LikeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let text = likeView.searchBar.text!
//        loadData(query: text)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        shopItems.removeAll()
//        mainView.collectionView.reloadData()
    }
}
