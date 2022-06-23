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
    
    var categoriteLevelTwo: CategoritesLevelTwo
    
    @State var item : Item?
    var body: some View {
        List(categoriteLevelTwo.items){item in
            Button(action: {
                self.item = item
            }, label: {
                ItemCellHelper(item: item)
            })
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
 }*/
