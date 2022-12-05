import {OAuthClient} from '../oauthClient';
import {ErrorView} from './errorView';
import {Elements} from './elements';
import {Utils} from './utils';

/*
 * Presented before the web user is authenticated
 */
export class UnauthenticatedView {

    private readonly oauthClient: OAuthClient;

    public constructor(oauthClient: OAuthClient) {

        this.oauthClient = oauthClient;
        Utils.createContainer(Elements.Main);
        this.setupCallbacks();
    }

    /*
     * Render a button so that we can trigger a redirect manually
     */
    public render() {

        const html = `<div>
                        <p>User is unauthenticated<p>
                        <p>Click <a id='btnLogin' href='#'>here</a> to sign in</p>
                    </div>`;

        Utils.setContainerContent(Elements.Main, html);
        document.querySelector('#btnLogin')?.addEventListener('click', this.onLogin);
    }

    /*
     * Trigger an OpenID Connect login redirect
     */
    public async onLogin() {
        
        try {

            ErrorView.clear();
            this.oauthClient.startLogin();

        } catch (e: any) {

            ErrorView.render(e);
        }
    }

    private setupCallbacks() {
        this.onLogin = this.onLogin.bind(this);
    }
}
