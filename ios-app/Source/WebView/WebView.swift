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
import WebKit

/*
 * Wrap a WKWebView and enable some developer productivity settings
 */
struct WebView: UIViewRepresentable {

    private let url: URL
    private let width: CGFloat
    private let height: CGFloat

    init(url: URL, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
    }

    /*
     * Create the WKWebView and wire up behaviour
     */
    func makeUIView(context: Context) -> WKWebView {

        // Prevent Swift UI recreating the inner web view
        if WebViewCache.webView != nil {
            return WebViewCache.webView!
        }

        let preferences = WKWebpagePreferences()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(self.createConsoleLogUserScript())
        configuration.defaultWebpagePreferences = preferences

        // Create and return the web view
        let rect = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        WebViewCache.webView = WKWebView(frame: rect, configuration: configuration)
        return WebViewCache.webView!
    }

    /*
     * Load the view's content
     */
    func updateUIView(_ webview: WKWebView, context: Context) {

        // Prevent SwiftUI reloading the inner web view
        if WebViewCache.webView != nil && !WebViewCache.webViewLoaded {

            let request = URLRequest(url: self.url)
            webview.load(request)
            WebViewCache.webViewLoaded = true
        }
    }

    /*
     * For debugging, this enables the SPA's Javascript's console.log statements to show in XCode's output window
     */
    private func createConsoleLogUserScript() -> WKUserScript {

        let script = """
            var console = {
                log: function(msg) {
                    const data = {
                        methodName: 'log',
                        message: `${msg}`,
                    };
                    window.webkit.messageHandlers.mobileBridge.postMessage(JSON.stringify(data));
                }
            };
        """

        return WKUserScript(
            source: script,
            injectionTime: WKUserScriptInjectionTime.atDocumentStart,
            forMainFrameOnly: false
        )
    }
}

