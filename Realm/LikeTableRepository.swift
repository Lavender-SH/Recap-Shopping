//
//  LikeTableRepository.swift
//  ShoppingRealm
//
//  Created by 이승현 on 2023/09/04.
//

import Foundation
import RealmSwift

protocol LikeTableRepositoryType: AnyObject {
    func fetch() -> Results<LikeTable>
    func saveItem(_ item: Item)
    func fetchFilter() -> Results<LikeTable>
    func findFileURL() -> URL?
}

class LikeTableRepository: LikeTableRepositoryType {
    private let realm = try! Realm()
    
    //⭐️⭐️⭐️데이터 가져오기 날짜순으로
    func fetch() -> RealmSwift.Results<LikeTable> {
        let data = realm.objects(LikeTable.self).sorted(byKeyPath: "likeDate", ascending: true)
        return data
    }
    
    
    func saveItem(_ item: Item) {
        let existingItem = realm.objects(LikeTable.self).where {
            $0.title == item.title
        }.first
        
        if existingItem == nil {
            let likeItem = LikeTable(title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName, likeDate: Date())
            try! realm.write {
                realm.add(likeItem)
            }
        }
    }
    
    func deleteItem(_ item: Item) {
        let data = realm.objects(LikeTable.self).where {
            $0.likeButton == true
        }
        
        try! realm.write {
            realm.delete(data)
        }
    }
    
    
    //⭐️⭐️⭐️좋아요 데이터 저장하기
    //    func saveItem(_ item: Item) {
    //        let likeItem = LikeTable(title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName, likeDate: Date())
    //        try! realm.write {
    //            realm.add(likeItem)
    //        }
    //    }
    //
    //    func isItemLiked(item: Item) -> Bool {
    //        let existingItem = realm.objects(LikeTable.self).filter("title == %@", item.title).first
    //        return existingItem != nil
    //    }
    
    func fetchFilter() -> RealmSwift.Results<LikeTable>{
        let result = realm.objects(LikeTable.self).where {
            $0.likeButton == false
        }
        return result
    }
    
    func findFileURL() -> URL? {
        let fileURL = realm.configuration.fileURL // 실제 데이터 저장 파일 경로
        return fileURL
    }
    
}

