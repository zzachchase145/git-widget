//
//  GitHubContributions.swift
//  GitTracker
//
//  Created by Zach Chase on 18/10/2026.
//

// IMPORTS
// ------------------

import Foundation

// GITHUB CONTRIBUTIONS API

// GITHUB CONTRIBUTIONS QUERY
// ------------------------------
private let contributionsQuery = """
    query {
        viewer {
            contributionsCollection {
                contributionCalendar {
                    totalContributions
                }
            }
        }
    }
    """


// GITHUB CONTRIBUTIONS RESPONSE MODELS
// -------------------------------------

struct ContributionsResponse: Decodable {
    let data: ContributionsData
}

struct ContributionsData: Decodable {
    let viewer: ContributionsViewer
}

struct ContributionsViewer: Decodable {
    let contributionsCollection: ContributionsCollection
}

struct ContributionsCollection: Decodable {
    let contributionCalendar: ContributionCalendar
}

struct ContributionCalendar: Decodable {
    let totalContributions: Int
}



// FETCH GITHUB CONTRIBUTIONS
// ---------------------------------------

func fetchGitHubContributions(token: String) async throws -> Int {
    
    // GITHUB GRAPHQL ENDPOINT
    let url = URL(string: "https://api.github.com/graphql")!
    
    // CREATE HTTP REQUEST
    var request = URLRequest(url: url)
    
    // CONFIGURE HTTP REQUEST
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // CREATE GRAPHQL REQUEST BODY
    let body = ["query": contributionsQuery]
    
    // CONVERT REQUEST BODY TO JSON
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    // SEND REQUEST TO GITHUB
    let (data, response) = try await URLSession.shared.data(for: request)
    
    // CHECK HTTP RESPONSE STATUS
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    // DEBUG GITHUB RESPONSE ___
    if let json = String(data: data, encoding: .utf8) {
        print("GitHub API Response: \(json)")
    }
    
    // DECODE GITHUB RESPONSE
    let decodedResponse = try JSONDecoder().decode(
        ContributionsResponse.self,
        from: data
    )
    // EXTRACT TOTAL CONTRIBUTIONS
    let totalContributions = decodedResponse.data.viewer
        .contributionsCollection.contributionCalendar.totalContributions
    
    // RETURN TOTAL CONTRIBUTIONS
    return totalContributions
}
