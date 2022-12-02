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

