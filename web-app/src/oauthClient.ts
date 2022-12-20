//
// Copyright (C) 2022 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import axios, {AxiosRequestConfig, AxiosRequestHeaders, Method} from 'axios';
import urlparse from 'url-parse';

/*
 * Utility methods to interact with the OAuth agent to manage authentication
 */
export class OAuthClient {

    private baseUrl: string;
    private subject: string;
    private antiForgeryToken: string;
    
    public constructor() {
        
        this.baseUrl = `${location.origin}/oauth-agent`;
        this.antiForgeryToken = '';
        this.subject = '';
    }

    /*
     * Do a single sign on if there is a nonce query parameter
     */
    public async handleNonce(): Promise<Boolean> {

        const nonce = urlparse(location.href, true).query.nonce || '';
        if (nonce) {
            await this.startSingleSignOn(nonce);
            return true;
        }

        return false;
    }

    /*
     * End a login if required, using the current page URL, then load the current user
     */
    public async handlePageLoad(): Promise<Boolean> {
        
        let isAuthenticated = await this.endLogin(location.href);
        if (isAuthenticated) {
            
            this.subject = await this.loadSubject();
            if (!this.subject) {
                isAuthenticated = false;
            }
        }

        return isAuthenticated;
    }

    /*
     * End a login if required, and return the authenticated state
     */
    private async endLogin(pageUrl: string): Promise<Boolean> {

        const request = JSON.stringify({
            pageUrl,
        });

        const response = await this.fetch('POST', 'login/end', request);
        if (response.handled) {
            history.replaceState({}, document.title, '/spa');
        }

        this.antiForgeryToken = response.csrf;
        return response.isLoggedIn;
    }

    /*
     * Run a single sign on with a nonce
     */
    private async startSingleSignOn(nonce: string): Promise<void> {

        const data = await this.fetch('POST', 'login/start', this.getSingleSignOnOptions(nonce));
        console.log(`DEBUG SPA: SSO redirect: ${data.authorizationRequestUrl}`);
        location.href = data.authorizationRequestUrl;
    }

    /*
     * Start a normal login redirect on the main window
     */
    public async startLogin(): Promise<void> {

        const data = await this.fetch('POST', 'login/start', this.getLoginOptions());
        console.log(`DEBUG SPA: login redirect: ${data.authorizationRequestUrl}`);
        location.href = data.authorizationRequestUrl;
    }

    /*
     * Get the logged in subject as a very basic way of displaying the user
     */
    private async loadSubject(): Promise<string> {
        
        const claims = await this.fetch('GET', 'userInfo', null);
        if (claims.sub) {
            return claims.sub;
        }

        return '';
    }

    /*
     * Return the subject to the view for display
     */
    public getSubject(): string {
        return this.subject;
    }

    /*
     * Trigger a login redirect to sign the user out
     */
    public async logout(): Promise<void> {

        const data = await this.fetch('POST', 'logout', null);
        console.log(`DEBUG SPA: logout redirect: ${data.url}`);
        location.href = data.url;
    }

    /*
     * Call the OAuth Agent in a parameterized manner
     */
    private async fetch(method: string, path: string, body: any): Promise<any> {

        let url = `${this.baseUrl}/${path}`;
        const options = {
            url,
            method: method as Method,
            headers: {
                accept: 'application/json',
                'content-type': 'application/json',
            },
            withCredentials: true,
        } as AxiosRequestConfig;

        const headers = options.headers as AxiosRequestHeaders;
        if (this.antiForgeryToken) {
            headers['x-example-csrf'] = this.antiForgeryToken;
        }

        if (body) {
            options.data = body;
        }

        const response = await axios.request(options);
        return response.data;
    } 

    /*
    * Get main page redirect options for the demo app
    */
   private getLoginOptions(): any {

       let extraParams = [];
       
       extraParams.push({
           key: 'prompt',
           value: 'login',
       });

       return {
           extraParams,
       };
   }

    /*
     * Get nonce based redirect options
     */
    private getSingleSignOnOptions(nonce: string): any {

        let extraParams = [];
        
        extraParams.push({
            key: 'prompt',
            value: 'login',
        });

        extraParams.push({
            key: 'acr_values',
            value: 'urn:se:curity:authentication:nonce:nonce1',
        });

        extraParams.push({
            key: 'login_hint_token',
            value: nonce,
        });

        return {
            extraParams,
        };
    }
}
