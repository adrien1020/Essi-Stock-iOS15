//
//  HomeView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var apiServices: APIServices
    @EnvironmentObject var tabState: TabState
    @State var searchText = ""
    @State private var currentTab = TabModel(name: "Principal", icon: "folder")
    
    @Namespace var animation
    
    private let tabs = [TabModel(name: "Principal", icon: "folder"),
                        TabModel(name: "Catégorites", icon: "circle.grid.2x2")]
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        
        //forgreoundColor of navigation title
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(.black)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        
        //backgroundcolor of navigation bar
        navBarAppearance.backgroundColor = .white
        
        //clear navigation bar divider
        navBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        //tintColor of back navigation button
        UINavigationBar.appearance().tintColor = UIColor(named: "Orange Color")
    }
    
    var body: some View {
        NavigationView{
            HomeViewBuilderHelper(searchText: $searchText, currentTab: $currentTab, animation: animation, tabs: tabs, content: {
                PagesSelection()
                    .onTapGesture {
                        closeKeyboard()
                    }
                Spacer()
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .environmentObject(apiServices)
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder func PagesSelection () -> some View {
        switch currentTab{
        case .init(name: "Principal", icon: "folder"):
            MainView()
                
        case .init(name: "Catégorites", icon: "circle.grid.2x2"):
            CategoritesView()
                .environmentObject(apiServices)
                .environmentObject(tabState)
        default:
            Text("La vue n'éxiste pas")
        }
    }
}

/*
 struct HomeView_Previews: PreviewProvider {
 static var previews: some View {
 HomeView()
 }
 }
 */
