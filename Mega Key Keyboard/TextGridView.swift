//
//  TextGridView.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 9/13/24.
//

import SwiftUI
import AVFoundation

struct TextGridView: View {
    @Binding var caps: Bool
    @Binding var capsLock: Bool
    var textDocumentProxy: UITextDocumentProxy
    var body: some View {
        GeometryReader { g in
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                    ForEach(["A", "B", "C", "D", "E", ",", "F", "G", "H", "I", "J", ".", "K", "L", "M", "N", "O", "!", "P", "Q", "R", "S", "T", "?", "U", "V", "W", "X", "Y", "Z"], id: \.self) { letter in
                        Button(action: {
                            if !capsLock {
                                if caps {
                                    textDocumentProxy.insertText(letter)
                                    if (letter != "(" && letter != ")" && letter != "-" && letter != "/") {
                                        caps = false
                                    }
                                } else {
                                    textDocumentProxy.insertText(letter.description.lowercased())
                                }
                            } else {
                                textDocumentProxy.insertText(letter)
                            }
                            AudioServicesPlaySystemSound(1104)
                        }) {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(15)
                                    .frame(width: g.size.width / 6 - 10, height: g.size.height / 5 - 10)
                                    .foregroundColor(Color("buttonColor"))
                                    .padding(5)
                                Text(caps || capsLock ? letter : letter.lowercased())
                                    .font(.largeTitle.weight(.regular))
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                }
        }
    }
}
