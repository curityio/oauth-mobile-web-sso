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
                self.onInvokeWebView()
            } label: {
                Text("Run SPA in Web View")
            }
            .sheet(isPresented: self.$showModal) {
                self.RenderWebView()
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
    private func RenderWebView() -> WebViewDialog {
            
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height

        return WebViewDialog(
            onGetSpaUrl: self.model.getSpaUrl,
            width: deviceWidth,
            height: deviceHeight)
    }
    
    /*
     * Open the SPA in a web view
     */
    private func onInvokeWebView() {
        
        let onSuccess = {
            print("DEBUG: Open web view at \(self.model.getSpaUrl().absoluteString)")
            self.showModal = true
        }

        self.model.createNonce(onSuccess: onSuccess)
    }

    /*
     * Open the SPA in the integrated Safari View Controller browser
     */
    private func onInvokeSafariViewController() {
        
        let onSuccess = {
            let safariConfiguration = SFSafariViewController.Configuration()
            safariConfiguration.entersReaderIfAvailable = true
            
            print("DEBUG: Open safari view controller at \(self.model.getSpaUrl().absoluteString)")
            let safari = SFSafariViewController(url: self.model.getSpaUrl(), configuration: safariConfiguration)
            ViewControllerAccessor.getRoot().present(safari, animated: true)
        }

        self.model.createNonce(onSuccess: onSuccess)
    }

    /*
     * Open the SPA in the system browser
     */
    private func onInvokeSystemBrowser() {
        
        let onSuccess = {
            print("DEBUG: Open system browser at \(self.model.getSpaUrl().absoluteString)")
            UIApplication.shared.open(self.model.getSpaUrl())
        }
        
        self.model.createNonce(onSuccess: onSuccess)
    }
}
