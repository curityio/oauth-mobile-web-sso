package io.curity.identityserver.views

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.browser.customtabs.CustomTabsIntent
import io.curity.identityserver.databinding.FragmentAuthenticatedBinding

class AuthenticatedFragment : androidx.fragment.app.Fragment() {

    private lateinit var binding: FragmentAuthenticatedBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        this.binding = FragmentAuthenticatedBinding.inflate(inflater, container, false)
        this.binding.fragment = this

        this.binding.model = AuthenticatedFragmentViewModel()
        return this.binding.root
    }

    fun openWebView() {
    }

    fun openChromeCustomTab() {
        val intent = CustomTabsIntent.Builder().build();
        intent.launchUrl(this.context as Activity, Uri.parse("https://github.com"))
    }

    fun openSystemBrowser() {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse("https://github.com")
        this.startActivity(intent)
    }
}