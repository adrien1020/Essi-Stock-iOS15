//
//  ItemModel.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import Foundation

//MARK: - ItemModel
struct ItemModel: Hashable, Codable, Identifiable{
    var id: Int
    let name: String
    let icon: String
    var categoritesLevelOne: [CategoritesLevelOne]
    
    enum CodingKeys: String, CodingKey {
            case id, name, icon
            case categoritesLevelOne = "categorites_level_one"
        }
    
   
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        icon = try values.decode(String.self, forKey: .icon)
        categoritesLevelOne = try values.decode([CategoritesLevelOne].self, forKey: .categoritesLevelOne)
    }
}

// MARK: - CategoriesLeveOne
struct CategoritesLevelOne: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    var categoritesLevelTwo: [CategoritesLevelTwo]
    
   enum CodingKeys: String, CodingKey {
            case id, name
            case categoritesLevelTwo = "categorites_level_two"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        categoritesLevelTwo = try values.decode([CategoritesLevelTwo].self, forKey: .categoritesLevelTwo)
    }
}

// MARK: - CategoriesLevelTwo
struct CategoritesLevelTwo: Hashable,Codable, Identifiable {
    let id: Int
    let name: String
    var items: [Item]
}

// MARK: - Item
struct Item: Hashable, Identifiable, Codable{
    let id: Int
    var marque: String
    let reference: String
    let image: String
    let price: String
    var isFavorite = false
    var desiredQuantity = 1
    
    enum CodingKeys: String, CodingKey {
             case id, marque, reference, image, price
             
     }
}
