//
//  ContentView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = "house.fill"
    @Environment(\.colorScheme) var colorScheme
    var iconName = ["house.fill","person.fill","magnifyingglass"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $selectedTab) {
                CategoritesView()
                    .tag(iconName[0])
                CategoritesView()
                    .tag(iconName[1])
                CategoritesView()
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
    }
}

struct TabButton: View {
    
    @Binding var selectedTab: String
    
    var image: String
    
    var body: some View {
        Button(action: {
            selectedTab = image
        }, label: {
            Image(systemName: image)
                .font(.system(size: 25))
                .foregroundColor(selectedTab == image ? Color("Orange Color") : .black.opacity(0.4))
                .padding()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
