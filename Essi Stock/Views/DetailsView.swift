//
//  DetailsView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 16/06/2022.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @Binding var showCartView: Bool
    
    @State var quantityDesired = 1
    @State var showConfirmationDialogView = false
    @State var catIndex = 0
    @State var catL1Index = 0
    @State var catL2Index = 0
    @State var itemIndex = 0
    
    var item: Item
    
    var body: some View {
        
        ZStack {
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        AsyncImage(url: URL(string: item.image),
                                   content: { image in
                            image
                                .resizable(resizingMode: .stretch)
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                                .clipped()
                        },placeholder: {
                            Color.gray.opacity(0.7)
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                                .clipped()
                        })
                        VStack(alignment: .leading, spacing: 20){
                            HStack(){
                                VStack(alignment: .leading, spacing: 20){
                                    Text(item.designation)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                    Text(item.marque)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    Text(item.reference)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                                VStack{
                                    Spacer()
                                    Text("\(item.price)€")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.4), radius: 3, x: 2, y: 2)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Button(action: {
                                                apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite.toggle()
                                                
                                                let item = apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex]
                                                apiServices.addToFavorites(item: item)
                                                
                                                
                                            }, label: {
                                                Image(systemName: apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].isFavorite ? "heart.fill": "heart" )
                                                    .foregroundColor(Color("Orange Color"))
                                            })
                                        )
                                }
                            }
                            VStack(spacing: 10){
                                Divider()
                                Text(item.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black.opacity(0.5))
                                    .lineLimit(10)
                                HStack{
                                    StepperHelper(quantity: $quantityDesired)
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            showConfirmationDialogView.toggle()
                                        }
                                        apiServices.addToCart(item: item, quantityDesired: quantityDesired)
                                    }, label: {
                                        Text("Add to cart")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding()
                                            .padding(.horizontal, 40)
                                            .background(Color("Orange Color"))
                                            .cornerRadius(15)
                                    })
                                }
                                .padding()
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                    }
                }
            }
            .onAppear(){
                apiServices.addToRecentes(item: item)
                apiServices.getItemIndex(item: item, completionHandler: { catIndex, catL1Index, catL2Index, itemIndex in
                    self.catIndex = catIndex
                    self.catL1Index = catL1Index
                    self.catL2Index = catL2Index
                    self.itemIndex = itemIndex
                })
            }
            ConfirmationDialogView(showConfirmationDialogView: $showConfirmationDialogView, quantityDesired: $quantityDesired, showCartView: $showCartView, item: item)
        }
    }
    
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
            DetailsView(showCartView: .constant(false), quantityDesired: 1, showConfirmationDialogView: false, catIndex: 0, catL1Index: 0, catL2Index: 0, itemIndex: 0, item: Item(id: 1, designation: "Ecran HMI tactile, TP1200 TFT 12.1 in Coloré", marque: "Siemens", reference: "6AV2124-0MC01-0AX0", JDE: "8765301283", image: "https://www.plc-city.com/shop/368-thickbox_default/6av2124-0mc01-0ax0.jpg", description: "Panneau confort Siemens SIMATIC HMI TP1200 avec écran tactile LCD TFT TFT de12,1 pouces. Il utilise un processeur de type X86. Cette HMI innovante est capable de coordonner et d'arrêter de manière centralisée leurs écrans via PROFI pendant les temps de coupure, pour réduire la consommation d'énergie, par rapport aux panneaux SIMATIC précédents.", price: "3383,16", quantity: 1, createdAt: "2022-06-21T20:50:41.962532Z", updatedAt: "2022-06-21T21:07:39.078499Z"))
            .environmentObject(APIServices())
    }
}

