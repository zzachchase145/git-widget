//
//  GitTrackerApp.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI
// NETWORK MONITORING
import Network

@main
struct GitTrackerApp: App {
    
    // AUTHENTICATION STATE
    @State private var isAuthenticated = false
    
    // STARTUP AUTHENTICATION CHECK
    @State private var isCheckingAuthentication = true
    
    // CONNECTION ERROR CHECK
    @State private var hasConnectionError = false
    
    // NETWORK CONNECTION MONITOR
    @State private var networkMonitor = NWPathMonitor()
    
    
    // SCREEN ROUTING
    // --------------------
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
                    
                } else if hasConnectionError {
                    
                    // CONNECTION ERROR SCREEN
                    VStack(spacing: 15) {
                        Image(systemName: "wifi.slash")
                            .font(.largeTitle)
                        
                        Text("Unable to connect to GitHub")
                            .font(.title2)
                            .bold()
                        
                        Text("Waiting for connection...")
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
    // -----------------------------
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
                // VALID TOKEN
                isAuthenticated = true
                hasConnectionError = false
            } else {
                // INVALID TOKEN
                isAuthenticated = false
                hasConnectionError = false
            }
            
        } catch {
            // CONNECTION OR API ERROR
            hasConnectionError = true
        }
        // FINISH STARTUP AUTHENTICATION CHECK
        isCheckingAuthentication = false
    }
    
    
    // START NETWORK MONITORING
    // ---------------------------
    private func startNetworkMonitoring() {
        
        // NETWORK STATUS CALLBACK
        networkMonitor.pathUpdateHandler = { path in
            
            // CHECK NETWORK AVAILABILITY
            if path.status == .satisfied {
                print("Network connection available")
            }
        }
        
        // START MONITOR ON BACKGROUND QUEUE
        networkMonitor.start(queue: DispatchQueue.global(qos: .background))
        
    }
    
    
    
}
