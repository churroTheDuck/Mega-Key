//
//  KeyboardViewController.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 8/25/24.
//

import SwiftUI
import AVFoundation
import UIKit
import PredictionKeyboard

struct KeyboardView: View {
    @State var timer: Timer?
    @State var caps = true
    @State var capsLock = false
    @State var view = "text"
    @State var left = true
    let isQwerty = UserDefaults(suiteName: "group.mega-key")?.integer(forKey: "isQwerty") ?? 0
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
                                .cornerRadius(15)
                                .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
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
                                .cornerRadius(15)
                                .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
                            Image(systemName: view == "text" ? "textformat.123" : "abc")
                                .font(.title.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                            .foregroundColor(Color("buttonColor"))
                            .padding(5)
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
                        AudioServicesPlaySystemSound(1155)
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
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
                    if (isQwerty != 2) {
                        Button(action: {
                            textDocumentProxy.insertText(" ")
                            AudioServicesPlaySystemSound(1104)
                        }) {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(15)
                                    .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                                    .foregroundColor(Color("buttonColor"))
                                    .padding(5)
                                Image(systemName: "space")
                                    .font(.largeTitle.weight(.regular))
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                    Button(action: {
                        textDocumentProxy.insertText("\n")
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: isQwerty != 2 ? g.size.width / 6 - 10 : g.size.width / 5 - 10, height: g.size.height / 6 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
                            Image(systemName: "return")
                                .font(.largeTitle.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                if (view == "text") {
                    switch (isQwerty) {
                    case 0:
                        TextGridView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy)
                            .frame(width: g.size.width, height: g.size.height * 5 / 6)
                    case 1:
                        QwertyView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy)
                            .frame(width: g.size.width, height: g.size.height * 5 / 6)
                    case 2:
                        SplitQwertyView(caps: $caps, capsLock: $capsLock, left: $left, textDocumentProxy: textDocumentProxy)
                            .frame(width: g.size.width, height: g.size.height * 5 / 6)
                    default:
                        TextGridView(caps: $caps, capsLock: $capsLock, textDocumentProxy: textDocumentProxy)
                            .frame(width: g.size.width, height: g.size.height * 5 / 6)
                    }
                } else {
                    NumberView(textDocumentProxy: textDocumentProxy)
                        .frame(width: g.size.width, height: g.size.height * 5 / 6)
                }
            }
        }
        .background(Color("backgroundColor"))
        .ignoresSafeArea(.keyboard)
    }
}

/*class KeyboardViewController: UIInputViewController {
    
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
}*/

class KeyboardViewController: UIInputViewController {

    private var predictionManager: PredictionKeyboardManager!
    private var suggestionBar: UIStackView!
    private var suggestionButtons: [UIButton] = []
    private var databaseInitialized = false

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupPredictionManager()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPredictionManager()
    }

    private func setupPredictionManager() {
        // IMPORTANT: Replace with YOUR unique app group identifier (same as main app)
        predictionManager = PredictionKeyboardManager(appGroup: "group.mega-key")

        // Initialize database in background
        predictionManager.initializePredictionDatabase { [weak self] success, error in
            if success {
                self?.databaseInitialized = true
                print("[Keyboard] Prediction database ready!")
            } else {
                print("[Keyboard] Database initialization failed: \(error?.localizedDescription ?? "")")
            }
        }
    }

    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSuggestionBar()
        setupNextKeyboardButton()
        let currentText = "hel"

        predictionManager.getPrediction(currentText) { [weak self] suggestions, textColor in
            self?.updateSuggestions(suggestions, color: textColor)
        }
    }

    private func setupSuggestionBar() {
        // Create 3 suggestion buttons
        for i in 0..<3 {
            let button = UIButton(type: .system)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.tag = i
            button.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
            suggestionButtons.append(button)
        }

        suggestionBar = UIStackView(arrangedSubviews: suggestionButtons)
        suggestionBar.axis = .horizontal
        suggestionBar.distribution = .fillEqually
        suggestionBar.alignment = .center
        suggestionBar.spacing = 8
        suggestionBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(suggestionBar)

        NSLayoutConstraint.activate([
            suggestionBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            suggestionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            suggestionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            suggestionBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupNextKeyboardButton() {
        // Add next keyboard button (required for custom keyboards)
        let nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle("🌐", for: .normal)
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        view.addSubview(nextKeyboardButton)

        NSLayoutConstraint.activate([
            nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Suggestion Handling

    @objc private func suggestionTapped(_ sender: UIButton) {
        guard var suggestion = sender.titleLabel?.text, !suggestion.isEmpty else { return }

        // Remove quotes if present (word completion mode)
        if suggestion.hasPrefix("\"") && suggestion.hasSuffix("\"") {
            suggestion = String(suggestion.dropFirst().dropLast())
        }

        // Delete current partial word
        let currentText = textDocumentProxy.documentContextBeforeInput ?? ""
        if !currentText.hasSuffix(" ") && !currentText.isEmpty {
            while let context = textDocumentProxy.documentContextBeforeInput,
                  !context.isEmpty && !context.hasSuffix(" ") {
                textDocumentProxy.deleteBackward()
            }
        }

        // Insert the suggestion with a space
        textDocumentProxy.insertText(suggestion + " ")
    }

    private func updateSuggestions(_ suggestions: [String], color: UIColor) {
        for (index, button) in suggestionButtons.enumerated() {
            if index < suggestions.count && !suggestions[index].isEmpty {
                button.setTitle(suggestions[index], for: .normal)
                button.setTitleColor(color, for: .normal)
                button.isHidden = false
            } else {
                button.setTitle("", for: .normal)
                button.isHidden = true
            }
        }
    }

    // MARK: - UIInputViewController Overrides

    override func textDidChange(_ textInput: UITextInput?) {
        guard databaseInitialized else { return }

        let currentText = textDocumentProxy.documentContextBeforeInput ?? ""

        predictionManager.getPrediction(currentText) { [weak self] suggestions, textColor in
            self?.updateSuggestions(suggestions, color: textColor)
        }
    }
}
