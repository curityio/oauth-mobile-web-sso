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
import {Utils} from './views/utils';

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
     * Handle the page load
     */
    public async load(): Promise<Boolean> {

        // Do an automatic silent login on an iframe if there is a nonce query parameter
        let pageUrl = location.href;
        const nonce = urlparse(location.href, true).query.nonce || '';
        if (nonce) {
            
            try {

                pageUrl = await this.startSilentLogin(nonce);

            } catch (e: any) {

                console.log(`DEBUG SPA: silent login error: ${e}`)
                return false;
            }
        }
        
        // End a login if required, using the current page URL, then load the current user if applicable
        let isAuthenticated = await this.endLogin(pageUrl);
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
     * Start a silent login when using nonce based single sign on
     */
    private async startSilentLogin(nonce: string): Promise<string> {

        const data = await this.fetch('POST', 'login/start', this.getSilentLoginOptions(nonce));
        console.log(`DEBUG SPA: silent login redirect: ${data.authorizationRequestUrl}`);
        
        const frame = Utils.createHiddenIframe();
        frame.src = data.authorizationRequestUrl;

        return new Promise((resolve, reject) => {

            const callback = (e: MessageEvent) => {
                
                try {
                    resolve(this.handleSilentLoginResponse(e));
                } catch (e) {
                    reject(e);
                }
            };

            window.addEventListener('message', callback, false);
        });
    }

    /*
     * Do the work of completing the silent login response
     */
    private handleSilentLoginResponse(e: MessageEvent): string {

        const frame = Utils.removeHiddenIframe();
        window.removeEventListener('message', this.handleSilentLoginResponse);
        
        if (e.data && e.data.status === 'error') {
            
            const errorDescription = e.data.error_description || 'authentication failed';
            throw Error(`Silent login error: ${errorDescription}`);
        }

        return e.data;
    }

    /*
     * Start a login redirect on the main window
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
    private getSilentLoginOptions(nonce: string): any {

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
            key: 'login_hint',
            value: nonce,
        });

        return {
            extraParams,
        };
    }
}
