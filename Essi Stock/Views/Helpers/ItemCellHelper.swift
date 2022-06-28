//
//  ItemCellHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

struct ItemCellHelper: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var catIndex = 0
    @State var catL1Index = 0
    @State var catL2Index = 0
    @State var itemIndex = 0
    
    @State var item: Item
    
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
                HStack{
                    Spacer()
                    Button(action: {
                            apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite.toggle()
                            item = apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex]
                            apiServices.addToFavorites(item: item)
                        
                    }, label: {
                        Image(systemName: apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite ? "heart.fill": "heart" )
                            .foregroundColor(.red)
                    })
                }
            }
        }
        .onAppear(){
            apiServices.getItemIndex(item: item, completionHandler: {catIndex, catL1Index, catL2Index, itemIndex in
                self.catIndex = catIndex
                self.catL1Index = catL1Index
                self.catL2Index = catL2Index
                self.itemIndex = itemIndex
            })
        }
    }
}


struct ItemCellHelper_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemCellHelper(item: Item(id: 1, designation: "Ecran HMI tactile, TP1200 TFT 12.1 in Coloré", marque: "Siemens", reference: "6AV2124-0MC01-0AX0", JDE: "8765301283", image: "https://www.plc-city.com/shop/368-thickbox_default/6av2124-0mc01-0ax0.jpg", description: "Panneau confort Siemens SIMATIC HMI TP1200 avec écran tactile LCD TFT TFT de12,1 pouces. Il utilise un processeur de type X86. Cette HMI innovante est capable de coordonner et d'arrêter de manière centralisée leurs écrans via PROFI pendant les temps de coupure, pour réduire la consommation d'énergie, par rapport aux panneaux SIMATIC précédents.", price: "3383,16", quantity: 1, createdAt: "2022-06-21T20:50:41.962532Z", updatedAt: "2022-06-21T21:07:39.078499Z"))
    }
}

