//
//  ContentView.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var auth = GitHubAuth()
    
    var body: some View {
        Text("GitTracker")
            .onAppear {
                auth.testCodeVerifier()
            }
        .padding()
    }
}

#Preview {
    ContentView()
}
