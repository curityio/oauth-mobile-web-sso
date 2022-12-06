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
import WebKit

/*
 * The web view dialog's overall layout
 */
struct WebViewDialog: View {

    @Environment(\.presentationMode) private var presentationMode
    private let url: URL
    private let width: CGFloat
    private let height: CGFloat
    
    /*
     * Store configuration and create the bridge object
     */
    init(url: URL, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
    }

    /*
     * Render the view
     */
    var body: some View {

        GeometryReader { geometry in

            VStack {

                HStack(spacing: 0) {

                    // Render the title
                    Text("")
                        .font(.headline)
                        .frame(width: geometry.size.width * 0.9)

                    // Render a close button to the right
                    Text("X")
                        .frame(width: geometry.size.width * 0.1, alignment: .leading)
                        .onTapGesture(perform: self.onClose)

                }.padding(.top)

                // Render the SPA in a web view
                WebView(
                    url: self.url,
                    width: self.width,
                    height: self.height)

            }.contentShape(Rectangle())
        }
    }

    /*
     * Handle closing the modal dialog
     */
    private func onClose() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
