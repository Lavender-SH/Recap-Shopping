//
//  LikeViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit

class LikeViewController: BaseViewController {
    
    let likeView = LikeView()
    var shopManager = NetworkManager.shared
    
    override func loadView() {
        self.view = likeView
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeMakeNavigationUI()
        
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        likeView.collectionView.backgroundColor = .black
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return
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
