//
//  ContentViewModel.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import Foundation

class TabState: ObservableObject {
    
    enum Tab: String, CaseIterable {
        case first = "house.fill"
        case second = "person.fill"
        case third = "magnifyingglass"
    }
    @Published var iconName = ["house.fill","person.fill","magnifyingglass"]
    @Published var selectedTab: Tab = .first
    @Published var lastSelectedTab: Tab = .first
    
    @Published var showTabRoots = Tab.allCases.map { _ in
     
        false
    }
}
