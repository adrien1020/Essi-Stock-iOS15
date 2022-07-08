//
//  ContentView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    
    
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
                    .onAppear(perform: {
                        tabStateVM.lastSelectedTab = Tab.first
                    })
                    .tag(Tab.first)
                    
                PersonalView()
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
            Divider()
        }
        .environmentObject(tabStateVM)
        .environmentObject(apiServices)
            HStack{
                ForEach(iconName.indices, id:\.self) { index in
                    Spacer()
                    TabButton(iconName: iconName[index], index: index)
                        .environmentObject(tabStateVM)
                    Spacer()
                }
            }
        .onAppear(){
            fetchData(apiServices: apiServices)
        }
    }
}

struct TabButton: View {
    @Environment(\.colorScheme) var colorScheme
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
                .padding(.vertical, 6)
        })
    }
}
    
    func fetchData(apiServices: APIServices){
        Task{
            do {
                print("DEBUG: Download data")
                try await apiServices.fetchData(urlString: "http://192.168.1.44:8000/api/")
                let generator = UINotificationFeedbackGenerator()
                await generator.notificationOccurred(.success)
            } catch RequestError.invalidURL{
                print("DEBUG: Invalid URL")
                let generator = UINotificationFeedbackGenerator()
                await generator.notificationOccurred(.error)
            } catch RequestError.missingData{
                print("DEBUG: Missing data")
                let generator = UINotificationFeedbackGenerator()
                await generator.notificationOccurred(.warning)
            }
            
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



