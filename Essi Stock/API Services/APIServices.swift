//
//  APIServices.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case missingData
}


class APIServices: ObservableObject{
    
    @Published var items: [ItemModel] = []
    @Published var isFavorites : [Item] = []
    @Published var itemsCart : [Item] = []
    
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
        let marque = item.marque
        let reference = item.reference
        let image = item.image
        let price = item.price
        let isFavorite = item.isFavorite
        let desiredQuantity = quantityDesired
        
        
        let newItem = Item(id: id, marque: marque, reference: reference, image: image, price: price, isFavorite: isFavorite, desiredQuantity: desiredQuantity)
        
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
            itemsCart[index] = Item(id: id, marque: marque, reference: reference, image: image, price: price, isFavorite: isFavorite, desiredQuantity: itemsCart[index].desiredQuantity + quantityDesired)
            
            //if new item doesn't exist in itemCart, it will be added
        } else {
            print("DEBUG: Add new item in cart")
            itemsCart.append(newItem)
        }
    }
}
