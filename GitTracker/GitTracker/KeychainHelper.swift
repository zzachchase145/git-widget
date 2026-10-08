//
//  KeychainHelper.swift
//  GitTracker
//
//  Created by Zach Chase on 08/10/2026.
//

// IMPORTS
import Foundation
import Security


// KEYCHAIN HELPER
struct KeychainHelper {
    
    
    
    // SAVE GITHUB TOKEN
    static func saveToken(_ token: String) -> Bool {
        // CONVERT TOKEN TO DATA
        guard let tokenData = token.data(using: .utf8) else {
            return false
        }
        // KEYCHAIN QUERY
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "GitTracker",
            kSecAttrAccount as String: "GitHubToken"
        ]
        // KEYCHAIN SAVE ATTRIBUTES
        var attributes = query
        
        attributes[kSecValueData as String] = tokenData
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        
        // SAVE TOKEN TO KEYCHAIN
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        // CHECK SAVE RESULT
        return status == errSecSuccess
    }
    
    
    
    // LOAD GITHUB TOKEN
    static func loadToken() -> String? {
        
        // KEYCHAIN LOOKUP QUERY
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "GitTracker",
            kSecAttrAccount as String: "GitHubToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        // RETRIEVE TOKEN FROM KEYCHAIN
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // CHECK KEYCHAIN RESULT
        guard status == errSecSuccess,
              let tokenData = result as? Data else {
            return nil
        }
        // CONVERT TOKEN DATA TO STRING
        return String(data: tokenData, encoding: .utf8)
        
    }
    
    
    
    // DELETE GITHUB TOKEN
    static func deleteToken() -> Bool {
        
        // KEYCHAIN DELETE QUERY
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "GitTracker",
            kSecAttrAccount as String: "GitHubToken"
        ]
        // DELETE TOKEN FROM KEYCHAIN
        let status = SecItemDelete(query as CFDictionary)
        
        // CHECK DELETE RESULT
        return status == errSecSuccess
    }
    
    
    
    
    
}
