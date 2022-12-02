import SwiftUI
import SafariServices

/*
 * The screen presented after login, for selecting how to invoke the SPA
 */
struct AuthenticatedView: View {

    @State private var showModal = false
    private let configuration: Configuration

    init() {
        self.configuration = ConfigurationLoader.load()
    }

    /*
     * Render some ways to invoke the web app
     */
    var body: some View {

        let deviceWidth = UIScreen.main.bounds.size.width
        return VStack {

            Button {
                self.showModal = true
            } label: {
                Text("Run SPA in Web View")
            }
            .sheet(isPresented: self.$showModal) {
                self.onInvokeWebView()
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))

            Button(action: self.onInvokeSafariViewController) {
               Text("Run SPA in Safari View Controller")
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))
            
            Button(action: self.onInvokeSystemBrowser) {
               Text("Run SPA in System Browser")
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))
        }
    }

    /*
     * Open the SPA in a web view
     */
    private func onInvokeWebView() -> WebViewDialog {
        
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height

        return WebViewDialog(
            url: URL(string: self.configuration.webAppUrl)!,
            width: deviceWidth,
            height: deviceHeight)
    }

    /*
     * Open the SPA in the integrated Safari View Controller browser
     */
    private func onInvokeSafariViewController() {

        let safariConfiguration = SFSafariViewController.Configuration()
        safariConfiguration.entersReaderIfAvailable = true

        let url = URL(string: self.configuration.webAppUrl)
        let safari = SFSafariViewController(url: url!, configuration: safariConfiguration)
        self.getHostingViewController().present(safari, animated: true)
    }

    /*
     * Open the SPA in the system browser
     */
    private func onInvokeSystemBrowser() {

        let url = URL(string: self.configuration.webAppUrl)
        UIApplication.shared.open(url!)
    }
    
    /*
     * A helper method to get the main view controller
     */
    private func getHostingViewController() -> UIViewController {

        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        return scene.keyWindow!.rootViewController!
    }
}
