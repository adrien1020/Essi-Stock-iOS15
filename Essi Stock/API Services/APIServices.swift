//
//  APIServices.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import Foundation
import SwiftUI

enum RequestError: Error {
    case invalidURL
    case missingData
}


class APIServices: ObservableObject{
    
    @Published var items: [ItemModel] = []
    @Published var isFavorites : [Item] = []
    @Published var itemsCart : [Item] = []
    @Published var recentes : [Item] = []
    
    func fetchData(urlString: String) async throws {
        guard let url = URL(string: urlString) else {throw RequestError.invalidURL}
        guard let (data, resp) = try? await URLSession.shared.data(from: url) else{throw RequestError.invalidURL}
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {throw RequestError.invalidURL}
        let decoder = JSONDecoder()
        guard let jsonResponse = try? decoder.decode([ItemModel].self, from: data) else {throw RequestError.missingData}
        DispatchQueue.main.async {
            self.items = jsonResponse
        }
    }
    
    func addToRecentes(item:Item){
        var exist = false
        
        for i in recentes.indices{
            if item.id == recentes[i].id{
                print("Exist")
                exist = true
            }
        }
        if !exist{
            self.recentes.append(item)
            if self.recentes.count == 10{
                self.recentes.remove(at: 0)
            }
        
            
            
        }
    }
    
    
    
    
    func addToFavorites(item:Item){
        var removeIndex = 0
        withAnimation(.easeInOut){
            if item.isFavorite{
                isFavorites.append(item)
            }else {
                for i in isFavorites.indices{
                    if isFavorites[i].id == item.id{
                        removeIndex = i
                    }
                }
                isFavorites.remove(at: removeIndex)
            }
        }
    }
    
    func getItemIndex(item:Item, completionHandler: @escaping (_ catIndex: Int, _ catL1Index: Int, _ caL2Index: Int, _ itemIndex: Int) -> Void){
        for catIndex in items.indices{
            for catL1Index in items[catIndex].categoritesLevelOne.indices{
                for catL2Index in items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo.indices{
                    for itemIndex in items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items.indices{
                        if item.id == items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].id{
                            completionHandler(catIndex, catL1Index, catL2Index, itemIndex)
                        }
                    }
                }
            }
        }
    }
    
    func addToCart(item: Item, quantityDesired: Int){
        let id = item.id
        let designation = item.designation
        let marque = item.marque
        let reference = item.reference
        let JDE = item.JDE
        let image = item.image
        let description = item.description
        let price = item.price
        let quantity  = item.quantity
        let createdAt = item.createdAt
        let uddatedAt = item.updatedAt
        let isFavorite = item.isFavorite
        
        let newItem = Item(id: id, designation: designation, marque: marque, reference: reference, JDE: JDE, image: image, description: description, price: price, quantity: quantity, createdAt: createdAt, updatedAt: uddatedAt, isFavorite: isFavorite, desiredQuantity: quantityDesired)
        
        //Check if newItem exist in itemsCart array
        var isExist = false
        var index = 0
        for i in itemsCart.indices{
            if newItem.id == itemsCart[i].id{
                isExist = true
                index = i
            }
        }
        
        //if newItem exist in itemCart array, quantity desired will be updated
        if isExist{
            print("DEBUG: Update item in cart")
            itemsCart[index] = Item(id: id, designation: designation, marque: marque, reference: reference, JDE: JDE, image: image, description: description, price: price, quantity: quantity, createdAt: createdAt, updatedAt: uddatedAt, isFavorite: isFavorite, desiredQuantity: itemsCart[index].desiredQuantity + quantityDesired)
            //if new item doesn't exist in itemCart, it will be added
        } else {
            print("DEBUG: Add new item in cart")
            itemsCart.append(newItem)
        }
    }
}
