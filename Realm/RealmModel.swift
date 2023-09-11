//
//  RealmModel.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/10.
//

import Foundation
import RealmSwift

import RealmSwift

class LikeTable: Object, TitleProtocol, DisplayableItem {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var likeDate: Date
    @Persisted var likeButton: Bool

    convenience init(title: String, image: String, lprice: String, mallName: String, likeDate: Date, likeButton: Bool) {
        self.init()
        
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.likeDate = likeDate
        self.likeButton = false
    }
}
