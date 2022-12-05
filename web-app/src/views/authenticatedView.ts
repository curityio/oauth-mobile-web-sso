import {OAuthClient} from '../oauthClient';
import {ErrorView} from './errorView';
import {Elements} from './elements';
import {Utils} from './utils';

/*
 * Presented after the web user is authenticated
 */
export class AuthenticatedView {

    private readonly oauthClient: OAuthClient;
    private subject: string;

    public constructor(oauthClient: OAuthClient) {

        this.oauthClient = oauthClient;
        this.subject = '';
        Utils.createContainer(Elements.Main);
        this.setupCallbacks();
    }

    /*
     * Retrieve userinfo when the view loads
     */
    public async loadSubject(): Promise<Boolean> {

        try {
            this.subject = await this.oauthClient.getSubject();
            return true;

        } catch (e: any) {

            ErrorView.render(e);
            return false;
        }
    }

    /*
     * Render the user as an indication that authentication worked as expected
     */
    public render() {

        const html = `<div>
                        <p>User is authenticated: ${this.subject}<p>
                        <p>Click <a id='btnLogout' href='#'>here</a> to sign out</p>
                      </div>`;
        
        Utils.setContainerContent(Elements.Main, html);
        document.querySelector('#btnLogout')?.addEventListener('click', this.onLogout);
    }

    /*
     * Trigger an OpenID Connect logout redirect
     */
    public async onLogout() {
        
        try {

            ErrorView.clear();
            this.oauthClient.logout();

        } catch (e: any) {

            ErrorView.render(e);
        }
    }

    private setupCallbacks() {
        this.onLogout = this.onLogout.bind(this);
    }
}
