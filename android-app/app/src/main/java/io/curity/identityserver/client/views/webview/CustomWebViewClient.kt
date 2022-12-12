package io.curity.identityserver.client.views.webview

import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient

/*
 * Ensure that the SPA content loads within the web view and not in an external browser
 */
class CustomWebViewClient() : WebViewClient() {

    @Override
    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        return false
    }
}
