//
//  WelcomeView.swift
//  GitTracker
//
//  Created by Zach Chase on 09/10/2026.
//

// IMPORTS
import SwiftUI



struct WelcomeView: View {
    
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
                
            }
        }
        .padding()
    }
    
    
}




#Preview {
    WelcomeView()
}
