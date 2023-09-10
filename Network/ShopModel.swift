//
//  ShopModel.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/09.
//
import Foundation

// MARK: - Shop
struct Shop: Codable {
    let start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, TitleProtocol {
    let title: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productID: String?
    


    enum CodingKeys: String, CodingKey {
        case title, image, lprice, hprice, mallName
        case productID = "productId"
    }
}



