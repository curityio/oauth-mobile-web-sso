import SwiftUI

/*
 * The main view for the mobile app
 */
struct MainView: View {
    
    @ObservedObject private var model: MainViewModel

    init(model: MainViewModel) {
        self.model = model
    }

    var body: some View {

        VStack {
            
            Text("Mobile Web Demo App")
                .font(.title)
                .underline()
                .padding(.bottom)
            
            if (!self.model.isAuthenticated) {
                AuthenticatedView()
            } else {
                UnauthenticatedView()
            }

            Spacer()
        }
        .padding()
    }
}
