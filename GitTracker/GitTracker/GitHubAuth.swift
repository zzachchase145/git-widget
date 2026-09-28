//
//  GitHubAuth.swift
//  GitTracker
//
//  Created by Zach Chase on 27/09/2026.
//


// IMPORTS
import Foundation
import Security
import CryptoKit



// AUTH TYPE

struct GitHubAuth {
    
    // CLIENT ID
    private let clientID = "Iv23livSjxm9Zja74pUm"
    
    
    // SECURE RANDOM STRING GENERATION
    private func generateSecureRandomString() -> String {
        var randomBytes = [UInt8](repeating: 0, count: 32)
        
        let status = SecRandomCopyBytes(
            kSecRandomDefault,
            randomBytes.count,
            &randomBytes
        )
        
        guard status == errSecSuccess else {
            return ""
        }
        
        let data = Data(randomBytes)
        
        return data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    
    // CODE VERIFIER GENERATION
    private func generateCodeVerifier() -> String {
        return generateSecureRandomString()
    }
    
    
    // CODE CHALLENGE GENERATION
    private func generateCodeChallenge(from verifier: String) -> String {
        let verifierData = Data(verifier.utf8)
        let hashed = SHA256.hash(data: verifierData)
        let hashedData = Data(hashed)
        
        return hashedData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            
    }
    
    
    // CODE STATE GENERATION
    private func generateState() -> String {
        return generateSecureRandomString()
    }
    
    
    // AUTHORIZATION URL GENERATION
    private func generateAuthorizationURL(
        challenge: String,
        state: String
    ) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: "http://127.0.0.1/callback"),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "state", value: state)
        ]
        
        return components.url
    }
    
    
    // TEST FUNCTION FOR CODE GENERATION
    func testCodeVerifier() {
        let verifier = generateCodeVerifier()
        let challenge = generateCodeChallenge(from: verifier)
        let state = generateState()
        let authorizationURL = generateAuthorizationURL(
            challenge: challenge,
            state: state
        )
        
        print("Verifier:", verifier)
        print("Length:", verifier.count)
        print("Challenge:", challenge)
        print("Challenge Length:", challenge.count)
        print("State:", state)
        print("State Length:", state.count)
        print("Authorization URL:", authorizationURL?.absoluteString ?? "Failed to create URL")
        
    }
    
}
