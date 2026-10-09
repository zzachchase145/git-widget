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
            
            // CONNECT BUTTON
            Button("Connect") {
                Task {
                    do {
                        // VALIDATE GITHUB TOKEN
                        let isValid = try await validateGitHubToken(githubToken)
                        
                        // CHECK TOKEN VALIDITY
                        if isValid {
                            // SAVE VALID TOKEN TO KEYCHAIN
                            let saved = KeychainHelper.saveToken(githubToken)
                            // CHECK KEYCHAIN SAVE RESULT
                            if saved {
                                isAuthenticated = true
                            } else {
                                authMessage = "Unable to save GitHub token."
                            }
                            
                        } else {
                            authMessage = "Invalid GitHub token"
                        }
                        
                    } catch {
                        // Error handling
                        authMessage = "Unable to connect to GitHub."
                        
                    }
                }
            }
            // AUTHENTICATION FEEDBACK
            Text(authMessage)
        }
        .padding()
    }
}

#Preview {
    SignInView(isAuthenticated: .constant(false))
}
