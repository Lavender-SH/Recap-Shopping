//
//  WebViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/09.
//

import Foundation
import WebKit


class WebViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    var productID: String?
    var webViewTitle: String?
    
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart.fill"), style: .plain, target: self, action: #selector(detailLikeButtonTapped))
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
        }
    }
    
    @objc func backToMainView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func detailLikeButtonTapped() {
        
    }
    
}
