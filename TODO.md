## Mobile OAuth Flow

- Render a login button when there are no tokens
- Register mobile and web clients with scope openid
- Implement code from main AppAuth sample
- Update docs
- Print the ID token
- Deploy the plugin and create a nonce authenticator
- Get a nonce and pass it to the webview

## Web OAuth Flow

- Deploy oauth-agent and get SPA to use it to login if it has no cookie yet
- Document local setup for web development
- Use the nonce when a load occurs and it is present
- Get rid of nonce authenticator from standard logins
