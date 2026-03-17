//
//  PredictionView.swift
//  Spell 2 Speak
//
//  Created by Lang Chen on 4/14/24.
//

import SwiftUI

struct PredictionView: View {
    @StateObject private var model = NGramModel()
    @State var textPredictions: [NGramModel.Prediction] = []
    @State var textCompletions = ["", "", ""]
    var textDocumentProxy: UITextDocumentProxy
    var documentContext: String  // driven by KeyboardState
    var updateContext: () -> Void
    var body: some View {
        GeometryReader { g in
            HStack(spacing: 0) {
                ForEach(0..<3) { i in
                    let prediction: String = {
                        if documentContext.hasSuffix(" ") {
                            return i < textPredictions.count ? textPredictions[i].word : ""
                        } else {
                            return i < textCompletions.count ? textCompletions[i] : ""
                        }
                    }()
                    Button(action: {
                        if !prediction.isEmpty {
                            if !documentContext.hasSuffix(" ") {
                                let partialWord = documentContext.components(separatedBy: " ").last ?? ""
                                for _ in partialWord {
                                    textDocumentProxy.deleteBackward()
                                    updateContext()
                                }
                            }
                            textDocumentProxy.insertText(prediction + " ")
                            updateContext()
                        }
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: g.size.width / 3 - 10, height: g.size.height - 10)
                                .foregroundStyle(Color("buttonColor"))
                                .padding(5)
                            Text(prediction)
                                .font(.title.weight(.regular))
                                .foregroundStyle(Color("textColor"))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            model.load()
        }
        .onChange(of: documentContext) { context in
            if context.hasSuffix(" ") {
                textPredictions = model.predict(after: context, topK: 3)
            } else {
                let partialWord = context.components(separatedBy: " ").last ?? ""
                if partialWord.isEmpty {
                    textCompletions = ["", "", ""]
                } else {
                    let range = NSMakeRange(0, partialWord.utf16.count)
                    let spellChecker = UITextChecker()
                    let completions = spellChecker.completions(
                        forPartialWordRange: range,
                        in: partialWord,
                        language: "en_US"
                    )
                    if let completions = completions, completions.count >= 3 {
                        textCompletions = Array(completions.prefix(3))
                    } else {
                        textCompletions = ["", "", ""]
                    }
                }
            }
        }
    }
}
