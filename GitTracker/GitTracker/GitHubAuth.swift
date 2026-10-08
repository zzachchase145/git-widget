//
//  GitHubAuth.swift
//  GitTracker
//
//  Created by Zach Chase on 27/09/2026.
//


// IMPORTS
import Foundation


// GITHUB TOKEN VALIDATION
func validateGitHubToken(_ token: String) async throws -> Bool {
    // Github API endpoint
    let url = URL(string: "https://api.github.com/user")!
    
    // Create HTTP request
    var request = URLRequest(url: url)
    
    // Authorization header
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // Send HTTP request
    let (_, response) = try await URLSession.shared.data(for: request)
    
    // Check HTTP response
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    // Check status code
    return httpResponse.statusCode == 200
}
