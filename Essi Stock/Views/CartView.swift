//
//  CartView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 16/06/2022.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if apiServices.itemsCart.isEmpty{
            VStack{
                Spacer()
                VStack(spacing: 20){
                    Image(systemName: "cart")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 60))
                    Text("Rien n'a été ajouté au panier pour le moment")
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
        } else {
            VStack{
                Divider()
                ForEach(apiServices.itemsCart.indices, id:\.self){ index in
                    HStack{
                        AsyncImage(url: URL(string: apiServices.itemsCart[index].image),
                                   content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                        },placeholder: {
                            Color.gray.opacity(0.7)
                                .frame(width: 120, height: 120)
                        })
                        HStack{
                            VStack{
                                Text(apiServices.itemsCart[index].marque)
                                Text(apiServices.itemsCart[index].reference)
                                Text("\(apiServices.itemsCart[index].desiredQuantity)")
                            }
                            Button(action: {
                                withAnimation(.easeOut){
                                    var removeIndex = 0
                                    for i in apiServices.itemsCart.indices{
                                        if apiServices.itemsCart[i] == apiServices.itemsCart[index]{
                                            removeIndex = i
                                            break
                                        }
                                    }
                                    apiServices.itemsCart.remove(at: removeIndex)
                                }
                            }, label: {
                                Text("Supprimer")
                                    .foregroundColor(.blue)
                            })
                        }
                    }
                }
                Spacer()
            }
        
    }
           



            
        
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
