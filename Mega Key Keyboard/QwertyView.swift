//
//  QwertyView.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 9/14/24.
//

import SwiftUI
import AVFoundation

struct QwertyView: View {
    @State var timer: Timer?
    @State var caps = true
    @State var capsLock = false
    var textDocumentProxy: UITextDocumentProxy
    var advanceToNextInputMode: (() -> Void)?
    var dismissKeyboard: (() -> Void)?
    var body: some View {
        let alphabet = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "!", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "?"]
        let columns = [GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),
                       GridItem(.flexible(), spacing: 0),]
        GeometryReader { g in
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(alphabet, id: \.self) { letter in
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
                                .frame(width: g.size.width / 10, height: g.size.height / 4)
                                .foregroundStyle(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Text(caps || capsLock ? letter : letter.lowercased())
                                .foregroundStyle(Color("textColor"))
                                .font(.largeTitle.weight(.regular))
                            
                        }
                    }
                }
            }
        }
    }
}
