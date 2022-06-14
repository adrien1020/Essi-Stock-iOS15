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
}
