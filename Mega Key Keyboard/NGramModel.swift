import Foundation
import SQLite3
import UIKit

/// Queries the n-gram SQLite database produced by convert_to_sqlite.py.
/// Uses native SQLite3 (built into iOS — no dependencies needed).
class NGramModel: ObservableObject {

    // MARK: - Types

    struct Prediction: Identifiable {
        let id = UUID()
        let word: String
        let probability: Double
    }

    // MARK: - Properties

    private var db: OpaquePointer?
    private var statement: OpaquePointer?  // Reused prepared statement for performance
    private(set) var n: Int = 3
    private(set) var isLoaded: Bool = false

    // MARK: - Loading

    /// Call once at app launch. Only opens the file — nothing is read into memory.
    func load(filename: String = "ngrams", extension ext: String = "db") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("❌ NGramModel: Could not find \(filename).\(ext) in app bundle.")
            return
        }

        // Open read-only — the DB lives in the bundle and must not be modified
        guard sqlite3_open_v2(url.path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            print("❌ NGramModel: Failed to open database.")
            return
        }

        // Pre-compile the query once for fast reuse on every keystroke
        let sql = "SELECT word, prob FROM ngrams WHERE context = ? ORDER BY rank ASC LIMIT ?"
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("❌ NGramModel: Failed to prepare statement.")
            return
        }

        isLoaded = true
        print("✅ NGramModel: Opened \(url.lastPathComponent).")
    }

    // MARK: - Prediction

    /// Returns top predictions for the given input string.
    func predict(after input: String, topK: Int = 3) -> [Prediction] {
        guard isLoaded, let statement else { return [] }

        let tokens = tokenize(input)
        let contextSize = n - 1
        var contextTokens = Array(tokens.suffix(contextSize))
        while contextTokens.count < contextSize {
            contextTokens.insert("<s>", at: 0)
        }
        let key = contextTokens.joined(separator: " ")

        // Bind parameters
        sqlite3_reset(statement)
        sqlite3_bind_text(statement, 1, (key as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(topK * 3)) // Fetch extra to account for filtered words

        // Step through results, filtering out invalid words
        var predictions: [Prediction] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            let word = String(cString: sqlite3_column_text(statement, 0))
            let prob = sqlite3_column_double(statement, 1)
            if isRealWord(word) {
                predictions.append(Prediction(word: word, probability: prob))
            }
            if predictions.count >= topK { break }
        }

        return predictions
    }

    /// Returns true if the word exists in the iOS English dictionary.
    private func isRealWord(_ word: String) -> Bool
    {
        // Always allow "I" since UITextChecker may not handle it well
        if word == "I" { return true }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: word, range: range, startingAt: 0, wrap: false, language: "en_US")
        return misspelled.location == NSNotFound
    }

    // MARK: - Cleanup

    deinit {
        sqlite3_finalize(statement)
        sqlite3_close(db)
    }

    // MARK: - Helpers

    private func tokenize(_ text: String) -> [String] {
        var t = text.lowercased()

        // Rejoin contractions split with spaces e.g. "don ' t" → "don't"
        t = t.replacingOccurrences(of: #"\b(\w+)\s'\s(\w+)\b"#,
                                   with: "$1'$2", options: .regularExpression)

        // Drop entire contraction tokens e.g. "don't" → " "
        t = t.replacingOccurrences(of: #"\b\w*'\w*\b"#,
                                   with: " ", options: .regularExpression)

        // Strip everything except letters and spaces
        t = t.replacingOccurrences(of: "[^a-z\\s]", with: " ", options: .regularExpression)

        // Split, capitalize standalone "i", drop stray single chars except "a"
        return t.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .compactMap { token -> String? in
                if token == "i"                    { return "I" }
                if token.count == 1 && token != "a" { return nil }
                return token
            }
    }
}
