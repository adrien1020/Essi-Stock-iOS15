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
    
    @State private var showCartView = false
    @State var result: Item?
    
    var body: some View {
        VStack{
            SearchBarHelper(searchText: $searchText)
            if items.isEmpty && searchText.isEmpty{
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
            } else {
                List{
                    ForEach(searchResults){result in
                        
                        Button(action: {
                            self.result = result
                        }, label: {
                            ItemCellHelper(item: result)
                        })
                    }
                }
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
