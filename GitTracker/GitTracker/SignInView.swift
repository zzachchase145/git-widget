//
//  ContentView.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI

struct SignInView: View {
    // AUTHENTICATION STATE BINDING
    @Binding var isAuthenticated: Bool
    
    // TOKEN INPUT
    @State private var githubToken = ""
    // AUTHENTICATION STATUS
    @State private var authMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Connect to GitHub")
                .font(.title2)
                .bold()
            
            SecureField("Paste your GitHub token", text: $githubToken)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            // Connect button
            Button("Connect") {
                Task {
                    do {
                        let isValid = try await validateGitHubToken(githubToken)
                        authMessage = isValid ? "Conneced successfully!" : "Invalid Github token."
                    } catch {
                        // Error handling
                        authMessage = "Unable to connect to GitHub."
                        
                    }
                }
            }
            // Authentication feedback
            Text(authMessage)
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
