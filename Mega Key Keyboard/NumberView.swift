//
//  NumberView.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 9/29/24.
//

import SwiftUI
import AVFoundation

struct NumberView: View {
    @State var caps = true
    @State var capsLock = false
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
                ForEach(["(", ")", "$", "&", "@", "!", "-", "/", ":", "'", "\"", "?", "0", "1", "2", "3", "4", ",", "5", "6", "7", "8", "9", "."], id: \.self) { letter in
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
                                    .frame(width: g.size.width / 6, height: g.size.height / 4)
                                    .foregroundColor(Color("color"))
                                    .border(Color("borderColor"), width: 1)
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
