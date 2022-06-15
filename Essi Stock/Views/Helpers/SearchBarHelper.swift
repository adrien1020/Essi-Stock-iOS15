//
//  SearchBarHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SearchBarHelper: View {

    @Binding var searchText : String
    
    @State private var showedActionSheetCart = false
    @State var showedActionSheetQRCode = false
    @State private var isEditingChanged = false
    
    var body: some View {
        HStack(spacing: 10){
            TextField("Search",text: $searchText, onEditingChanged: { changed in
                withAnimation(.easeIn){
                    self.isEditingChanged = changed
                }
                
            }, onCommit: {
                print("DEBUG: Text Field commit")
            })
            
            .padding(.leading, 20)
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("Orange Color"),lineWidth: 2))
            
            
           
            if !isEditingChanged{
                HStack{
                    
                    Button(action: {
                        showedActionSheetQRCode.toggle()
                    }, label: {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color("Orange Color"))
                            .padding(.horizontal, 10)
                        
                    })
                    Button(action: {
                        showedActionSheetCart.toggle()
                    }, label: {
                        
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color("Orange Color"))
                            .padding(.horizontal, 10)
                        
                    })
                }
            }
        }
        .padding(.top, 5)
        .padding(.horizontal, 10)
        /*
        .sheet(isPresented:$isShowedActionSheetCart){
            CartView()
                .environmentObject(dataManagerVM)
        }
        .sheet(isPresented:$isShowedActionSheetQRCode){
            ReaderView(isShowerActionSheet: $isShowedActionSheetQRCode)
        }*/
    }
}


struct SearchBarHelper_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarHelper(searchText: .constant("Schneider"))
    }
}
