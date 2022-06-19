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
        VStack{
            HStack(spacing: 6){
                AsyncImage(url: URL(string: item.image),
                           content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                },placeholder: {
                    Color.gray.opacity(0.7)
                        .frame(width: 90, height: 90)
                })
                VStack(alignment: .leading, spacing: 8){
                    Text(item.marque)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    Text(item.reference)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                    Text("\(item.price)€")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                    Text(String(item.id))
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                Spacer()
                Button(action: {
                    //item.isFavorite.toggle()
                    apiServices.getItemIndex(item: item, completionHandler: {catIndex, catL1Index, catL2Index, itemIndex in
                        
                        apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite.toggle()
                        
                        
                    })
                    
                    
                    
                    
                    
                }, label: {
                    Image(systemName: item.isFavorite ? "heart.fill": "heart" )
                        .foregroundColor(.red)
                })
            }
            .padding(.horizontal, 6)
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
