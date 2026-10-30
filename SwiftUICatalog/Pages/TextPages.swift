/*
Abstract:
Text input, search, and fonts.
*/

import SwiftUI

// MARK: - Text Field

struct TextFieldPage: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var notes = ""
    @State private var amount = 12.5

    var body: some View {
        Form {
            Section("Plain") {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .submitLabel(.next)
                TextField("Email", text: $email, prompt: Text("you@example.com"))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
            }

            Section("Rounded border") {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            Section("Grows with its text") {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
            }

            Section {
                TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                    .keyboardType(.decimalPad)
            } header: {
                Text("Formatted value")
            } footer: {
                APICaption("TextField(_:value:format:)")
            }
        }
    }
}

// MARK: - Text Editor

struct TextEditorPage: View {
    @State private var text = "TextEditor is the SwiftUI equivalent of UITextView. It scrolls, wraps and grows with its content."

    var body: some View {
        Form {
            Section {
                TextEditor(text: $text)
                    .frame(minHeight: 200)
            } footer: {
                Text("\(text.count) characters")
            }
        }
    }
}

// MARK: - Searchable

struct SearchPage: View {
    @State private var query = ""

    private let fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cherry", "Fig", "Grape", "Kiwi", "Lemon", "Mango", "Orange", "Peach", "Pear", "Plum", "Raspberry", "Strawberry"]

    private var results: [String] {
        query.isEmpty ? fruits : fruits.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        List(results, id: \.self) { fruit in
            Text(fruit)
        }
        .overlay {
            if results.isEmpty {
                ContentUnavailableView.search(text: query)
            }
        }
        .searchable(text: $query, prompt: "Search fruit")
        .searchSuggestions {
            if query.isEmpty {
                Text("Berries").searchCompletion("berry")
                Text("Stone fruit").searchCompletion("P")
            }
        }
    }
}

// MARK: - Fonts

struct FontsPage: View {
    private let styles: [(String, Font)] = [
        ("largeTitle", .largeTitle), ("title", .title), ("title2", .title2), ("title3", .title3),
        ("headline", .headline), ("body", .body), ("callout", .callout), ("subheadline", .subheadline),
        ("footnote", .footnote), ("caption", .caption), ("caption2", .caption2),
    ]

    private let designs: [(String, Font.Design)] = [
        ("default", .default), ("rounded", .rounded), ("serif", .serif), ("monospaced", .monospaced),
    ]

    var body: some View {
        Form {
            Section {
                ForEach(styles, id: \.0) { name, font in
                    LabeledContent {
                        APICaption(".\(name)")
                    } label: {
                        Text("Catalog").font(font)
                    }
                }
            } header: {
                Text("Text styles")
            } footer: {
                Text("SwiftUI has no font picker. UIFontPickerViewController can still be wrapped, but text styles scale with Dynamic Type, which a fixed font doesn't.")
            }

            Section("Designs") {
                ForEach(designs, id: \.0) { name, design in
                    LabeledContent {
                        APICaption(".\(name)")
                    } label: {
                        Text("1234 Catalog").font(.system(.title3, design: design))
                    }
                }
            }

            Section("Number styles") {
                LabeledContent {
                    APICaption("default")
                } label: {
                    Text("1111.11")
                }
                LabeledContent {
                    APICaption(".monospacedDigit()")
                } label: {
                    Text("1111.11").monospacedDigit()
                }
            }
        }
    }
}
