//
//  GitTrackerApp.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI

@main
struct GitTrackerApp: App {
    
    // AUTHENTICATION STATE
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            // AUTHENTICATION SCREEN ROUTING
            if isAuthenticated {
                WelcomeView()
            } else{
                SignInView(isAuthenticated: $isAuthenticated)
            }
        }
    }
    
    
    
}
