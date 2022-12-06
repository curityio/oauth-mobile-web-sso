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

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let scriptHandler = WebViewScriptMessageHandler()
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(scriptHandler, name: "mobileBridge")
        configuration.userContentController.addUserScript(scriptHandler.createConsoleLogUserScript())
        configuration.defaultWebpagePreferences = preferences

        let rect = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        return WKWebView(frame: rect, configuration: configuration)
    }

    /*
     * Load the view's content, which may result in an iOS internal warnings being output to logs
     * https://developer.apple.com/forums/thread/713290
     */
    func updateUIView(_ webview: WKWebView, context: Context) {
        
        let request = URLRequest(url: self.url)
        webview.load(request)
    }
}
