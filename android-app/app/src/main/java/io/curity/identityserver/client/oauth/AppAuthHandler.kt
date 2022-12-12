/*
 *  Copyright 2022 Curity AB
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package io.curity.identityserver.client.oauth

import android.content.Context
import android.content.Intent
import io.curity.identityserver.client.configuration.ApplicationConfiguration
import io.curity.identityserver.client.errors.ApplicationException
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine
import net.openid.appauth.*
import net.openid.appauth.AuthorizationServiceConfiguration.fetchFromIssuer

class AppAuthHandler(private val config: ApplicationConfiguration, val context: Context) {

    private var authService = AuthorizationService(context)

    suspend fun fetchMetadata(): AuthorizationServiceConfiguration {

        return suspendCoroutine { continuation ->

            fetchFromIssuer(this.config.getIssuerUri()) { metadata, ex ->

                when {
                    metadata != null -> {
                        continuation.resume(metadata)
                    }
                    else -> {
                        val error = createAuthorizationError("Metadata Download Error", ex)
                        continuation.resumeWithException(error)
                    }
                }
            }
        }
    }

    fun startLogin(metadata: AuthorizationServiceConfiguration, launchAction: (i: Intent) -> Unit) {

        val request = AuthorizationRequest.Builder(
            metadata,
            this.config.clientID,
            ResponseTypeValues.CODE,
            this.config.getRedirectUri())
                .setScopes(this.config.scope)
                .setPrompt("login")
                .build()

        val intent = authService.getAuthorizationRequestIntent(request)
        launchAction(intent)
    }

    suspend fun endLogin(responseIntent: Intent): TokenResponse? {

        val authorizationResponse = AuthorizationResponse.fromIntent(responseIntent)
        val ex = AuthorizationException.fromIntent(responseIntent)

        if (ex != null) {

            if (ex.type == AuthorizationException.TYPE_GENERAL_ERROR &&
                ex.code == AuthorizationException.GeneralErrors.USER_CANCELED_AUTH_FLOW.code
            ) {

                return null
            }

            throw this.createAuthorizationError("Authorization Response Error", ex)
        }

        return suspendCoroutine { continuation ->

            val extraParams = mutableMapOf<String, String>()
            val tokenRequest = authorizationResponse!!.createTokenExchangeRequest(extraParams)

            authService.performTokenRequest(tokenRequest) { tokenResponse, ex ->

                when {
                    tokenResponse != null -> {
                        continuation.resume(tokenResponse)
                    }
                    else -> {
                        val error = createAuthorizationError("Authorization Grant Error", ex)
                        continuation.resumeWithException(error)
                    }
                }
            }
        }
    }

    private fun createAuthorizationError(title: String, ex: AuthorizationException?): ApplicationException {

        val parts = mutableListOf<String>()

        if (ex?.type != null) {
            parts.add("(${ex.type} / ${ex.code})")
        }

        if (ex?.error != null) {
            parts.add(ex.error!!)
        }

        val description: String = if (ex?.errorDescription != null) {
            ex.errorDescription!!
        } else {
            "Unknown Error"
        }
        parts.add(description)

        val fullDescription = parts.joinToString(" : ")
        return ApplicationException(title, fullDescription)
    }

    fun dispose() {
        this.authService.dispose()
    }
}
