//
//  ContentView.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI

struct ContentView: View {
    
    // TOKEN INPUT
    @State private var githubToken = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Connect to GitHub")
                .font(.title2)
                .bold()
            
            SecureField("Paste your GitHub token", text: $githubToken)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            Button("Connect") {
                // Authentication logic
                
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
