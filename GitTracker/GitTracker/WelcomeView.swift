//
//  WelcomeView.swift
//  GitTracker
//
//  Created by Zach Chase on 09/10/2026.
//

// IMPORTS
import SwiftUI


// WELCOME
// -------------------------------------
struct WelcomeView: View {
    
    // AUTHENTICATION STATE BINDING
    @Binding var isAuthenticated: Bool
    
    // GITHUB CONTRIBUTIONS COUNT__temp
    let totalContributions: Int
    
    // DISCONNECT STATUS
    @State private var disconnectMessage = ""
    
    // WELCOME SCREEN
    var body: some View {
        VStack(spacing: 20) {
            
            // WELCOME TITLE
            Text("Welcome to GitTracker")
                .font(.title2)
                .bold()
            
            // CONNECTION STATUS
            Text("Connected to GitHub")
            
            // GITHUB CONTRIBUTIONS DISPLAY__Temp
            Text("Total Contributions: \(totalContributions)")
                .font(.headline)
            
            // DISCONNECT BUTTON
            Button("Disconnect") {
                
                // DELETE TOKEN FROM KEYCHAIN
                let deleted = KeychainHelper.deleteToken()
                
                // CHECK DELETED RESULT
                if deleted {
                    isAuthenticated = false
                } else {
                    disconnectMessage = "Unable to disconnect from GitHub."
                }
                
            }
            
            // DISCONNECT FEEDBACK
            Text(disconnectMessage)
            
        }
        .padding()
    }
    
    
}

#Preview {
    WelcomeView(
        isAuthenticated: .constant(true),
        // Temp
        totalContributions: 426
    )
}
