package io.curity.identityserver.client.views.authenticated

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.browser.customtabs.CustomTabsIntent
import androidx.fragment.app.activityViewModels
import io.curity.identityserver.client.MainActivityViewModel
import io.curity.identityserver.client.databinding.FragmentAuthenticatedBinding
import io.curity.identityserver.client.views.webview.WebViewDialogFragment

class AuthenticatedFragment : androidx.fragment.app.Fragment() {

    private lateinit var binding: FragmentAuthenticatedBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        this.binding = FragmentAuthenticatedBinding.inflate(inflater, container, false)
        this.binding.fragment = this

        val mainViewModel: MainActivityViewModel by activityViewModels()
        val viewModel = mainViewModel.getAuthenticatedViewModel()

        this.binding.model = viewModel
        return this.binding.root
    }

    fun openWebView() {

        val onSuccess = {
            val url = this.binding.model!!.getSpaUrl()
            println("DEBUG: Open web view at $url")

            val dialog = WebViewDialogFragment.create(url)
            dialog.show(this.childFragmentManager, "")
        }

        this.binding.model!!.createNonce(onSuccess)
    }

    fun openChromeCustomTab() {

        val onSuccess = {
            val url = this.binding.model!!.getSpaUrl()
            println("DEBUG: Open chrome custom tab at $url")

            val intent = CustomTabsIntent.Builder().build();
            intent.launchUrl(this.context as Activity, url)
        }

        this.binding.model!!.createNonce(onSuccess)
    }

    fun openSystemBrowser() {

        val onSuccess = {
            val url = this.binding.model!!.getSpaUrl()
            println("DEBUG: Open system browser at $url")

            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = url
            this.startActivity(intent)
        }

        this.binding.model!!.createNonce(onSuccess)
    }
}