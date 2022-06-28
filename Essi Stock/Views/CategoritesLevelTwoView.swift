//
//  CategoritesLevelTwoView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesLevelTwoView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    var categoriteLevelOne: CategoritesLevelOne
   
    var body: some View {
        List(Array(categoriteLevelOne.categoritesLevelTwo.enumerated()), id:\.offset){ catL2Index, categoriteLevelTwo in
                NavigationLink(destination: ItemsView(categoriteLevelTwo: categoriteLevelTwo)){
                    Text(categoriteLevelTwo.name)
                }
            }
        .listStyle(.plain)
        .navigationTitle(categoriteLevelOne.name)
        .refreshable {
            fetchData(apiServices: apiServices)
        }
    }
}


/*
struct CategoritesLevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        CategoritesLevelTwoView()
    }
}
*/
