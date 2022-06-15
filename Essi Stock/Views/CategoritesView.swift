//
//  CategoritesView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    @State var searchText = ""
    
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum:150), spacing: 4)]
    
    
    init(selectedTab : Binding<String>) {
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
            VStack{
            SearchBarHelper(searchText: $searchText)
            ScrollView{
                LazyVGrid(columns: columns, spacing: 12){
                    ForEach($apiServices.items){ $categorite in
                        NavigationLink(destination: CategoritesLevelOneView(categorite: $categorite)){
                            VStack{
                                AsyncImage(url: URL(string: categorite.icon),
                                           content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 185, height: 185)
                                },placeholder: {
                                    Color.gray.opacity(0.7)
                                        .frame(width: 185, height: 185)
                                })
                                .overlay(
                                    VStack{
                                        Spacer()
                                        Text(categorite.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                        .padding(.bottom, 9)
                                )
                            }
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(20)
                            .padding(.leading, 6)
                            .padding(.trailing, 6)
                        }
                    }
                }
                .padding(.top, 6)
            }
            .onTapGesture {
                closeKeyboard()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
        .navigationViewStyle(.stack)
    }
}


struct CategoritesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoritesView(selectedTab: .constant("house.fill"))
    }
}
