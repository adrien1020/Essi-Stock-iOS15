//
//  SegmentedControlHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import SwiftUI

struct SegmentedControlHelper: View {
    
    @Binding var currentTab: TabModel
    
    @State var topPadding: CGFloat = 0
    
    var animation: Namespace.ID
    let tabs : [TabModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20){
                ForEach(tabs,id: \.self){ tab in
                    SegmentedButtonControl(currentTab: $currentTab, selectedTab: tab, animation: animation)
                }
            }
        }
        //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(10)
    }
}


struct SegmentedButtonControl: View{
    @Binding var currentTab: TabModel
    var selectedTab : TabModel
    var animation: Namespace.ID

    var body: some View{
        Button(action: {
            withAnimation(.spring()){
                self.currentTab = selectedTab
            }
        }, label: {
            VStack(spacing: 4){
                HStack(spacing: 8){
                    Image(systemName: selectedTab.icon)
                        .foregroundColor(self.currentTab == selectedTab ? .black : Color.black.opacity(0.6))
                    Text(selectedTab.name)
                        .foregroundColor(self.currentTab == selectedTab ? .black : Color.black.opacity(0.6))
                }
                if currentTab == selectedTab{
                    Capsule()
                        .fill(Color("Orange Color"))
                        .frame(height:4)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height:4)
                }
            }
        })
    }
}

/*
 struct SegmentedControlHelper_Previews: PreviewProvider {
 static var previews: some View {
 SegmentedControlHelper()
 }
 }
 */
