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
import SafariServices

/*
 * The screen presented after login, for selecting how to invoke the SPA
 */
struct AuthenticatedView: View {

    @ObservedObject private var model: AuthenticatedViewModel
    @State private var showModal = false
    
    init(model: AuthenticatedViewModel) {
        self.model = model
    }

    /*
     * Render some ways to invoke the web app
     */
    var body: some View {

        let deviceWidth = UIScreen.main.bounds.size.width
        return VStack {

            Button {
                
                Task {
                    try await self.model.createNonce()
                    await MainActor.run {
                        self.showModal = true
                    }
                }
                
            } label: {
                Text("Run SPA in Web View")
            }
            .sheet(isPresented: self.$showModal) {
                self.onInvokeWebView()
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))

            Button(action: self.onInvokeSafariViewController) {
               Text("Run SPA in Safari View Controller")
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))
            
            Button(action: self.onInvokeSystemBrowser) {
               Text("Run SPA in System Browser")
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))
        }
    }

    /*
     * Open the SPA in a web view
     */
    private func onInvokeWebView() -> WebViewDialog {
            
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height

        return WebViewDialog(
            url: self.model.getSpaUrl(),
            width: deviceWidth,
            height: deviceHeight)
    }

    /*
     * Open the SPA in the integrated Safari View Controller browser
     */
    private func onInvokeSafariViewController() {

        Task {
            
            try await self.model.createNonce()
            await MainActor.run {
                
                let safariConfiguration = SFSafariViewController.Configuration()
                safariConfiguration.entersReaderIfAvailable = true
                    
                let safari = SFSafariViewController(url: self.model.getSpaUrl(), configuration: safariConfiguration)
                ViewControllerAccessor.getRoot().present(safari, animated: true)
            }
        }
    }

    /*
     * Open the SPA in the system browser
     */
    private func onInvokeSystemBrowser() {
        
        Task {
            
            try await self.model.createNonce()
            await MainActor.run {
                UIApplication.shared.open(self.model.getSpaUrl())
            }
        }
    }
}
