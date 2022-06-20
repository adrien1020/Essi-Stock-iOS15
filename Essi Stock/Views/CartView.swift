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
                
                ForEach(apiServices.itemsCart){ item in
                    Divider()
                    ItemCartHelper(item: item)
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
