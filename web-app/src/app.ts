import {OAuthClient} from './oauthClient';
import {TitleView} from './views/titleView';
import {ErrorView} from './views/errorView';
import {AuthenticatedView} from './views/authenticatedView';
import {UnauthenticatedView} from './views/unauthenticatedView';

class App {

    private readonly unauthenticatedView: UnauthenticatedView;
    private readonly authenticatedView: AuthenticatedView;
    private readonly oauthClient: OAuthClient;

    public constructor() {

        this.oauthClient = new OAuthClient();
        TitleView.create();
        ErrorView.create();
        this.unauthenticatedView = new UnauthenticatedView(this.oauthClient);
        this.authenticatedView = new AuthenticatedView(this.oauthClient);
    }

    public async execute(): Promise<void> {

        try {
        
            TitleView.render();

            // Do an automatic login redirect if required
            if (!await this.oauthClient.autoLogin()) {

                // Call the OAuth agent to determine the authentication state and subject
                const isAuthenticated = await this.oauthClient.load();
                
                // Call the appropriate view
                if (isAuthenticated) {
                    this.authenticatedView.render();
                } else {
                    this.unauthenticatedView.render();
                }
            }

        } catch (e: any) {

            ErrorView.render(e);
        }
    }
}

const app = new App();
app.execute();
