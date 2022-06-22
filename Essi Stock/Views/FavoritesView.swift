//
//  FavoritesView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var catIndex = 0
    @State var catL1Index = 0
    @State var catL2Index = 0
    
    var filteredFavoritesItems: [Item] {
        apiServices.getAllIndex(completionHandler: {catIndex, catL1Index, catL2Index, itemIndex in
            DispatchQueue.main.async {
                self.catIndex = catIndex
                self.catL1Index = catL1Index
                self.catL2Index = catL2Index
            }
        })
        return apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items.filter{
            item in
            item.isFavorite
        }
    }
    
    var body: some View {
        VStack{
            if !apiServices.items.isEmpty{
                List(filteredFavoritesItems){item in
                    Text(item.marque)
                }
                Spacer()
            } else {
                Spacer()
                VStack(spacing: 20){
                    Image(systemName: "heart.fill")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 60))
                    Text("Rien n'a été ajouté au favories pour le moment")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Enregister des articles en favoris pour les retrouver encore plus vite.")
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 50)
                Spacer()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
