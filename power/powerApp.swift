//
//  powerApp.swift
//  power
//
//  Created by 胡杰 on 2025/6/18.
//

import SwiftUI

@main
struct powerApp: App {
    
    init() {
        _ = LocalDatabase.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
