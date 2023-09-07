//
//  BaseViewController.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        //print("Base ConfigureView")
    }
    
    
    func setConstraints() {
       // print("Base setConstraitns")
    }
    
}
