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

import AppAuth

class AppAuthHandler {
    
    private let configuration: ApplicationConfiguration
    private var userAgentSession: OIDExternalUserAgentSession?
    private var responseHandler: AuthorizationResponseHandler?
    
    init(configuration: ApplicationConfiguration) {
        self.configuration = configuration
    }

    /*
     * Get OpenID Connect endpoints
     */
    func fetchMetadata() async throws -> OIDServiceConfiguration {

        try await withCheckedThrowingContinuation { continuation in
            
            let issuerUri = URL(string: "\(self.configuration.idsvrBaseUrl)\(self.configuration.issuerPath)")!
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuerUri) { metadata, ex in
                
                if metadata != nil {
                    continuation.resume(returning: metadata!)
                    
                } else {
                    
                    let error = self.createAuthorizationError(title: "Metadata Download Error", ex: ex)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /*
     * Trigger a redirect with standard parameters and also prompt=login
     */
    func performAuthorizationRedirect(metadata: OIDServiceConfiguration,
                                      clientID: String,
                                      viewController: UIViewController) {
        
        let redirectUriValue = URL(string: self.configuration.redirectUri)!
        
        var extraParams = [String: String]()
        extraParams["prompt"] = "login"
        
        let scopesArray = self.configuration.scope.components(separatedBy: " ")
        let request = OIDAuthorizationRequest(
            configuration: metadata,
            clientId: clientID,
            clientSecret: nil,
            scopes: scopesArray,
            redirectURL: redirectUriValue,
            responseType: OIDResponseTypeCode,
            additionalParameters: extraParams)
        
        let userAgent = OIDExternalUserAgentIOS(presenting: viewController)
        
        self.responseHandler = AuthorizationResponseHandler()
        self.userAgentSession = OIDAuthorizationService.present(
            request,
            externalUserAgent: userAgent!,
            callback: self.responseHandler!.callback)
    }

    /*
     * Finish processing, which occurs on a worker thread
     */
    func handleAuthorizationResponse() async throws -> OIDAuthorizationResponse? {

        do {
            
            return try await self.responseHandler!.waitForCallback()
            
        } catch {

            if (self.isUserCancellationErrorCode(ex: error)) {
                return nil
            }

            throw self.createAuthorizationError(title: "Authorization Request Error", ex: error)
        }
    }

    /*
     * Handle the authorization response, including the user closing the Chrome Custom Tab
     */
    func redeemCodeForTokens(authResponse: OIDAuthorizationResponse) async throws -> OIDTokenResponse {
            
        try await withCheckedThrowingContinuation { continuation in
            
            let extraParams = [String: String]()
            let request = authResponse.tokenExchangeRequest(withAdditionalParameters: extraParams)
            
            OIDAuthorizationService.perform(
                request!,
                originalAuthorizationResponse: authResponse) { tokenResponse, ex in
                    
                if tokenResponse != nil {
                    
                    continuation.resume(returning: tokenResponse!)
                    
                } else {
                    
                    let error = self.createAuthorizationError(title: "Authorization Response Error", ex: ex)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /*
     * We can check for specific error codes to handle the user cancelling the ASWebAuthenticationSession window
     */
    private func isUserCancellationErrorCode(ex: Error) -> Bool {

        let error = ex as NSError
        return error.domain == OIDGeneralErrorDomain && error.code == OIDErrorCode.userCanceledAuthorizationFlow.rawValue
    }

    /*
     * Process standard OAuth error / error_description fields and also AppAuth error identifiers
     */
    private func createAuthorizationError(title: String, ex: Error?) -> ApplicationError {
        
        var parts = [String]()
        if (ex == nil) {

            parts.append("Authorization Error")

        } else {

            let nsError = ex! as NSError
            
            if nsError.domain.contains("org.openid.appauth") {
                parts.append("(\(nsError.domain) / \(String(nsError.code)))")
            }

            if !ex!.localizedDescription.isEmpty {
                parts.append(ex!.localizedDescription)
            }
        }

        let fullDescription = parts.joined(separator: " : ")
        let error = ApplicationError(title: title, description: fullDescription)
        return error
    }
}
