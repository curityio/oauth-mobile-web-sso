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

import Foundation
import AppAuth

/*
 * The view model for the unauthenticated view
 */
class UnauthenticatedViewModel: ObservableObject {
    
    let configuration: ApplicationConfiguration
    private let appauth: AppAuthHandler
    private let onAuthenticated: (String) -> Void
    private let onError: (ApplicationError) -> Void
    
    init(configuration: ApplicationConfiguration,
         onAuthenticated: @escaping (String) -> Void,
         onError: @escaping (ApplicationError) -> Void) {

        self.configuration = configuration
        self.onAuthenticated = onAuthenticated
        self.onError = onError
        self.appauth = AppAuthHandler(configuration: self.configuration)
    }
    
    func login() {

        Task {

            do {

                // Get metadata on a background thread
                let metadata = try await self.appauth.fetchMetadata()

                // Do the redirect on the UI thread, and no async handling can be done here
                await MainActor.run {

                    self.appauth.performAuthorizationRedirect(
                        metadata: metadata,
                        clientID: self.configuration.clientID,
                        viewController: ViewControllerAccessor.getRoot())
                }

                // Process the authorization response on a background thread
                let authorizationResponse = try await self.appauth.handleAuthorizationResponse()
                if authorizationResponse != nil {
                    
                    // Redeem the code for tokens on a background thread
                    let tokenResponse = try await self.appauth.redeemCodeForTokens(authResponse: authorizationResponse!)
                    
                    // Notify the main view, which will move the app to the authenticated view
                    await MainActor.run {
                        self.onAuthenticated(tokenResponse.idToken!)
                    }
                }
                
            } catch {
                
                // Report any technical problems
                await MainActor.run {
                    self.onError(error as! ApplicationError)
                }
            }
        }
    }
}
