//
//  PersonalView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import SwiftUI

struct PersonalView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var searchText = ""
    @State private var currentTab = TabModel(name: "Favorites", icon: "heart")
    
    @Namespace var animation
    
    private let tabs = [TabModel(name: "Favorites", icon: "heart"),
                        TabModel(name: "Recentes", icon: "folder.badge.plus")]
    
    
    var body: some View {
        HomeViewBuilderHelper(searchText: $searchText, currentTab: $currentTab, animation: animation, tabs: tabs, content: {
            PersonalPagesSelection()
                .environmentObject(apiServices)
                .onTapGesture {
                    closeKeyboard()
                }
            Spacer()
        })
    }
    
    @ViewBuilder func PersonalPagesSelection ()-> some View {
        switch currentTab{
        case .init(name: "Favorites", icon: "heart"):
            FavoritesView()
                .environmentObject(apiServices)
        case .init(name: "Recentes", icon: "folder.badge.plus"):
            RecentesView()
        default:
            Text("La vue n'éxiste pas")
        }
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView()
    }
}
