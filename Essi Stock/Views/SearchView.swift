//
//  SearchView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    @State var searchText = ""
    @State var items: [Item] = []
    @State var alreadySearched : [String] = []
    @State private var showCartView = false
    @State var result: Item?
    
    var body: some View {
        VStack{
            SearchBarHelper(searchText: $searchText)
            if alreadySearched.isEmpty && searchText == ""{
                VStack{
                    Spacer()
                    VStack(spacing: 20){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black.opacity(0.6))
                            .font(.system(size: 60))
                        Text("Rechercher sur Essi Stock")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Trouvez vos prochaines pièces.")
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 50)
                    Spacer()
                }
            } else if !alreadySearched.isEmpty && searchText.isEmpty {
                VStack{
                    List(alreadySearched, id:\.self){searched in
                        Text(searched)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                withAnimation(.easeIn){
                                    searchText = searched
                                }
                            }
                    }.listStyle(.plain)
                    Button(action: {
                        withAnimation(.easeOut){
                            alreadySearched.removeAll()
                        }
                    }, label: {
                        Text("Tout Effacer")
                    })
                    Spacer()
                }
                Spacer()
            }
            else {
                List{
                    ForEach(searchResults){result in
                        Button(action: {
                            self.result = result
                            alreadySearched.append(searchText)
                            closeKeyboard()
                        }, label: {
                            ItemCellHelper(item: result)
                        })
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText)
                .sheet(item: $result, content: {item in
                    DetailsView(showCartView: $showCartView, item: item)
                })
                .sheet(isPresented: $showCartView, content: {
                    CartView()
                })
            }
        }
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return apiServices.allItems.filter { ($0.marque.localizedCaseInsensitiveContains(searchText)) ||
                ($0.designation.localizedCaseInsensitiveContains(searchText)) ||
                ($0.reference.localizedCaseInsensitiveContains(searchText)) ||
                ($0.JDE.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
}
