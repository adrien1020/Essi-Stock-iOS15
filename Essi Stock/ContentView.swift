//
//  ContentView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var apiServices =  APIServices()
    @StateObject var tabState = TabState()
    
    @State var searchText = ""
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $tabState.selectedTab) {
                HomeView()
                    .environmentObject(tabState)
                    .onAppear(perform: {
                        tabState.lastSelectedTab = TabState.Tab.first
                    })
                    .tag(TabState.Tab.first)
                CategoritesView()
                    .environmentObject(tabState)
                    .tag(TabState.Tab.second)
                SearchView()
                    .onAppear(perform: {
                        tabState.lastSelectedTab = TabState.Tab.third
                    })
                    .tag(TabState.Tab.third)
            }
            .onReceive(tabState.$selectedTab) { selection in
                if selection == tabState.lastSelectedTab {
                    //tabState.showTabRoots[selection.rawValue] = false
                    for i in tabState.iconName.indices{
                        if selection.rawValue == tabState.iconName[i]{
                            tabState.showTabRoots[i] = false
                        }
                    }
                }
            }
            .environmentObject(apiServices)
            Divider()
            HStack{
                ForEach(tabState.iconName.indices, id:\.self) { index in
                    Spacer()
                    TabButton(index: index)
                        .environmentObject(tabState)
                    Spacer()
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(){
            fetchData(apiServices: apiServices)
        }
    }
}

struct TabButton: View {
    @EnvironmentObject var tabState: TabState

    var index: Int
    
    var body: some View {
        Button(action: {
            
            switch index{
            case 0:
                tabState.selectedTab = .first
            case 1:
                tabState.selectedTab = .second
            case 2:
                tabState.selectedTab = .third
            default:
                tabState.selectedTab = .first
            }
            closeKeyboard()
        }, label: {
            Image(systemName: tabState.iconName[index])
                .font(.system(size: 25))
                .foregroundColor(tabState.selectedTab.rawValue == tabState.iconName[index] ? Color("Orange Color") : .black.opacity(0.4))
                .padding()
        })
    }
}

extension View{
    func closeKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func fetchData(apiServices: APIServices){
        Task{
            do {
                print("DEBUG: Download data")
                try await apiServices.fetchData(urlString: "http://127.0.0.1:8000/api/")
            } catch RequestError.invalidURL{
                print("DEBUG: Invalid URL")
            } catch RequestError.missingData{
                print("DEBUG: Missing data")
            }
            let generator = UINotificationFeedbackGenerator()
            await generator.notificationOccurred(.success)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
