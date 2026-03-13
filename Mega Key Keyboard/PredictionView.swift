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
    let suggestions: [String]
    let onSelect: (String) -> Void
    var body: some View {
        GeometryReader { g in
            HStack(spacing: 0) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        onSelect(clean(suggestion))
                        AudioServicesPlaySystemSound(1104)
                    }) {
                        ZStack {
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: g.size.width / 6 - 10, height: g.size.height / 5 - 10)
                                .foregroundColor(Color("buttonColor"))
                                .padding(5)
                            Text(clean(suggestion))
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
