//
//  MallService.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 04/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import Foundation
import Alamofire

class MallService {
    
    static let shared = MallService()
    
    var mall: Mall?
    
    func getMall(forceRefresh: Bool, success: @escaping (_ mall: Mall) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        if let mall = mall, !forceRefresh {
            success(mall)
            return
        }
        
        let url = URL(string: "https://demo1147402.mockable.io/mall")!
        
        AF
            .request(url)
            .responseDecodable(of: Mall.self) { (response) in
                switch response.result {
                case .success(let mall):
                    self.mall = self.combineMall(mall: mall)
                    success(mall)
                case .failure(let error):
                    failure(error)
                }
        }
        
    }
    
    private func combineMall(mall: Mall) -> Mall {
        
        var categoryMap: [String: Category] = [:]
        mall.categories.forEach { (category) in
            categoryMap[category.id] = category
        }
        
        mall.stores.forEach { (store) in
            store.categories?.forEach({ (categoryId) in
                if let category = categoryMap[categoryId] {
                    store.categoryModels.append(category)
                    category.stores.append(store)
                }
            })
        }
        
        return mall
    }
    
}
