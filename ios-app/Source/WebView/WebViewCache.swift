import WebKit

/*
 * A class to prevent re-entrancy problems due to default behaviour of web views being created multiple times
 * https://stackoverflow.com/questions/60109947/swiftui-do-not-refresh-a-custom-view-macos-app
 */
class WebViewCache {

    // Our app has a single webvew whereas a larger app might use a dictionary
    static var webView: WKWebView?
    static var webViewLoaded: Bool = false

    /*
     * Clear the cached web view when the containing dialog is dismissed
     */
    static func clear() {
        WebViewCache.webView = nil
        WebViewCache.webViewLoaded = false
    }
}

