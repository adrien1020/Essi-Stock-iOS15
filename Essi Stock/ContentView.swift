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
    @StateObject var tabStateVM = TabStateViewModel()
    
    @State private var searchText = ""
    
    var iconName = ["house.fill","person.fill","magnifyingglass"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $tabStateVM.selectedTab) {
                HomeView()
                    .environmentObject(tabStateVM)
                    .onAppear(perform: {
                        tabStateVM.lastSelectedTab = Tab.first
                    })
                    .tag(Tab.first)
                PersonalView()
                    .environmentObject(tabStateVM)
                    .onAppear(perform: {
                        tabStateVM.lastSelectedTab = Tab.second
                    })
                    .tag(Tab.second)
                SearchView()
                    .onAppear(perform: {
                        tabStateVM.lastSelectedTab = Tab.third
                    })
                    .tag(Tab.third)
            }
            .onReceive(tabStateVM.$selectedTab) { selection in
                if selection == tabStateVM.lastSelectedTab {
                    tabStateVM.showTabRoots[selection.rawValue] = false
                    print(tabStateVM.showTabRoots)
                    }
                }
            }
            .environmentObject(apiServices)
            Divider()
            HStack{
                ForEach(iconName.indices, id:\.self) { index in
                    Spacer()
                    TabButton(iconName: iconName[index], index: index)
                        .environmentObject(tabStateVM)
                    Spacer()
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        
        .ignoresSafeArea(.keyboard)
        .onAppear(){
            fetchData(apiServices: apiServices)
        }
    }
}

struct TabButton: View {
    
    @EnvironmentObject var tabState: TabStateViewModel
    
    var iconName: String
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
            Image(systemName: iconName)
                .font(.system(size: 25))
                .foregroundColor(tabState.selectedTab.rawValue == index ? Color("Orange Color") : .black.opacity(0.4))
                .padding()
        })
    }
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

extension View{
    func closeKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



