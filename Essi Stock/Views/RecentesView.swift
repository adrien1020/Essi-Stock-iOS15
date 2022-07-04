//
//  RecentesView.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import SwiftUI

struct RecentesView: View {
    @EnvironmentObject var apiServices : APIServices
    var body: some View {
        List(apiServices.recentes){recentItem in
            ItemConfimationDialogHelper(item: recentItem)
        }
        .listStyle(.plain)
    }
}

struct RecentesView_Previews: PreviewProvider {
    static var previews: some View {
        RecentesView()
            .environmentObject(APIServices())
    }
}
