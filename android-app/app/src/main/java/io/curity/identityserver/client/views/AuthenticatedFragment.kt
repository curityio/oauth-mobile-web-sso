package io.curity.identityserver.client.views

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.browser.customtabs.CustomTabsIntent
import androidx.fragment.app.activityViewModels
import io.curity.identityserver.client.MainActivityViewModel
import io.curity.identityserver.client.databinding.FragmentAuthenticatedBinding

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

        val url = this.binding.model!!.configuration.getSpaUri()
        println(url)
    }

    fun openChromeCustomTab() {

        val url = this.binding.model!!.configuration.getSpaUri()
        val intent = CustomTabsIntent.Builder().build();
        intent.launchUrl(this.context as Activity, url)
    }

    fun openSystemBrowser() {

        val url = this.binding.model!!.configuration.getSpaUri()
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = url
        this.startActivity(intent)
    }
}