//
//  CategoritesView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct CategoritesView: View {
    
    @EnvironmentObject var apiServices : APIServices
    @EnvironmentObject var tabStateVM: TabStateViewModel
    @State var searchText = ""
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum:150), spacing: 4)]
    
    var body: some View {
            ScrollView{
                LazyVGrid(columns: columns, spacing: 12){
                    ForEach(apiServices.items){ categorite in
                        NavigationLink(destination: CategoritesLevelOneView(categorite: categorite), isActive: $tabStateVM.showTabRoots[Tab.first.rawValue]){
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
    }
}


struct CategoritesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoritesView()
    }
}
