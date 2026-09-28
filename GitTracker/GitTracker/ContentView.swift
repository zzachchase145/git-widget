//
//  ContentView.swift
//  GitTracker
//
//  Created by Zach Chase on 15/09/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("GitTracker")
            .onAppear {
                let auth = GitHubAuth()
                auth.testCodeVerifier()
            }
        .padding()
    }
}

#Preview {
    ContentView()
}
