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
 * For debugging, enable the mobile app to receive console.log statements from the SPA running in a webview
 */
class WebViewScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    func createConsoleLogUserScript() -> WKUserScript {
        
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
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
            
            let data = (message.body as? String)!.data(using: .utf8)!
            if let requestJson = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let requestFields = requestJson as? [String: Any] {
                    if let message = requestFields["message"] as? String {
                        print(message)
                    }
                }
            }
    }
}
