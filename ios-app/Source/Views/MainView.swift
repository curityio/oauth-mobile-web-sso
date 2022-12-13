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
 * The main view for the mobile app
 */
struct MainView: View {
    
    @ObservedObject private var model: MainViewModel

    init(model: MainViewModel) {
        self.model = model
    }

    var body: some View {

        VStack {
            
            Text("Mobile Web Demo App")
                .font(.title)
                .padding(.bottom)
            
            if self.model.error != nil {
                ErrorView(model: ErrorViewModel(error: self.model.error!))
                    .padding(.bottom)
            }

            if (self.model.tokenState.idToken.isEmpty) {
                UnauthenticatedView(model: self.model.getUnauthenticatedViewModel())
            } else {
                AuthenticatedView(model: self.model.getAuthenticatedViewModel())
            }

            Spacer()
        }
        .padding()
    }
}
