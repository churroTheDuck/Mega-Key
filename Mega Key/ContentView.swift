//
//  ContentView.swift
//  Mega Key
//
//  Created by Lang Chen on 8/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { g in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 10)
                    Text("Mega Key Custom Keyboard")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.largeTitle)
                    Text("This is not an app, but rather a custom keyboard that will replace the default iOS system keyboard. It has significantly larger keys, making it easier to spell correctly.")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Text("How to use it")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.largeTitle)
                    Text("Step 1: Go to the Settings app.")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Text("Step 2: Click the \"Keyboard\" button.")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Text("Step 3: Click on \"Keyboards.\"")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Text("Step 4: Click \"Add New Keyboard.\"")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Text("Step 5: Under \"Third-Party Keyboards\", select \"Mega Key.\"")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Text("Step 6: To use the keyboard in an app such as Safari or Notes, simply tap and hold the globe icon and select the option that says \"Mega Key Keyboard - Mega Key.\"")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("6")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Text("If the keyboard does not immediately show up after switching to it via the globe icon, please wait a few seconds and try again.")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(.red)
                        .font(.body)
                    Text("The keyboard should now be ready for use!")
                        .frame(width: g.size.width * 0.8)
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    Image("7")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Image("8")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.8)
                    Spacer()
                        .frame(height: 10)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
}
