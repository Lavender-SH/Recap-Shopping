//
//  MainViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit

class MainViewController: BaseViewController {

    


    var searchController: UISearchController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationUI()

        
        
        
    }
    func makeNavigationUI() {
        view.backgroundColor = .black

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "쇼핑 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }


    

}


