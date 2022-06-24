//
//  CategoritesLevelOneView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesLevelOneView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    var categorite: ItemModel
    
    var body: some View {
        List(categorite.categoritesLevelOne){ categoriteLevelOne in
            NavigationLink(destination: CategoritesLevelTwoView(categoriteLevelOne: categoriteLevelOne).environmentObject(apiServices)){
                Text(categoriteLevelOne.name)
            }
            .isDetailLink(false)
        }
        .listStyle(.plain)
        .navigationTitle(categorite.name)
        .refreshable {
            fetchData(apiServices: apiServices)
        }
    }
}


struct CategoritesLevelOneView_Previews: PreviewProvider {
    static let apiServices = APIServices()
    static var previews: some View {
        
        VStack{
            if !apiServices.items.isEmpty{
                CategoritesLevelOneView(categorite: apiServices.items[0])
                    .environmentObject(apiServices)
            }
        }
        .onAppear{
            Task{
                do {
                    print("DEBUG: Download data")
                    try await apiServices.fetchData(urlString: "http://127.0.0.1:8000/api/")
                } catch RequestError.invalidURL{
                    print("DEBUG: Invalid URL")
                } catch RequestError.missingData{
                    print("DEBUG: Missing data")
                }
            }
            
        }
        
    }
}



