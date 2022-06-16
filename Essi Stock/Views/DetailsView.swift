//
//  DetailsView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 16/06/2022.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    @State var quantityDesired = 1
    @State var addToCartPressed = false
    @State var offset: CGFloat = 0.0
    @State var blurRadius = 0.0
    
    @Binding var item: Item
    
    var body: some View {
        ZStack {
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
                                            item.isFavorite.toggle()
                                        }, label: {
                                            Image(systemName: item.isFavorite ? "heart.fill": "heart" )
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
                                    withAnimation(.linear){
                                        addToCartPressed.toggle()
                                        blurRadius = 5
                                    }
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
            .blur(radius: addToCartPressed ?  blurRadius: 0)
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