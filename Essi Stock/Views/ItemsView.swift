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
    
    @State var navigateToDetailsView  = false
   
    //@State var item: Item
    
    var body: some View {
        List($categoriteLevelTwo.items){$item in
            NavigationLink(destination: DetailsView(item: $item)){
                
                ItemCellHelper(item: $item)
                
                
            }
            
            /*
            Button(action: {
                //self.item = item
                //navigateToDetailsView.toggle()
            }, label: {
                
            })*/
            
        }
        .listStyle(.plain)
        .refreshable {
            fetchData(apiServices: apiServices)
        }
        .navigationTitle(categoriteLevelTwo.name)
        /*
        .sheet(isPresented: $navigateToDetailsView, content: {
            DetailsView(item: $item)
                .environmentObject(apiServices)
        })*/
    }
        
}

/*
struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}*/
