//
//  ItemCellHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ItemCellHelper: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @Binding var showCartView: Bool
    
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
                        .multilineTextAlignment(.center)
                    Text("\(item.price)€")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                Spacer()
                VStack{
                    Spacer()
                Button(action: {
                    apiServices.getItemIndex(item: item, completionHandler: {catIndex, catL1Index, catL2Index, itemIndex in
                        apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite.toggle()
                        
                        
                        
                    })
                }, label: {
                    Image(systemName: item.isFavorite ? "heart.fill": "heart" )
                        .foregroundColor(.red)
                })
                }
            }
        }
    
}


/*
 struct ItemCellHelper_Previews: PreviewProvider {
 static var previews: some View {
 
 ItemCellHelper(item: $item)
 }
 }
 */
