//
//  Constants.swift
//  TravelApp
//
//  Created by Reya Dawlah on 1/11/25.
//

import Foundation
import SwiftUI

struct AuthResponse: Codable {
    let token_type: String
    let access_token: String
}

final class Constants {
    static let clientId = "YOUR_CLIENT_ID"
    static let clientSecret = "CLIENT_SECRET"
    static let authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token"
    
    
    static func getAuthRequest(onError: ((String)->Void)?, completion: @escaping (String)->()) {
        guard let url = URL(string: self.authUrl) else { return }
        let parameters = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.httpBody = parameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onError?(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                onError?("Invalid response")
                return
            }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let authResponse = try decoder.decode(AuthResponse.self, from: responseData)
                completion("\(authResponse.token_type) \(authResponse.access_token)")
            } catch let error {
                onError?(error.localizedDescription)
            }
        }
        task.resume()
    }
}
