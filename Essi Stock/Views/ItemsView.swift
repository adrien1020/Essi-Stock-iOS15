//
//  ItemsView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ItemsView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State private var showCartView = false
    @State private var item : Item?
    
    var categoriteLevelTwo: CategoritesLevelTwo
    
    var body: some View {
        List(categoriteLevelTwo.items){item in
            Button(action: {
                self.item = item
                
            }, label: {
                ItemCellHelper(item: item)
                
            })
            .listRowInsets(EdgeInsets(top: 4,leading: 8, bottom: 4, trailing: 8))
        }
        .listStyle(.plain)
        .refreshable {
            fetchData(apiServices: apiServices)
        }
        .navigationTitle(categoriteLevelTwo.name)
        .sheet(isPresented: $showCartView, content: {
            CartView()
        })
        .sheet(item: $item, content: {item in
            DetailsView(showCartView: $showCartView, item: item)
        })
    }
}

/*
struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
*/
