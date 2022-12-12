package io.curity.identityserver.client

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import io.curity.identityserver.client.configuration.ApplicationConfigurationLoader
import io.curity.identityserver.client.errors.ApplicationException
import io.curity.identityserver.client.oauth.AppAuthHandler
import io.curity.identityserver.client.oauth.TokenState
import io.curity.identityserver.client.views.authenticated.AuthenticatedFragmentViewModel
import io.curity.identityserver.client.views.error.ErrorFragmentViewModel
import io.curity.identityserver.client.views.unauthenticated.UnauthenticatedFragmentViewModel

class MainActivityViewModel(app: Application) : AndroidViewModel(app) {

    private val configuration = ApplicationConfigurationLoader().load(app.applicationContext)
    private val appauth: AppAuthHandler = AppAuthHandler(configuration, app.applicationContext)
    private var unauthenticatedViewModel: UnauthenticatedFragmentViewModel? = null
    private var authenticatedViewModel:   AuthenticatedFragmentViewModel? = null
    private var errorViewModel: ErrorFragmentViewModel = ErrorFragmentViewModel()
    private var tokenState = TokenState()

    fun getUnauthenticatedViewModel(): UnauthenticatedFragmentViewModel {

        if (this.unauthenticatedViewModel == null) {
            this.unauthenticatedViewModel = UnauthenticatedFragmentViewModel(
                this.appauth,
                this.tokenState,
                this::onError)
        }

        return this.unauthenticatedViewModel!!
    }

    fun getAuthenticatedViewModel(): AuthenticatedFragmentViewModel {

        if (this.authenticatedViewModel == null) {
            this.authenticatedViewModel = AuthenticatedFragmentViewModel(
                this.configuration,
                this.tokenState,
                this::onError)
        }

        return this.authenticatedViewModel!!
    }

    fun getErrorViewModel(): ErrorFragmentViewModel {
        return this.errorViewModel
    }

    private fun onError(error: ApplicationException) {
        this.errorViewModel.setDetails(error)
    }

    fun dispose() {
        this.appauth.dispose()
    }
}