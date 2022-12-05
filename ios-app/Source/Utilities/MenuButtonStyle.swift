//
// Copyright (C) 2022 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

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

