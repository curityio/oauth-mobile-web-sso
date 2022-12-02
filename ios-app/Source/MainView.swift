import SwiftUI

/*
 * The entry point view for the mobile app
 */
struct MainView: View {

    var body: some View {
        VStack {
            Text("Mobile Web Demo App")
                .font(.title)
                .underline()
                .padding(.bottom)

            MenuView()
        }
        .padding()
    }
}

