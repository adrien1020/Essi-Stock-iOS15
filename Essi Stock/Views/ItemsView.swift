//
//  ItemsView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ItemsView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var navigateToDetailsView = false
    @State var showCartView = false
    
    var categoriteLevelTwo: CategoritesLevelTwo
    
    var body: some View {
        List(categoriteLevelTwo.items){item in
            Button(action: {
                navigateToDetailsView.toggle()
            }, label: {
                ItemCellHelper(navigateToDetailsView: $navigateToDetailsView, showCartView: $showCartView, item: item)
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
    }
}

/*
 struct ItemsView_Previews: PreviewProvider {
 static var previews: some View {
 ItemsView()
 }
 }*/
