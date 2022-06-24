//
//  ItemConfimationDialogHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 19/06/2022.
//

import SwiftUI

struct ItemConfimationDialogHelper: View {
    
    var item: Item
    
    var body: some View {
        HStack(spacing: 6){
            AsyncImage(url: URL(string: item.image),
                       content: { image in
                image
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    //.clipped()
                    .cornerRadius(15)
            },placeholder: {
                Color.gray.opacity(0.7)
                    .frame(width: 130, height: 130)
            })
            VStack(alignment: .leading, spacing: 10){
                Text(item.designation)
                    //.fontWeight(.bold)
                    .font(.callout.bold())
                    .foregroundColor(.black)
                    .lineLimit(2)
                HStack{
                    VStack(alignment: .leading, spacing: 6){
                Text(item.marque)
                    //.font(.system(size: 18))
                    .font(.caption.bold())
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.leading)
                Text(item.reference)
                //.font(.system(size: 14))
                    //.fontWeight(.semibold)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Text("\(item.price)€")
                        .font(.callout.bold())
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
            }
        }
}
}

/*
struct ItemConfimationDialogHelper_Previews: PreviewProvider {
    static var previews: some View {
        ItemConfimationDialogHelper(item: Item(id: 1, marque: "Schneider", reference: "1222", image: "iddd", price: "12.4"))
    }
}
*/
