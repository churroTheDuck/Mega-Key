//
//  ContentView.swift
//  Mega Key
//
//  Created by Lang Chen on 8/25/24.
//

import SwiftUI
import UIKit
import PredictionKeyboard

class SettingsViewModel: ObservableObject {
    @AppStorage("isQwerty", store: UserDefaults(suiteName: "group.mega-key")) var isQwerty: Int = 0
}

struct ContentView: View {
    @StateObject private var settings = SettingsViewModel()
    var body: some View {
        GeometryReader { g in
            Form {
                Section(header: Text("KEYBOARD LAYOUT")) {
                    Picker("Layout", selection: $settings.isQwerty) {
                        Text("ABC").tag(0)
                        Text("QWERTY").tag(1)
                        Text("Split QWERTY").tag(2)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                Section(header: Text("SPLIT QWERTY")) {
                    Text("Split QWERTY is designed for people who need a significantly larger keyboard. It displays half of the keyboard on the screen at once, and you can switch between the two halves by clicking the blue button.")
                        .foregroundStyle(Color("textColor"))
                        .font(.body)
                    HStack {
                        Image("9")
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(g.size.width * 0.3, 250))
                        Image(systemName: "arrowshape.left.arrowshape.right")
                        Image("8")
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(g.size.width * 0.3, 250))
                    }
                }
                Text("Mega Key Custom Keyboard")
                    .foregroundStyle(Color("textColor"))
                    .font(.largeTitle)
                Text("This is not an app, but rather a custom keyboard that will replace the default iOS system keyboard. It has significantly larger keys, making it easier to spell correctly.")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Text("How to install it")
                    .foregroundStyle(Color("textColor"))
                    .font(.largeTitle)
                Text("Step 1: Go to the Settings app.")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Text("Step 2: Click the \"General\" button.")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("0")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("Step 3: Click the \"Keyboard\" button.")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("Step 4: Click on \"Keyboards.\"")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("Step 5: Click \"Add New Keyboard.\"")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("Step 6: Under \"Third-Party Keyboards\", select \"Mega Key.\"")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("Step 7: To use the keyboard in an app such as Safari or Notes, simply tap and hold the globe icon and select the option that says \"Mega Key Keyboard - Mega Key.\"")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Text("If the keyboard does not immediately show up after switching to it via the globe icon, please wait a few seconds and try again.")
                    .foregroundStyle(.red)
                    .font(.body)
                Text("The keyboard should now be ready for use!")
                    .foregroundStyle(Color("textColor"))
                    .font(.body)
                Image("6")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
                Image("7")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(g.size.width * 0.6, 400))
            }
        }
    }
}

class ViewController: UIViewController {

    private var predictionManager: PredictionKeyboardManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize with app group (for keyboard extension sharing)
        // IMPORTANT: Replace with YOUR unique app group identifier
        predictionManager = PredictionKeyboardManager(appGroup: "group.mega-key")

        // Check if database is already downloaded
        if predictionManager.isDatabaseDownloaded() {
            print("Database already exists, initializing...")
            initializeDatabase()
        } else {
            print("Database not found, starting download...")
            downloadDatabase()
        }
    }

    private func downloadDatabase() {
        // Show download UI with progress bar
        predictionManager.downloadDatabase(withUI: self) { [weak self] success, error in
            if success {
                print("Download completed successfully!")
                self?.initializeDatabase()
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                self?.showErrorAlert(error: error)
            }
        }
    }

    private func initializeDatabase() {
        predictionManager.initializePredictionDatabase { [weak self] success, error in
            if success {
                print("Database ready to use!")
                self?.testPredictions()
            } else {
                print("Database initialization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func testPredictions() {
        // Test next-word prediction (note the trailing space)
        predictionManager.getPrediction("how are ") { suggestions, textColor in
            print("Next-word predictions: \(suggestions)")
            // suggestions = ["you", "they", "we"]
        }

        // Test word completion (no trailing space)
        predictionManager.getPrediction("hel") { suggestions, textColor in
            print("Word completions: \(suggestions)")
            // suggestions = ["hello", "help", "held"]
        }
    }

    private func showErrorAlert(error: Error?) {
        let alert = UIAlertController(
            title: "Download Failed",
            message: error?.localizedDescription ?? "Unknown error",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.downloadDatabase()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

import UIKit
import PredictionKeyboard

final class PredictionSetupViewController: UIViewController {

    private var predictionManager: PredictionKeyboardManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true // no UI

        predictionManager = PredictionKeyboardManager(
            appGroup: "group.mega-key"
        )

        if predictionManager.isDatabaseDownloaded() {
            initializeDatabase()
        } else {
            downloadDatabase()
        }
    }

    private func downloadDatabase() {
        predictionManager.downloadDatabase(withUI: self) { [weak self] success, error in
            if success {
                self?.initializeDatabase()
            } else {
                self?.showErrorAlert(error: error)
            }
        }
    }

    private func initializeDatabase() {
        predictionManager.initializePredictionDatabase { success, error in
            if !success {
                print("Prediction DB init failed:", error?.localizedDescription ?? "unknown")
            }
        }
    }

    private func showErrorAlert(error: Error?) {
        let alert = UIAlertController(
            title: "Prediction Download Failed",
            message: error?.localizedDescription ?? "Unknown error",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.downloadDatabase()
        })
        present(alert, animated: true)
    }
}

struct PredictionSetupController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> PredictionSetupViewController {
        PredictionSetupViewController()
    }

    func updateUIViewController(
        _ uiViewController: PredictionSetupViewController,
        context: Context
    ) {}
}

#Preview {
    ContentView()
}
