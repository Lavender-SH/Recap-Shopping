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

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationUI()
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
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
    
    @objc func cancelButtonTapped() {
        
        navigationController?.popViewController(animated: true)
    }
    

    override func configureView() {
        super.configureView()
        
        [mainView.accuracyButton, mainView.dateButton, mainView.upPriceButton, mainView.downPriceButton].forEach {
            $0.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        }
    }
        
    @objc func toggleButtonColor(sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
        } else {
            sender.backgroundColor = .black
            sender.setTitleColor(.gray, for: .normal)
        }
    }
    
    
    override func setConstraints() {

    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("검색함: \(searchBar.text ?? "")")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.toggleLike()
        return cell
    }
    
}

