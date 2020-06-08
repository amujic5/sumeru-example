//
//  Mall.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 05/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import Foundation

class Mall: Codable {
    let featuredItems: [FeaturedItem]
    let categories: [Category]
    let stores: [Store]
}

class FeaturedItem: Codable {
    let imageUrl: String?
}

class Category: Codable {
    let id: String
    let name: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, imageUrl
    }
    
    var stores: [Store] = []
}

class Store: Codable {
    let id: String
    let name: String
    let imageUrl: String?
    let logoUrl: String?
    let storeUrl: String
    let description: String?
    let categories: [String]?
    let discount: Discount?
    
    enum CodingKeys: String, CodingKey {
        case id, name, imageUrl, logoUrl, storeUrl, description, categories, discount
    }
    
    var categoryModels: [Category] = []
}

class Discount: Codable {
    let info: String?
}
