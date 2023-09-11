//
//  Protocol.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/11.
//

import Foundation

// MARK: - LikeCollectionViewCell.configure 함수에 필요한 프로토콜
protocol DisplayableItem {
    var mallName: String { get }
    var title: String { get }
    var lprice: String { get }
    var image: String { get }
}

// MARK: - LikeTableRepository.deleteItem 함수에 필요한 프로토콜
protocol TitleProtocol {
    var title: String { get }
}
