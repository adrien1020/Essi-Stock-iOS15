//
//  SearchBarHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SearchBarHelper: View {
    
    @EnvironmentObject var apiServices: APIServices
    @EnvironmentObject var tabStateVM: TabStateViewModel
    
    @Binding var searchText : String
    
    @State private var showCartView = false
    @State private var showCameraReaderView = false
    @State private var isEditingChanged = false
    
    var body: some View {
        HStack(spacing: 10){
            HStack{
                TextField("Rechercher...",text: $searchText, onEditingChanged: { changed in
                    withAnimation(.easeIn){
                        self.isEditingChanged = changed
                    }
                }, onCommit: {
                    print("DEBUG: Text Field commit")
                })
                .padding(.leading, 20)
                .frame(height: 40)
                if searchText != "" && isEditingChanged{
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.gray.opacity(0.6))
                    })
                    .padding(.horizontal, 6)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("Orange Color"),lineWidth: 2)
            )
            if isEditingChanged{
                Button(action: {
                    withAnimation(.easeOut){
                        isEditingChanged = false
                    }
                    closeKeyboard()
                }, label: {
                    Text("Annuler")
                        .foregroundColor(Color("Orange Color").opacity(0.9))
                })
            }
            HStack{
                if !isEditingChanged{
                    Button(action: {
                        showCameraReaderView.toggle()
                    }, label: {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color("Orange Color"))
                            .padding(.horizontal, 10)
                    })
                    Button(action: {
                        showCartView.toggle()
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
        .sheet(isPresented:$showCartView){
            CartView()
        }
        .sheet(isPresented:$showCameraReaderView){
            CameraReaderView(showCameraReader: $showCameraReaderView)
        }
    }
}


struct SearchBarHelper_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBarHelper(searchText: .constant(""))
    }
}
