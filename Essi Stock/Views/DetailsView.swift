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

/*
struct DetailsView_Previews: PreviewProvider {
   var apiServices = APIServices()
    static var previews: some View {
        DetailsView(showCartView: .constant(true), item: Item(id: 1, designation: "Connecteur RS PRO à utiliser avec Thermocouple de type K", marque: "RS PRO", reference: "455-9764", JDE: "129390191002", image: "https://th.misumi-ec.com/en/linked/material/mech/BQQ1/PHOTO/221302147574_001.jpg", description: "Connecteurs mâles en ligne miniatures à code couleur CEI pour thermocouple de RS PRO\r\n\r\nConnecteur mâle miniature en ligne pour thermocouple de RS PRO avec code couleur conformément à la spécification CEI. Cette fiche mâle de thermocouple est idéale pour connecter la sonde à thermocouple ou les bornes à fil aux câbles d'extension ou de compensation. Cette fiche mâle fournit également une solution rapide, sûre et sans erreur de remplacement des thermocouples existants. Le boîtier pour fiche mâle est fabriqué à partir d'un thermoplastique renforcé de fibre de verre robuste, résistant aux chocs et aux hautes températures jusqu'à 220 °C. Les broches sur ce connecteur mâle sont de conception plate et polarisés pour assurer une connexion précise. Le type de thermocouple à code couleur CEI est clairement indiqué sur le devant du boîtier pour permettre une identification aisée.\r\n\r\nQu'est-ce qu'un connecteur de thermocouple ?\r\n\r\nCes connecteurs de thermocouple sont une solution précise", price: "3.74", quantity: 4, createdAt: "2022-06-21T20:50:41.962532Z", updatedAt: "2022-06-21T21:07:39.078499Z", isFavorite: true, desiredQuantity: 1))
    }
}
*/
