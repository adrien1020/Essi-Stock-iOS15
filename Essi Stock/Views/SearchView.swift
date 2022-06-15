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
    
    var body: some View {
        VStack{
            SearchBarHelper(searchText: $searchText)
            if apiServices.items.isEmpty{
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
                        Text(result.marque)
                    }
                }
                .searchable(text: $searchText)
            }
        }
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { ($0.marque.localizedCaseInsensitiveContains(searchText))}
        }
    }
}
