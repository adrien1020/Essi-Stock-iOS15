//
//  ItemCartHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 20/06/2022.
//

import SwiftUI

struct ItemCartHelper: View {
    @EnvironmentObject var apiServices: APIServices
    
    @State var changeQuantity = ""
    var item: Item
    var body: some View {
        HStack(spacing: 6){
            AsyncImage(url: URL(string: item.image),
                       content: { image in
                image
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(10)
            },placeholder: {
                Color.gray.opacity(0.7)
                    .frame(width: 120, height: 120)
            })
            VStack(alignment: .leading, spacing: 6){
                Text(item.marque)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                Text(item.reference)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.4))
                    .lineLimit(1)
                Text("\(item.price)€")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
                HStack{
                    Spacer()
                    Text("qte:")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.4))
                        .multilineTextAlignment(.center)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5),lineWidth: 1)
                        .frame(width:25, height: 25)
                        .overlay(
                            TextField(text: $changeQuantity , label: {
                            }).multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                            
                                .onSubmit {
                                    print("Submit")
                                }
                        )
                }
            
        }
        .padding()
        .onAppear{
            changeQuantity = String(item.desiredQuantity)
        }
    }
}

struct ItemCartHelper_Previews: PreviewProvider {
    static var previews: some View {
        ItemCartHelper(item: Item(id: 1, marque: "Schneider", reference: "1344", image: "AA", price: "122222"))
    }
}
