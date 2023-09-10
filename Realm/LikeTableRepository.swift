//
//  LikeTableRepository.swift
//  ShoppingRealm
//
//  Created by 이승현 on 2023/09/04.
//

import Foundation
import RealmSwift

protocol LikeTableRepositoryType: AnyObject {
    func saveItem(_ item: Item)
    func fetch() -> Results<LikeTable>
}

class LikeTableRepository: LikeTableRepositoryType {
    private let realm = try! Realm()
    
    //⭐️⭐️⭐️데이터 가져오기 날짜순으로
    func fetch() -> RealmSwift.Results<LikeTable> {
        let data = realm.objects(LikeTable.self).sorted(byKeyPath: "likeDate", ascending: false)
        return data
    }
    
    
    //⭐️⭐️⭐️좋아요 데이터 저장하기
    func saveItem(_ item: Item) {
        let likeItem = LikeTable(title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName, likeDate: Date())
        try! realm.write {
            realm.add(likeItem)
        }
    }
}

