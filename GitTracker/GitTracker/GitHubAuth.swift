//
//  GitHubAuth.swift
//  GitTracker
//
//  Created by Zach Chase on 27/09/2026.
//


// IMPORTS
import Foundation
import Security



// AUTH TYPE

struct GitHubAuth {
    
    // CODE VERIFIER GENERATION
    private func generateCodeVerifier() -> String {
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
    
    // TEST FUNCTION FOR CODE VERIFIER GENERATION
    func testCodeVerifier() {
        let verifier = generateCodeVerifier()
        print("Verifier:", verifier)
        print("Length:", verifier.count)
    }
    
}
