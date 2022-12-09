package io.curity.identityserver.client.views

import android.content.Intent
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.curity.identityserver.client.configuration.ApplicationConfiguration
import io.curity.identityserver.client.errors.ApplicationException
import io.curity.identityserver.client.oauth.AppAuthHandler
import io.curity.identityserver.client.views.utilities.Event
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class UnauthenticatedFragmentViewModel(
    private val configuration: ApplicationConfiguration,
    private val appauth: AppAuthHandler,
    private val onError: (ApplicationException) -> Unit) : ViewModel() {

    var loginCompleted = MutableLiveData<Event<Boolean>>()

    fun startLogin(launchAction: (i: Intent) -> Unit) {

        CoroutineScope(Dispatchers.IO).launch {

            val that = this@UnauthenticatedFragmentViewModel
            try {

                val metadata = that.appauth.fetchMetadata()

                withContext(Dispatchers.Main) {
                    that.appauth.startLogin(metadata, launchAction)
                }

            } catch (ex: ApplicationException) {

                withContext(Dispatchers.Main) {
                    that.onError(ex)
                }
            }
        }
    }

    fun finishLogin(responseIntent: Intent) {

        CoroutineScope(Dispatchers.IO).launch {

            val that = this@UnauthenticatedFragmentViewModel
            try {

                val tokenResponse = that.appauth.endLogin(responseIntent)
                if (tokenResponse != null) {

                    withContext(Dispatchers.Main) {

                        // TODO
                        // updateTokenState(tokenResponse.idToken!!)

                        that.loginCompleted.postValue(Event(true))
                    }
                }

            } catch (ex: ApplicationException) {

                withContext(Dispatchers.Main) {
                    that.onError(ex)
                }
            }
        }
    }
}