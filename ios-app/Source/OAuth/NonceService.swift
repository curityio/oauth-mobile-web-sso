//
// Copyright (C) 2022 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

/*
 * A class to manage sending an ID token and receiving a nonce
 */
class NonceService {
    
    private let configuration: ApplicationConfiguration
    
    init(configuration: ApplicationConfiguration) {
        self.configuration = configuration
    }
    
    func createNonce(idToken: String) async throws -> String {
        
        let nonceEndpointUrl = URL(string: "\(self.configuration.baseUrl)\(self.configuration.nonceAuthenticatorPath)")!

        var request = URLRequest(url: nonceEndpointUrl)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "token=\(idToken)".data(using: .utf8)

        do {

            let (data, response) = try await URLSession.shared.data(for: request)
    
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApplicationError(title: "Nonce Response Error", description: "Invalid HTTP response received")
            }
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                throw ApplicationError(title: "Nonce Response Error", description: "Nonce issuing failure: status: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            if let nonceResponse = try? decoder.decode(NonceResponse.self, from: data) {
                return nonceResponse.nonce
            }
            
            throw ApplicationError(title: "Nonce Data Error", description: "Unexpected data was received in the nonce response")

        } catch {

            var appError = error as? ApplicationError
            if appError != nil {
                throw appError!
            }

            throw ApplicationError(title: "Nonce Request Error", description: "Failure during nonce HTTP request")
        }
    }
}
