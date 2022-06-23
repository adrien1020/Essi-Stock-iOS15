//
//  Essi_StockApp.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 14/06/2022.
//

import SwiftUI

@main
struct Essi_StockApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase, perform: {scene in
                    switch scene{
                    case .active:
                        print("DEBUG: Scene is active")
                    case .background:
                        print("DEBUG: Scene is in background")
                    case .inactive:
                        print("DEBUG: Scene is inactive")
                    default: print("DEBUG: unknow")
                    }
                })
        }
    }
}
