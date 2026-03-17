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
    @State var left = true
    let isQwerty = UserDefaults(suiteName: "group.mega-key")?.integer(forKey: "isQwerty") ?? 0
    // abc is 0, qwerty is 1, qwerty-split is 2
    @ObservedObject var keyboardState: KeyboardState
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
                                .cornerRadius(isQwertyView() ? 10 : 15)
                                .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(isQwertyView() ? 2 : 5)
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
                        updateContext()
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(isQwertyView() ? 10 : 15)
                                .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(isQwertyView() ? 2 : 5)
                            Image(systemName: view == "text" ? "textformat.123" : "abc")
                                .font(.title.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    ZStack {
                        Rectangle()
                            .cornerRadius(isQwertyView() ? 10 : 15)
                            .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                            .foregroundColor(Color("buttonColor"))
                            .padding(isQwertyView() ? 2 : 5)
                        Image(systemName: capsLock ? "capslock.fill" : caps ? "shift.fill" : "shift")
                            .font(.largeTitle.weight(.regular))
                            .foregroundColor(Color("textColor"))
                    }
                    .gesture(LongPressGesture(minimumDuration: 1).onEnded { _ in
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
                        print("\(caps)caps")
                    })
                    Button(action: {
                        textDocumentProxy.deleteBackward()
                        updateContext()
                        AudioServicesPlaySystemSound(1155)
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(isQwertyView() ? 10 : 15)
                                .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(isQwertyView() ? 2 : 5)
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
                                        updateContext()
                                    }
                                    textDocumentProxy.insertText(modifiedText)
                                    updateContext()
                                }
                                AudioServicesPlaySystemSound(1155)
                            }
                        })
                    .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            timer?.invalidate()
                        })
                    if (isQwerty != 2) {
                        Button(action: {
                            textDocumentProxy.insertText(" ")
                            updateContext()
                            AudioServicesPlaySystemSound(1104)
                        }) {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(isQwertyView() ? 10 : 15)
                                    .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                                    .foregroundColor(Color("buttonColor"))
                                    .padding(isQwertyView() ? 2 : 5)
                                Image(systemName: "space")
                                    .font(.largeTitle.weight(.regular))
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                    Button(action: {
                        textDocumentProxy.insertText("\n")
                        updateContext()
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(isQwertyView() ? 10 : 15)
                                .frame(width: isQwertyView() ? g.size.width / 6 - 4 : (isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10), height: isQwertyView() ? g.size.width / 7 - 4 : g.size.height / 7 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(isQwertyView() ? 2 : 5)
                            Image(systemName: "return")
                                .font(.largeTitle.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                PredictionView(textDocumentProxy: textDocumentProxy, documentContext: keyboardState.documentContext, updateContext: updateContext)
                    .frame(width: g.size.width, height: g.size.height * 1 / 7)
                if (view == "text") {
                    switch (isQwerty) {
                    case 0:
                        TextGridView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy, updateContext: updateContext)
                            .frame(width: g.size.width, height: g.size.height * 5 / 7)
                    case 1:
                        QwertyView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy, updateContext: updateContext)
                            .frame(width: g.size.width, height: g.size.height * 5 / 7)
                    case 2:
                        SplitQwertyView(caps: $caps, capsLock: $capsLock, left: $left, textDocumentProxy: textDocumentProxy, updateContext: updateContext)
                            .frame(width: g.size.width, height: g.size.height * 5 / 7)
                    default:
                        TextGridView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy, updateContext: updateContext)
                            .frame(width: g.size.width, height: g.size.height * 5 / 7)
                    }
                } else {
                    NumberView(textDocumentProxy: textDocumentProxy, updateContext: updateContext)
                        .frame(width: g.size.width, height: g.size.height * 5 / 7)
                }
            }
        }
        .background(Color("backgroundColor"))
        .ignoresSafeArea(.keyboard)
    }
    func isQwertyView() -> Bool {
        return view == "text" && isQwerty == 1
    }
    func updateContext() {
        keyboardState.documentContext = textDocumentProxy.documentContextBeforeInput ?? ""
    }
}

class KeyboardViewController: UIInputViewController {
    let keyboardState = KeyboardState()
    var hostingController: UIHostingController<KeyboardView>?
    
    @State var documentContext: String = ""
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardView = KeyboardView(keyboardState: keyboardState, textDocumentProxy: textDocumentProxy, advanceToNextInputMode: advanceToNextInputMode)
        let hostingController = UIHostingController(rootView: keyboardView)
        self.hostingController = hostingController
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
    }
}

// Shared state object
class KeyboardState: ObservableObject {
    @Published var documentContext: String = ""
}
