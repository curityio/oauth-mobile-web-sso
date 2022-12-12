package io.curity.identityserver.client.views.webview

import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import io.curity.identityserver.client.R
import io.curity.identityserver.client.databinding.FragmentWebviewBinding

class WebViewDialogFragment(private val spaUrl: Uri) : DialogFragment() {

    private lateinit var binding: FragmentWebviewBinding

    companion object {

        fun create(spaUrl: Uri): WebViewDialogFragment {
            val dialog = WebViewDialogFragment(spaUrl)
            dialog.setStyle(STYLE_NORMAL, R.style.Theme_App_Dialog_FullScreen)
            return dialog
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        this.binding = FragmentWebviewBinding.inflate(inflater, container, false)
        this.binding.model = WebViewDialogViewModel(this::onDialogClose)
        return this.binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val width = ViewGroup.LayoutParams.MATCH_PARENT
        val height = ViewGroup.LayoutParams.MATCH_PARENT
        dialog!!.window!!.setLayout(width, height)

        // Set web view properties to enable interop and debugging
        this.binding.webview.settings.javaScriptEnabled = true
        this.binding.webview.webViewClient = CustomWebViewClient()
        this.binding.webview.webChromeClient = CustomWebChromeClient()
        this.binding.webview.loadUrl(this.spaUrl.toString())
    }

    private fun onDialogClose() {
        this.dismiss()
    }
}
