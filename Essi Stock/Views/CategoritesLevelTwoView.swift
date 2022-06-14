//
//  CategoritesLevelTwoView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesLevelTwoView: View {
    
    @Binding var categoriteLevelOne: CategoritesLevelOne
    
    var body: some View {
        List($categoriteLevelOne.categoritesLevelTwo){ $categoriteLevelTwo in
                NavigationLink(destination: ItemsView(categoriteLevelTwo: $categoriteLevelTwo)){
                    Text(categoriteLevelTwo.name)
                }
            }
        .listStyle(.plain)
        .navigationTitle(categoriteLevelOne.name)
    }
}


/*
struct CategoritesLevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        CategoritesLevelTwoView()
    }
}
*/
