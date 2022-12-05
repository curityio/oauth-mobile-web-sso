import axios, {AxiosRequestConfig, AxiosRequestHeaders, Method} from 'axios';
import urlparse from 'url-parse';

/*
 * A utility to interact with the OAuth agent to manage authentication
 */
export class OAuthClient {

    private baseUrl: string;
    private nonce: string;
    private antiForgeryToken: string;
    
    public constructor() {
        
        this.baseUrl = `${location.origin}/oauth-agent`;
        this.antiForgeryToken = '';
        this.nonce = urlparse(location.href, true).query.nonce || '';
    }

    /*
     * Start a login redirect
     */
    public async startLogin(): Promise<void> {

        const data = await this.fetch('POST', 'login/start', this.getLoginOptions());
        location.href = data.authorizationRequestUrl;
    }

    /*
     * End a login if required, and return the authenticated state
     */
    public async endLogin(): Promise<Boolean> {

        const request = JSON.stringify({
            pageUrl: location.href,
        });

        const response = await this.fetch('POST', 'login/end', request);
        if (response.handled) {
            history.replaceState({}, document.title, '/spa');
        }

        this.antiForgeryToken = response.csrf;
        return response.isLoggedIn;
    }

    /*
     * Get the logged in subject as a very basic way of displaying the user
     */
    public async getSubject(): Promise<string> {
        
        const claims = await this.fetch('GET', 'userInfo', null);
        if (claims.sub) {
            return claims.sub;
        }

        return '';
    }

    /*
     * Sign the user out
     */
    public async logout(): Promise<void> {

        const data = await this.fetch('POST', 'logout', null);
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
     * Get additional redirect options
     */
    private getLoginOptions(): any {

        if (this.nonce) {
        
            return {
                extraParams: [
                    {
                        key: 'acr_values',
                        value: 'urn:se:curity:authentication:nonce:nonce1',
                    },
                    {
                        key: 'login_hint',
                        value: this.nonce,
                    },
                ]
            };

        } else {

            return {
                extraParams: [
                    {
                        key: 'prompt',
                        value: 'login',
                    },
                ]
            };
        }
    }
}