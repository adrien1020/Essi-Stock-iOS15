//
//  HomeViewBuilder.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct HomeViewBuilderHelper<Content:View>: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @Binding var searchText: String
    @Binding var currentTab: TabModel
    
    var animation: Namespace.ID
    let tabs : [TabModel]
    let content: Content
    
    init(searchText: Binding<String>, currentTab: Binding<TabModel>, animation: Namespace.ID, tabs : [TabModel], @ViewBuilder content: () -> Content){
        self._searchText = searchText
        self._currentTab = currentTab
        self.animation = animation
        self.tabs = tabs
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing:8){
            SearchBarHelper(searchText: $searchText)
            SegmentedControlHelper(currentTab: $currentTab, animation: animation, tabs: tabs)
            content
        }
    }
}

/*
struct HomeViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewBuilder()
    }
}
*/
