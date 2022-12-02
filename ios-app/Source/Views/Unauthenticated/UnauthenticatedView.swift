import SwiftUI
import SafariServices

/*
 * The screen presented before login, to trigger a standard redirect
 */
struct UnauthenticatedView: View {

    private let configuration: Configuration

    init() {
        self.configuration = ConfigurationLoader.load()
    }

    /*
     * Render an option to login
     */
    var body: some View {
        
        let deviceWidth = UIScreen.main.bounds.size.width
        return VStack {

            Button(action: self.onBeginLogin) {
                Text("Sign in to the Mobile App")
            }
            .buttonStyle(MenuButtonStyle(width: deviceWidth * 0.77))
        }
    }

    private func onBeginLogin() {

        let url = URL(string: self.configuration.webAppUrl)
        UIApplication.shared.open(url!)
    }
}
