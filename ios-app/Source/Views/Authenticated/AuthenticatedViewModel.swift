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

/*
 * The view model for the authenticated view
 */
class AuthenticatedViewModel: ObservableObject {

    private let configuration: ApplicationConfiguration
    private var tokenState: TokenState
    private let onError: (ApplicationError) -> Void

    init(configuration: ApplicationConfiguration,
         tokenState: TokenState,
         onError: @escaping (ApplicationError) -> Void) {

        self.configuration = configuration
        self.tokenState = tokenState
        self.onError = onError
    }

    /*
     * Swap the ID token for a nonce on a background thread and return the SPA URL
     */
    func createNonce(onSuccess: @escaping () -> Void) {
        
        Task {
            
            do {
                let service = NonceService(configuration: self.configuration)
                let nonce = try await service.createNonce(idToken: self.tokenState.idToken)
                
                await MainActor.run {
                    self.tokenState.nonce = nonce
                    print("DEBUG: nonce issued: \(nonce)")
                    onSuccess()
                }
                
            } catch {
                
                await MainActor.run {
                    self.onError(error as! ApplicationError)
                }
            }
        }
    }

    /*
     * Return the SPA URL, including the nonce
     */
    func getSpaUrl() -> URL{
        return URL(string: "\(self.configuration.webBaseUrl)\(self.configuration.spaPath)?nonce=\(self.tokenState.nonce)")!
    }
}
