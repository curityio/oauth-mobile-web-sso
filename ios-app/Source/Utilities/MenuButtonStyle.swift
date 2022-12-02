import SwiftUI

/*
 * A custom style for our menu buttons
 */
struct MenuButtonStyle: ButtonStyle {

    private let width: CGFloat
    private let buttonFont = Font.system(.caption).weight(.bold)
    private let lightBlue = Color(red: 51 / 255, green: 153 / 255, blue: 255 / 255)

    init (width: CGFloat) {
        self.width = width
    }

    /*
     * Apply custom styles to the button label
     */
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {

        configuration.label
            .frame(width: self.width, height: 40)
            .foregroundColor(Color.black)
            .background(self.lightBlue)
            .font(self.buttonFont)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .cornerRadius(5)
            .padding()
    }
}

