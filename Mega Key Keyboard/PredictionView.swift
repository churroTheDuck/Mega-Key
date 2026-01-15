//
//  TextGridView.swift
//  Mega Key Keyboard
//
//  Created by Lang Chen on 9/13/24.
//

import SwiftUI
import AVFoundation

struct PredictionView: View {
    var textDocumentProxy: UITextDocumentProxy
    @Binding var predictions: [String]
    var getPredictions: (String, @escaping ([String]) -> Void) -> Void
    var body: some View {
        GeometryReader { g in
            HStack(spacing: 0) {
                ForEach(predictions, id: \.self) { prediction in
                    Button(action: {
                        let currentText = textDocumentProxy.documentContextBeforeInput ?? ""
                        if !currentText.hasSuffix(" ") && !currentText.isEmpty {
                            while let context = textDocumentProxy.documentContextBeforeInput,
                                  !context.isEmpty && !context.hasSuffix(" ") {
                                textDocumentProxy.deleteBackward()
                            }
                        }
                        textDocumentProxy.insertText(prediction + " ")
                        getPredictions(textDocumentProxy.documentContextBeforeInput ?? "") { suggestions in
                            do {
                                predictions = suggestions
                            } catch {}
                        }
                        AudioServicesPlaySystemSound(1104)
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: g.size.width / 3 - 10, height: g.size.height - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
                            Text(clean(prediction))
                                .font(.largeTitle.weight(.regular))
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
            }
        }
    }
    
    private func clean(_ suggestion: String) -> String {
        if suggestion.hasPrefix("\"") && suggestion.hasSuffix("\"") {
            return String(suggestion.dropFirst().dropLast())
        }
        return suggestion
    }
}
