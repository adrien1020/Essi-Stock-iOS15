//
//  FavoritesView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var item : Item?
    
    @State var showCartView = false
    
    var body: some View {
        
        if !apiServices.isFavorites.isEmpty{
            List(apiServices.isFavorites){item in
                Button(action: {
                    
                }, label: {
                    ItemCellHelper(item: item)
                        .onTapGesture {
                            self.item = item
                        }
                })
                .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            .listStyle(.plain)
            .sheet(isPresented: $showCartView, content: {
                CartView()
            })
            .sheet(item: $item, content: {item in
                DetailsView(showCartView: $showCartView, item: item)
            })
        }else{
            VStack{
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
            .navigationBarHidden(true)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(APIServices())
    }
}
