//
//  NetworkManager.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/09.
//




import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func ShoppingCallRequest(query: String, display: Int = 30, start: Int = 1, sort: String = "sim", filter: String? = nil, exclude: String? = nil, completion: @escaping ([Item]?) -> Void) {
        
        let baseURL = "https://openapi.naver.com/v1/search/shop.json"
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil)
            return
        }
        
        var parameters: [String: Any] = [
            "query": encodedQuery,
            "display": display,
            "start": start,
            "sort": sort
        ]
        
        if let filter = filter {
            parameters["filter"] = filter
        }
        
        if let exclude = exclude {
            parameters["exclude"] = exclude
        }
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.XNaverClientId,
            "X-Naver-Client-Secret": APIKey.XNaverClientSecret
        ]
        
        AF.request(baseURL, method: .get, parameters: parameters, headers: headers).validate(statusCode: 200...500).responseDecodable(of: Shop.self) { response in
            
            if let statusCode = response.response?.statusCode {
                print("===1111===Status Code: \(statusCode)")
            }
            
            switch response.result {
            case .success(let value):
                completion(value.items)
                
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
