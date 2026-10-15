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
    
    // STARTUP AUTHENTICATION CHECK
    @State private var isCheckingAuthentication = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                
                // AUTHENTICATION SCREEN ROUTING
                if isCheckingAuthentication {
                    
                    // LOADING SCREEN
                    VStack(spacing: 15) {
                        ProgressView()
                        Text("Checking Github connection...")
                    }
                    
                } else if isAuthenticated {
                    // AUTHENTICATED SCREEN
                    WelcomeView(isAuthenticated: $isAuthenticated)
                    
                } else {
                    // SIGN IN SCREEN
                    SignInView(isAuthenticated: $isAuthenticated)
                }
                
            }
            // STARTUP AUTHENTICATION TASK
            .task {
                await checkAuthentication()
            }
        }
    }
    
    // STARTUP AUTHENTICATION CHECK
    @MainActor
    private func checkAuthentication() async {
        
        // LOAD SAVED TOKEN FROM KEYCHAIN
        guard let token = KeychainHelper.loadToken() else {
            isAuthenticated = false
            isCheckingAuthentication = false
            return
        }
        // VALIDATE SAVED GITHUB TOKEN
        do {
            let isValid = try await validateGitHubToken(token)
            
            if isValid {
                isAuthenticated = true
            } else {
                isAuthenticated = false
            }
            
        } catch {
            isAuthenticated = false
        }
        // FINISH STARTUP AUTHENTICATION CHECK
        isCheckingAuthentication = false
    }
    
    
}
