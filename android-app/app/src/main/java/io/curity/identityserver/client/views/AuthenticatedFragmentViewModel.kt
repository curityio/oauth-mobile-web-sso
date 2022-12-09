package io.curity.identityserver.client.views

import androidx.lifecycle.ViewModel
import io.curity.identityserver.client.configuration.ApplicationConfiguration
import io.curity.identityserver.client.errors.ApplicationException
import io.curity.identityserver.client.oauth.AppAuthHandler

class AuthenticatedFragmentViewModel(
    val configuration: ApplicationConfiguration,
    private val onError: (ApplicationException) -> Unit) : ViewModel() {


}