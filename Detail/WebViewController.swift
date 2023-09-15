//
//  WebViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/09.
//

import Foundation
import WebKit
import RealmSwift


class WebViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    var productID: String?
    var likeProductID: String?
    var webViewTitle: String?
    var item: Item?
    var likeItem: LikeTable?
    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    var likeViewWillAppear: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //네비게이션바
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(detailLikeButtonTapped))
        navigationItem.title = webViewTitle
        navigationController?.navigationBar.tintColor = .white
        
        //백버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("쇼핑 검색", for: .normal)
        backButton.addTarget(self, action: #selector(backToMainView), for: .touchUpInside)
        backButton.tintColor = .white
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        //탭바
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .black
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        if let productID = productID {
            let urlString = "https://msearch.shopping.naver.com/product/\(productID)"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else if let likeProductID = likeProductID {
            let urlString = "https://msearch.shopping.naver.com/product/\(likeProductID)"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }

        
    }
    override func viewWillAppear(_ animated: Bool) {
        checkIfProductIsLiked()
        //        let likeVC = LikeViewController()
        //        likeVC.likeView.collectionView.reloadData()
        print(#function, "==7777==")
    }
    //백버튼 뒤로 돌아가기
    @objc func backToMainView() {
        navigationController?.popViewController(animated: true)
        //        viewWillAppear(true)
    }
    
    //MARK: - 좋아요 버튼 눌렀을때 정보를 저장하는 로직
    @objc func detailLikeButtonTapped() {
        isLiked.toggle()
        if isLiked { print("=5=", isLiked)
            guard let item = self.item else { return }
            let repository = LikeTableRepository()
            repository.saveItem(item)
            
        } else { print("=6=", isLiked)
            let repository = LikeTableRepository()
            if let item = self.item {
                repository.deleteItem(item)
            } else {
                guard let likeItem = self.likeItem else { return }
                repository.deleteItem(likeItem)
            }
        }
    }
    
    //하트버튼 이미지 변경
    private func updateLikeButtonImage() {
        let imageName = isLiked ? "suit.heart.fill" : "suit.heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    func checkIfProductIsLiked() {
        let repository = LikeTableRepository()
        let likedItems = repository.fetch()
        if let productID = self.productID, likedItems.contains(where: { $0.productID == productID }) {
            isLiked = true
        } else {
            isLiked = false
        }
    }
    
}
