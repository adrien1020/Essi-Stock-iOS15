//
//  SearchView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var apiServices : APIServices
    
    @State var searchText = ""
    @State var alreadySearched : [String] = []
    @State private var showCartView = false
    @State var result: Item?
    @State var bagOfWords: [String] = []
    @State var navigate = false
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 8){
                SearchBarHelper(searchText: $searchText)
                if alreadySearched.isEmpty && searchText == ""{
                    VStack{
                        Spacer()
                        VStack(spacing: 20){
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 60))
                            Text("Rechercher sur Essi Stock")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("Trouvez vos prochaines pièces.")
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 50)
                        Spacer()
                    }
                } else if !alreadySearched.isEmpty && searchText.isEmpty {
                    VStack{
                        List(alreadySearched.uniqued(), id:\.self){searched in
                            Text(searched)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    withAnimation(.easeIn){
                                        searchText = searched
                                    }
                                }
                        }.listStyle(.plain)
                        Button(action: {
                            withAnimation(.easeOut){
                                alreadySearched.removeAll()
                            }
                        }, label: {
                            Text("Tout Effacer")
                        })
                        Spacer()
                    }
                    Spacer()
                }
                else {
                    List{
                        ForEach(suggestedResults, id:\.self){result in
                            NavigationLink(destination: SearchResultView(result: searchItemResults)){
                                Text(result)
                                    .listRowSeparator(.hidden)
                            }
                            .onTapGesture {
                                searchText = result
                                closeKeyboard()
                                alreadySearched.append(result)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchText)
                    
                    .sheet(item: $result, content: {item in
                        DetailsView(showCartView: $showCartView, item: item)
                    })
                    .sheet(isPresented: $showCartView, content: {
                        CartView()
                    })
                }
            }
            .onAppear(){
                for item in apiServices.allItems{
                    bagOfWords.append(item.marque)
                    bagOfWords.append("\(item.marque + " \(item.reference)")")
                    bagOfWords.append(item.reference)
                    bagOfWords.append(item.designation)
                    bagOfWords.append(item.JDE)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var searchItemResults : [Item]{
        if searchText.isEmpty{
            return []
        } else {
            return apiServices.allItems.filter {
                ($0.marque.localizedCaseInsensitiveContains(searchText)) ||
                ($0.designation.localizedCaseInsensitiveContains(searchText)) ||
                ($0.reference.localizedCaseInsensitiveContains(searchText)) ||
                ($0.JDE.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    var suggestedResults: [String] {
        if searchText.isEmpty {
            return bagOfWords
        } else {
            return bagOfWords.filter({$0.localizedStandardContains(searchText)}).uniqued()
        }
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        // Filter bagOfWords array and return without duplicate elements
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}


struct SearchResultView: View{
    var result: [Item]
    
    var body: some View{
        
        List(result){item in
            ItemCellHelper(item: item)
        }
    }
}
