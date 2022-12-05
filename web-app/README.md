# Minimal Browser Based App

A minimal Single Page Application (SPA) to run on a mobile device from a mobile app.\
The app uses the token handler pattern to implement its OpenID Connect security.\
It can use a nonce during OpenID Connect redirects, to ensure Single Sign On (SSO).

## Web Development Setup

First configure the following domai in the hosts file:

```text
127.0.0.1 example.com
```

Next run the web app with this script:

```bash
./run.sh
```

Then run the main deployment from the root folder differently.\
Use a profile with components needed by the web application:

```bash
export DEPLOYMENT_PROFILE='WEB'
export BASE_URL='http://example.com'
./build.sh
./deploy.sh
```

Then browse to this URL to run the SPA in a desktop browser:

```text
http://example.com:3000
```

HTML and Javascript files are shared to the Docker host via a volume.\
Run this command when developing locally, then refresh the browser to see changes:

```bash
npm start
```
