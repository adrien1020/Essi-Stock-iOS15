//
//  ContentView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var apiServices =  APIServices()
    
    @State var selectedTab = "house.fill"
    @State var searchText = ""
    
    var iconName = ["house.fill","person.fill","magnifyingglass"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $selectedTab) {
                CategoritesView(selectedTab: $selectedTab)
                    .environmentObject(apiServices)
                    .tag(iconName[0])
                CategoritesView(selectedTab: $selectedTab)
                    .environmentObject(apiServices)
                    .tag(iconName[1])
                SearchView()
                    .environmentObject(apiServices)
                    .tag(iconName[2])
            }
            Divider()
            HStack{
                ForEach(iconName, id: \.self) { image in
                    Spacer()
                    TabButton(selectedTab: $selectedTab, image: image)
                    Spacer()
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(){
            Task{
                do {
                    print("DEBUG: Download data")
                    try await apiServices.fetchData(urlString: "http://127.0.0.1:8000/api/")
                } catch RequestError.invalidURL{
                    print("DEBUG: Invalid URL")
                } catch RequestError.missingData{
                    print("DEBUG: Missing data")
                }
            }
        }
    }
}

struct TabButton: View {
    
    @Binding var selectedTab: String
    
    var image: String
    
    var body: some View {
        Button(action: {
            selectedTab = image
            closeKeyboard()
        }, label: {
            Image(systemName: image)
                .font(.system(size: 25))
                .foregroundColor(selectedTab == image ? Color("Orange Color") : .black.opacity(0.4))
                .padding()
        })
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
