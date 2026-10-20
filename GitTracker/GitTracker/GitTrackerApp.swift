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
    
    // GITHUB CONTRIBUTIONS STATE
    @State private var totalContributions: Int = 0
    
    // STARTUP AUTHENTICATION CHECK
    @State private var isCheckingAuthentication = true
    
    // CONNECTION ERROR CHECK
    @State private var hasConnectionError = false
    
    // NETWORK CONNECTION MONITOR
    @State private var networkMonitor = NWPathMonitor()
    
    // NETWORK MONITOR STARTUP STATE
    @State private var isNetworkMonitorRunning = false
    
    // AUTHENTICATION REQUEST STATE
    @State private var isAuthenticationRequestRunning = false
    
    
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
                    WelcomeView(
                        isAuthenticated: $isAuthenticated,
                        // Temp
                        totalContributions: totalContributions
                    )
                    
                } else {
                    // SIGN IN SCREEN
                    SignInView(isAuthenticated: $isAuthenticated)
                }
                
            }
            // STARTUP AUTHENTICATION TASK
            .task {
                startNetworkMonitoring()
                await checkAuthentication()
            }
        }
    }
    
    // STARTUP AUTHENTICATION CHECK
    // -----------------------------
    @MainActor
    private func checkAuthentication() async {
        
        // PREVENT DUPLICATE AUTHENTICATION REQUESTS
        guard !isAuthenticationRequestRunning else {
            return
        }
        isAuthenticationRequestRunning = true
        
        // RESET AUTHENTICATION REQUEST STATE ON EXIT
        defer {
            isAuthenticationRequestRunning = false
        }
        
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
                await loadContributions()
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
    
    
    // LOAD GITHUB CONTRIBUTIONS
    // ---------------------------------
    @MainActor
    private func loadContributions() async {
        guard let token = KeychainHelper.loadToken() else {
            return
        }
        do {
            let total = try await fetchGitHubContributions(token: token)
            totalContributions = total
            print("GitHub Total Contributions: \(total)")
        } catch {
            print("Failed to fetch contributions: \(error)")
        }
    }
    
    
    // START NETWORK MONITORING
    // ---------------------------
    private func startNetworkMonitoring() {
        
        // PREVENT DUPLICATE MONITOR START
        guard !isNetworkMonitorRunning else {
            return
        }
        isNetworkMonitorRunning = true
        
        // NETWORK STATUS CALLBACK
        networkMonitor.pathUpdateHandler = { path in
            
            // CHECK NETWORK AVAILABILITY
            if path.status == .satisfied {
                
                // RETURN TO MAIN ACTOR
                Task { @MainActor in
                    
                    // RETRY AUTHENTICATION IF CONNECTION FAILED
                    if hasConnectionError {
                        await checkAuthentication()
                    }
                }
            }
            
        }
        
        // START MONITOR ON BACKGROUND QUEUE
        networkMonitor.start(queue: DispatchQueue.global(qos: .background))
        
    }
    
    
    
}
