//
//  CategoritesLevelOneView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesLevelOneView: View {
    
    @Binding var categorite: ItemModel
    
    var body: some View {
        List($categorite.categoritesLevelOne){ $categoriteLevelOne in
            NavigationLink(destination: CategoritesLevelTwoView(categoriteLevelOne: $categoriteLevelOne)){
                Text(categoriteLevelOne.name)
            }
            .isDetailLink(false)
        }
        .onAppear(){
            print(categorite)
        }
        .listStyle(.plain)
        .navigationTitle(categorite.name)
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


