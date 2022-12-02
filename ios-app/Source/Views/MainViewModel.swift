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
 * The main view model, containing global objects
 */
class MainViewModel: ObservableObject {
    
    private let configuration: ApplicationConfiguration
    @Published var tokenState: TokenState
    @Published var error: ApplicationError?

    private var unauthenticatedModel: UnauthenticatedViewModel?
    private var authenticatedModel: AuthenticatedViewModel?

    init() {
        self.configuration = ApplicationConfigurationLoader.load()
        self.tokenState = TokenState(idToken: "")
        self.error = nil
    }
    
    func getUnauthenticatedViewModel() -> UnauthenticatedViewModel {
        
        if self.unauthenticatedModel == nil {
            
            self.unauthenticatedModel = UnauthenticatedViewModel(
                configuration: self.configuration,
                onAuthenticated: self.onAuthenticated,
                onError: self.onError)
        }

        return self.unauthenticatedModel!
    }
    
    func getAuthenticatedViewModel() -> AuthenticatedViewModel {
        
        if self.authenticatedModel == nil {
            self.authenticatedModel = AuthenticatedViewModel(
                configuration: self.configuration,
                tokenState: self.tokenState)
        }

        return self.authenticatedModel!
    }

    private func onAuthenticated(idToken: String) {
        self.tokenState = TokenState(idToken: idToken)
        self.error = nil
    }

    private func onError(error: ApplicationError) {
        self.error = error
    }
}
