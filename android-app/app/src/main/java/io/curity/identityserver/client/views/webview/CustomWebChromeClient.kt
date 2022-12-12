package io.curity.identityserver.client.views.webview

import android.webkit.ConsoleMessage
import android.webkit.WebChromeClient

/*
 * For debugging, receive any console.log statements from the SPA's Javascript code
 */
class CustomWebChromeClient : WebChromeClient() {

    @Override
    override fun onConsoleMessage(consoleMessage: ConsoleMessage?): Boolean {
        return super.onConsoleMessage(consoleMessage)
    }
}
