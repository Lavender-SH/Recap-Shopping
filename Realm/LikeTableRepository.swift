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
    
    //데이터 가져오기 날짜순으로
    func fetch() -> RealmSwift.Results<LikeTable> {
        let data = realm.objects(LikeTable.self).sorted(byKeyPath: "likeDate", ascending: true)
        return data
    }
    //아이템 저장
    func saveItem(_ item: Item) {
        let existingItem = realm.objects(LikeTable.self).where {
            $0.title == item.title
        }.first
        
        if existingItem == nil {
            let likeItem = LikeTable(title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName, likeDate: Date(), likeButton: true)
            try! realm.write {
                realm.add(likeItem)
            }
        }
    }
    //아이템삭제
    func deleteItem<T: TitleProtocol>(_ item: T) {
        if let objectToDelete = realm.objects(LikeTable.self).filter("title == %@", item.title).first {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
    //좋아요 버튼 아이템만 거르기(미완)
    func fetchFilter() -> RealmSwift.Results<LikeTable>{
        let result = realm.objects(LikeTable.self).where {
            $0.likeButton == false
        }
        return result
    }
    //파일경로
    func findFileURL() -> URL? {
        let fileURL = realm.configuration.fileURL // 실제 데이터 저장 파일 경로
        return fileURL
    }
    
}
