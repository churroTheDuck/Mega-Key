//
//  KeyboardViewController.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 8/25/24.
//

import SwiftUI
import AVFoundation

struct KeyboardView: View {
    @State var timer: Timer?
    @State var caps = true
    @State var capsLock = false
    @State var view = "text"
    var textDocumentProxy: UITextDocumentProxy
    var advanceToNextInputMode: (() -> Void)?
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        advanceToNextInputMode?()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width / 6, height: g.size.height / 6)
                                .foregroundColor(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Image(systemName: "globe")
                                .font(.title.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    Button(action: {
                        if (view == "text") {
                            view = "number"
                        } else {
                            view = "text"
                        }
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width / 6, height: g.size.height / 6)
                                .foregroundColor(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Image(systemName: view == "text" ? "textformat.123" : "abc")
                                .font(.title.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: g.size.width / 6, height: g.size.height / 6)
                            .foregroundColor(Color("color"))
                            .border(Color("borderColor"), width: 1)
                        Image(systemName: capsLock ? "capslock.fill" : caps ? "shift.fill" : "shift")
                            .font(.largeTitle.weight(.regular))
                            .foregroundColor(Color("textColor"))
                    }
                    .gesture(LongPressGesture(minimumDuration: 1.5).onEnded { _ in
                        capsLock = true
                    })
                    .simultaneousGesture(TapGesture(count: 1).onEnded {
                        if capsLock {
                            capsLock = false
                            caps = false
                        } else {
                            if caps {
                                caps = false
                            } else {
                                caps = true
                            }
                        }
                    })
                    Button(action: {
                        textDocumentProxy.deleteBackward()
                        AudioServicesPlaySystemSound(1155)
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width / 6, height: g.size.height / 6)
                                .foregroundColor(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Image(systemName: "delete.left")
                                .font(.largeTitle.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
                                if let text = textDocumentProxy.documentContextBeforeInput {
                                    let modifiedText = text.components(separatedBy: " ").dropLast().joined(separator: " ")
                                    for _ in text {
                                        textDocumentProxy.deleteBackward()
                                    }
                                    textDocumentProxy.insertText(modifiedText)
                                }
                                AudioServicesPlaySystemSound(1155)
                            }
                        })
                    .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            timer?.invalidate()
                        })
                    Button(action: {
                        textDocumentProxy.insertText(" ")
                        AudioServicesPlaySystemSound(1104)
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width / 6, height: g.size.height / 6)
                                .foregroundColor(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Text("Space")
                                .font((g.size.height * 3 > g.size.width) ? .body : .title.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    Button(action: {
                        textDocumentProxy.insertText("\n")
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width / 6, height: g.size.height / 6)
                                .foregroundColor(Color("color"))
                                .border(Color("borderColor"), width: 1)
                            Image(systemName: "return")
                                .font(.largeTitle.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                if (view == "text") {
                    TextGridView(textDocumentProxy: textDocumentProxy)
                        .frame(width: g.size.width, height: g.size.height * 5 / 6)
                } else {
                    NumberView(textDocumentProxy: textDocumentProxy)
                        .frame(width: g.size.width, height: g.size.height * 5 / 6)
                }
            }
        }
    }
}

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardView = KeyboardView(textDocumentProxy: textDocumentProxy, advanceToNextInputMode: advanceToNextInputMode)
        let hostingController = UIHostingController(rootView: keyboardView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame.size.width = UIScreen.main.bounds.size.width
        hostingController.view.frame.size.height = UIScreen.main.bounds.size.height * 0.6
        hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}
