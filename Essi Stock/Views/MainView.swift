//
//  MainView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var apiServices: APIServices
    
    var body: some View{
        VStack{
            Spacer()
            ScrollView(.vertical){
                VStack(spacing: 30){
                    HStack{
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Bienvenue sur Essi Stock!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                            Text("Trouvez la bonne pièce qu'il vous faut.")
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 60)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .background(LinearGradient(colors: [Color("Yellow Color"), Color("Orange Color")], startPoint: .leading, endPoint: .trailing))
                    VStack(spacing: 20){
                        HStack{
                            Text("Objets récemment consultés")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Text("Tout")
                                    .foregroundColor(Color("Orange Color"))
                            })
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal){
                            HStack(spacing:30){
                                ForEach(apiServices.items.indices, id:\.self){catIndex in
                                    ForEach(apiServices.items[catIndex].categoritesLevelOne.indices, id:\.self){catL1Index in
                                        ForEach(apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo.indices, id:\.self){catL2Index in
                                            ForEach(apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items.indices, id:\.self){itemIndex in
                                                AsyncImage(url: URL(string: apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items[itemIndex].image),
                                                           content: { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(20)
                                                },placeholder: {
                                                    Color.gray.opacity(0.7)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(20)
                                                })
                                                
                                            }
                                        }
                                    }
                                }
                            }.padding(.horizontal)
                            Divider()
                        }
                        HStack{
                            Text("Derniers objets ajoutés")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Text("Tout")
                                    .foregroundColor(Color("Orange Color"))
                            })
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack(spacing:30){
                                ForEach(0..<apiServices.items.count, id:\.self){catIndex in
                                    ForEach(0..<apiServices.items[catIndex].categoritesLevelOne.count, id:\.self){catL1Index in
                                        ForEach(0..<apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo.count, id:\.self){catL2Index in
                                            ForEach(apiServices.items[catIndex].categoritesLevelOne[catL1Index].categoritesLevelTwo[catL2Index].items, id:\.self){item in
                                                AsyncImage(url: URL(string: item.image),
                                                           content: { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(20)
                                                },placeholder: {
                                                    Color.gray.opacity(0.7)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(20)
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                    HStack{
                        Text("Vendeurs recommandés")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Text("Tout")
                                .foregroundColor(Color("Orange Color"))
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
