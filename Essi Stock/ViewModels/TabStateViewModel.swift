//
//  TabStateViewModel.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 22/06/2022.
//

import Foundation

class TabStateViewModel: ObservableObject {
    
    @Published var selectedTab: Tab = .first
    @Published var lastSelectedTab: Tab = .first
    @Published var showTabRoots = Tab.allCases.map { _ in
        false
    }
}
