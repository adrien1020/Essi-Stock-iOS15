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
                        if !apiServices.recentes.isEmpty{
                            ItemsHScrollViewHelper(title: "Objets récemment consultés", items: apiServices.recentes)
                           
                            }
                        ItemsHScrollViewHelper(title: "Derniers objets ajoutés", items: apiServices.allItems)
                            .onChange(of: apiServices.items, perform: { items in
                                    apiServices.getAllItems(items: items)
                            })
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
    
    static let apiServices = APIServices()
    static var previews: some View {
        MainView()
            .environmentObject(apiServices)
            .onAppear{
                Task{
                    do {
                        print("DEBUG: Download data")
                        try await apiServices.fetchData(urlString: "http://127.0.0.1:8000/api/")
                    } catch RequestError.invalidURL{
                        print("DEBUG: Invalid URL")
                    } catch RequestError.missingData{
                        print("DEBUG: Missing data")
                    }
                    
                }
                
            }
    }
}
