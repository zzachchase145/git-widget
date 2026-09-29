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
import AppKit
import Network



// AUTH TYPE

struct GitHubAuth {
    
    // CLIENT ID
    private let clientID = "Iv23livSjxm9Zja74pUm"
    
    // LISTENER PROPERTY
    private var callbackListener: NWListener?
    
    
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
            URLQueryItem(name: "redirect_uri", value: "http://127.0.0.1:8080/callback"),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "state", value: state)
        ]
        
        return components.url
    }
    
    
    
    // LOCAL CALLBACK LISTENER
    private mutating func startCallbackListener() {
        do {
            let listener = try NWListener(using: .tcp, on: 8080)
            callbackListener = listener
            
            // State handler
            listener.stateUpdateHandler = { state in
                print("Listener state:", state)
            }
            
            // Connection handler
            listener.newConnectionHandler = { connection in
                print("Callback connection received")
                
                connection.start(queue: .main)
                
                // Recieve the data from browser
                connection.receive(
                    minimumIncompleteLength: 1,
                    maximumLength: 65536
                ) { data, _, _, error in
                    
                    // Make raw bytes readable
                    if let data = data,
                       let request = String(data: data, encoding: .utf8) {
                        print("Raw callback request:")
                        print(request)
                        
                        // Pull request-target from HTTP
                        let requestLines = request.components(separatedBy: "\r\n")
                        
                        if let firstLine = requestLines.first {
                            print("First request line:", firstLine)
                            
                            let firstLineParts = firstLine.split(separator: " ")
                            
                            // Extract URL components
                            if firstLineParts.count >= 2 {
                                let requestTarget = String(firstLineParts[1])
                                print("Request target:", requestTarget)
                                
                                if let components = URLComponents(string: requestTarget) {
                                    print("Path:", components.path)
                                    print("Query items:", components.queryItems ?? [])
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            // Start listener
            listener.start(queue: .main)
        // Catch fail
        } catch {
            print("Failed to create callback listener:", error)
        }
    }
    
    
    
    // TEST FUNCTION FOR CODE GENERATION
    mutating func testCodeVerifier() {
        //Start callback
        startCallbackListener()
        
        //Add codes to func
        let verifier = generateCodeVerifier()
        let challenge = generateCodeChallenge(from: verifier)
        let state = generateState()
        let authorizationURL = generateAuthorizationURL(
            challenge: challenge,
            state: state
        )
        
        // Directs to url
        if let url = authorizationURL {
            NSWorkspace.shared.open(url)
        }
        
        // Prints generated codes to console
        print("Verifier:", verifier)
        print("Length:", verifier.count)
        print("Challenge:", challenge)
        print("Challenge Length:", challenge.count)
        print("State:", state)
        print("State Length:", state.count)
        print("Authorization URL:", authorizationURL?.absoluteString ?? "Failed to create URL")
        
    }
    
}
