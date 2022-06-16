//
//  ItemsView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ItemsView: View {
    
    @EnvironmentObject var apiServices: APIServices
    @Binding var categoriteLevelTwo: CategoritesLevelTwo
    
    var body: some View {
        List($categoriteLevelTwo.items){$item in
            Button(action: { 
            }, label: {
                ItemCellHelper(item: $item)
            })
        }
        .listStyle(.plain)
        .refreshable {
            fetchData(apiServices: apiServices)
        }
        .navigationTitle(categoriteLevelTwo.name)
    }
}

/*
struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}*/
