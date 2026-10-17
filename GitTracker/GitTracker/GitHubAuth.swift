//
//  GitHubAuth.swift
//  GitTracker
//
//  Created by Zach Chase on 27/09/2026.
//


// IMPORTS
import Foundation


// GITHUB TOKEN VALIDATION
// ----------------------------

func validateGitHubToken(_ token: String) async throws -> Bool {
    // GITHUB API ENDPOINT
    let url = URL(string: "https://api.github.com/user")!
    
    // CREATE HTTP REQUEST
    var request = URLRequest(url: url)
    
    // AUTHORIZATION HEADER
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // SEND HTTP REQUEST
    let (_, response) = try await URLSession.shared.data(for: request)
    
    // CHECK HTTP RESPONSE
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    // CHECK GITHUB RESPONSE STATUS
    switch httpResponse.statusCode {
        
    case 200:
        // VALID TOKEN
        return true
        
    case 401:
        // INVALID OR REVOKED TOKEN
        return false
    
    default:
        // TEMPORARY OR UNEXPECTED API ERROR
        throw URLError(.badServerResponse)
    }
    
}
