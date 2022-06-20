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
                                    Text(item.marque)
                                        .font(.title2)
                                    
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    Text(item.reference)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                                VStack{
                                    Text("\(item.price)€")
                                        .font(.title2)
                                        .fontWeight(.bold)
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
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris malesuada diam fringilla lorem bibendum, sed suscipit justo sodales. In placerat massa vitae ornare gravida. Praesent ut arcu et diam consequat fermentum semper quis ipsum. Etiam non dolor felis. Aliquam nec velit et leo semper commodo id ut elit. Nullam scelerisque ipsum enim, ut posuere eros mollis vel. Donec eu blandit massa, sit amet dignissim augue. ")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black.opacity(0.5))
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
            .onTapGesture {
                withAnimation{
                    showConfirmationDialogView = false
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
                .environmentObject(apiServices)
                .zIndex(1)
        }
    }
}

/*
 struct DetailsView_Previews: PreviewProvider {
 static var previews: some View {
 DetailsView()
 }
 }
 */
