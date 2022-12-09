package io.curity.identityserver.client

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import io.curity.identityserver.client.configuration.ApplicationConfigurationLoader
import io.curity.identityserver.client.errors.ApplicationException
import io.curity.identityserver.client.oauth.AppAuthHandler
import io.curity.identityserver.client.views.AuthenticatedFragmentViewModel
import io.curity.identityserver.client.views.UnauthenticatedFragmentViewModel

class MainActivityViewModel(app: Application) : AndroidViewModel(app) {

    private val configuration = ApplicationConfigurationLoader().load(app.applicationContext)
    private val appauth: AppAuthHandler = AppAuthHandler(configuration, app.applicationContext)
    private var unauthenticatedViewModel: UnauthenticatedFragmentViewModel? = null
    private var authenticatedViewModel:   AuthenticatedFragmentViewModel? = null

    fun getUnauthenticatedViewModel(): UnauthenticatedFragmentViewModel {

        if (this.unauthenticatedViewModel == null) {
            this.unauthenticatedViewModel = UnauthenticatedFragmentViewModel(
                this.configuration,
                this.appauth,
                this::onError)
        }

        return this.unauthenticatedViewModel!!
    }

    fun getAuthenticatedViewModel(): AuthenticatedFragmentViewModel {

        if (this.authenticatedViewModel == null) {
            this.authenticatedViewModel = AuthenticatedFragmentViewModel(
                this.configuration,
                this::onError)
        }

        return this.authenticatedViewModel!!
    }

    private fun onAuthenticated(idToken: String) {
        //this.tokenState = TokenState(idToken: idToken)
        //this.error = nil
    }

    private fun onError(error: ApplicationException) {
        //this.error = error
    }

    fun dispose() {
        this.appauth.dispose()
    }
}