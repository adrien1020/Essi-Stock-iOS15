//
//  CategoritesLevelOneView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesLevelOneView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    @Binding var categorite: ItemModel
        
    var body: some View {
        List($categorite.categoritesLevelOne){ $categoriteLevelOne in
            NavigationLink(destination: CategoritesLevelTwoView(categoriteLevelOne: $categoriteLevelOne).environmentObject(apiServices)){
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

/*
struct CategoritesLevelOneView_Previews: PreviewProvider {
    @State static var modelData = APIServices()
    static var previews: some View {
        CategoritesLevelOneView(categorite: $modelData.items[0])
            .environmentObject(modelData)
    }
}
*/


