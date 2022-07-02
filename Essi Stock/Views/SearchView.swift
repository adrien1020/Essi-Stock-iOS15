//
//  SearchView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    @State var alreadySearched : [String] = []
    @State var bagOfWords: [String] = []
    @State var navIsActive: Bool = false
    @State var alreadyViewIsActive = false
    @State var endOfNavigation = false
    
    var body: some View{
        VStack(spacing: 8){
            SearchBarHelper(searchText: $searchText)
            NavigationView{
                if !endOfNavigation && searchText != ""{
                    SuggestedView(searchText: $searchText, alreadySearched: $alreadySearched, bagOfWords: $bagOfWords, navIsActive: $navIsActive, endOfNavigation: $endOfNavigation)
                } else if !alreadySearched.isEmpty{
                    AlreadySearchView(searchText: $searchText, alreadySearched: $alreadySearched, bagOfWords: $bagOfWords, navIsActive: $navIsActive, endOfNavigation: $endOfNavigation)
                } else {
                    EmptySearchView()
                }
            }.onChange(of: searchText, perform: { searchTextValue in
                if searchTextValue != ""{
                    endOfNavigation = false
                }
            })
        }
    }
}


struct SuggestedView: View{
    
    @EnvironmentObject var apiServices : APIServices
    
    @Binding var searchText: String
    @Binding var alreadySearched : [String]
    @Binding var bagOfWords: [String]
    @Binding var navIsActive :Bool
    @Binding var endOfNavigation: Bool
    
    @State var itemResult: [Item]?
    
    var body: some View{
        ScrollView{
            VStack{
                if itemResult != []{
                    NavigationLink(destination: SearchResultView(result: searchItemResults, searchText: $searchText, navIsActive: $navIsActive, endOfNavigation: $endOfNavigation), isActive: $navIsActive){EmptyView()}
                }
            }.hidden()
            VStack(alignment: .leading){
                ForEach(suggestedResults, id:\.self){result in
                    Divider()
                    VStack{
                        HStack{
                            Text(result)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        .padding(.leading, 8)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        alreadySearched.append(result)
                        searchText = result
                        closeKeyboard()
                        self.itemResult = searchItemResults
                        navIsActive = true
                    })
                }
                Spacer()
                    .navigationBarHidden(true)
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
    }
    var suggestedResults: [String] {
        if searchText.isEmpty {
            return []
        } else {
            print("DEBUG: \(bagOfWords.filter({$0.localizedStandardContains(searchText)}).uniqued())")
            return bagOfWords.filter({$0.localizedStandardContains(searchText)}).uniqued()
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
}


struct SearchResultView: View{
    
    @Environment(\.presentationMode) var presentationMode
    
    var result: [Item]
    
    @Binding var searchText: String
    @Binding var navIsActive: Bool
    @Binding var endOfNavigation: Bool
    
    var body: some View{
        List(result){item in
            Button(action: {
            }, label: {
                ItemCellHelper(item: item)
            })
            .listRowInsets(EdgeInsets(top: 4,leading: 8, bottom: 4, trailing: 8))
        }
        .navigationBarHidden(true)
        .listStyle(.plain)
        
        .onChange(of: searchText, perform: { searchTextValue in
            if searchTextValue == ""{
                navIsActive = false
                closeKeyboard()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    endOfNavigation = true
                    
                })
            }
        })
    }
}


struct AlreadySearchView: View{
    
    @EnvironmentObject var apiServices : APIServices
    
    @Binding  var searchText : String
    @Binding var alreadySearched: [String]
    @Binding var bagOfWords: [String]
    @Binding var navIsActive :Bool
    @Binding var endOfNavigation :Bool
    
    @State var removeList = false
    @State var itemResult: [Item]?
    
    var body: some View{
        ScrollView{
            VStack{
                if itemResult != []{
                    NavigationLink(destination: SearchResultView(result: searchItemResults, searchText: $searchText, navIsActive: $navIsActive, endOfNavigation: $endOfNavigation), isActive: $navIsActive){EmptyView()}
                }
            }.hidden()
            VStack(alignment: .leading){
                ForEach(alreadySearched.uniqued(), id:\.self){result in
                    Divider()
                        VStack{
                            HStack{
                                Text(result)
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            .padding(.leading, 8)
                        }
                    .simultaneousGesture(TapGesture().onEnded{
                        navIsActive = true
                        searchText = result
                        closeKeyboard()
                        self.itemResult = searchItemResults
                    })
                }
                Spacer()
                    .navigationBarHidden(true)
            }
            Button(action: {
                withAnimation{
                    removeList.toggle()
                }
                alreadySearched.removeAll()
            }, label: {
                Text("Tout Effacer")
            })
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
}


struct EmptySearchView: View{
    var body: some View{
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
                .navigationBarHidden(true)
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
