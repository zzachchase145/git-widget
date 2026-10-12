//
//  WelcomeView.swift
//  GitTracker
//
//  Created by Zach Chase on 09/10/2026.
//

// IMPORTS
import SwiftUI



struct WelcomeView: View {
    // AUTHENTICATION STATE BINDING
    @Binding var isAuthenticated: Bool
    
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
    WelcomeView(isAuthenticated: .constant(true))
}
