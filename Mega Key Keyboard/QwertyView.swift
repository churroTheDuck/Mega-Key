//
//  QwertyView.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 9/14/24.
//

import SwiftUI
import AVFoundation

struct QwertyView: View {
    @State var caps = true
    @State var capsLock = false
    @Binding var left: Bool
    var textDocumentProxy: UITextDocumentProxy
    var body: some View {
        let leftAlphabet = ["Q", "W", "E", "R", "T", "A", "S", "D", "F", "G", "Z", "X", "C", "V", "B"]
        let rightAlphabet = ["Y", "U", "I", "O", "P", "H", "J", "K", "L", "!", "N", "M", ",", ".", "?"]
        let columns = [GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),]
        GeometryReader { g in
            VStack(spacing: -1) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(left ? leftAlphabet : rightAlphabet, id: \.self) { letter in
                        Button(action: {
                            if !capsLock {
                                if caps {
                                    textDocumentProxy.insertText(letter)
                                    caps = false
                                } else {
                                    textDocumentProxy.insertText(letter.lowercased())
                                }
                            } else {
                                textDocumentProxy.insertText(letter)
                            }
                            AudioServicesPlaySystemSound(1155)
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: g.size.width / 5, height: g.size.height / 4)
                                    .foregroundStyle(Color("color"))
                                    .border(Color("borderColor"), width: 1)
                                Text(caps || capsLock ? letter : letter.lowercased())
                                    .foregroundStyle(Color("textColor"))
                                    .font(.largeTitle.weight(.regular))
                                
                            }
                        }
                    }
                }
                HStack(spacing: 0) {
                    Button(action: {
                        textDocumentProxy.insertText(" ")
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width * 3 / 5, height: g.size.height / 4)
                                .foregroundStyle(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Image(systemName: "space")
                                .foregroundStyle(Color("textColor"))
                                .font(.largeTitle.weight(.regular))
                        }
                    }
                    if (!left) {
                        Button(action: {
                            left = true
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: g.size.width * 2 / 5, height: g.size.height / 4)
                                    .foregroundStyle(Color("color"))
                                    .border(Color("borderColor"), width: 1)
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(Color("textColor"))
                                    .font(.largeTitle.weight(.regular))
                            }
                        }
                    }
                    if (left) {
                        Button(action: {
                            left = false
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: g.size.width * 2 / 5, height: g.size.height / 4)
                                    .foregroundStyle(Color("color"))
                                    .border(Color("borderColor"), width: 1)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("textColor"))
                                    .font(.largeTitle.weight(.regular))
                            }
                        }
                    }
                }
            }
        }
    }
}
