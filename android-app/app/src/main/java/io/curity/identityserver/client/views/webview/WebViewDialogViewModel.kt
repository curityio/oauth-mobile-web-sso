package io.curity.identityserver.client.views.webview

class WebViewDialogViewModel(
    val onDismissCallback: () -> Unit
) {

    fun onDismiss() {
        this.onDismissCallback()
    }
}
