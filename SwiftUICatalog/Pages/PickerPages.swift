/*
Abstract:
Pickers for values, dates, colours and photos.
*/

import PhotosUI
import SwiftUI

// MARK: - Picker

struct PickerPage: View {
    enum Flavor: String, CaseIterable, Identifiable {
        case vanilla = "Vanilla", chocolate = "Chocolate", strawberry = "Strawberry", pistachio = "Pistachio"
        var id: Self { self }
    }

    @State private var flavor = Flavor.chocolate
    @State private var color = "blue"

    var body: some View {
        Form {
            Section("Menu") {
                Picker("Flavor", selection: $flavor) { options }
                    .pickerStyle(.menu)
            }

            Section("Navigation link") {
                Picker("Flavor", selection: $flavor) { options }
                    .pickerStyle(.navigationLink)
            }

            Section {
                Picker("Flavor", selection: $flavor) { options }
                    .pickerStyle(.wheel)
            } header: {
                Text("Wheel")
            } footer: {
                APICaption(".pickerStyle(.wheel), the UIPickerView equivalent")
            }

            Section("Inline") {
                Picker("Flavor", selection: $flavor) { options }
                    .pickerStyle(.inline)
                    .labelsHidden()
            }

            Section("Palette, inside a menu") {
                Menu("Tag colour") {
                    Picker("Tag colour", selection: $color) {
                        Image(systemName: "circle.fill").tint(.red).tag("red")
                        Image(systemName: "circle.fill").tint(.green).tag("green")
                        Image(systemName: "circle.fill").tint(.blue).tag("blue")
                    }
                    .pickerStyle(.palette)
                }
            }
        }
    }

    private var options: some View {
        ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
    }
}

// MARK: - Date Picker

struct DatePickerPage: View {
    @State private var date = Date.now
    @State private var dates: Set<DateComponents> = []

    var body: some View {
        Form {
            Section("Compact") {
                DatePicker("Date and time", selection: $date)
                    .datePickerStyle(.compact)
                DatePicker("Time only", selection: $date, displayedComponents: .hourAndMinute)
            }

            Section("Graphical") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }

            Section("Wheel") {
                DatePicker("Date", selection: $date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }

            Section {
                MultiDatePicker("Dates", selection: $dates)
            } header: {
                Text("Multiple dates")
            } footer: {
                Text("\(dates.count) selected")
            }
        }
    }
}

// MARK: - Color Picker

struct ColorPickerPage: View {
    @State private var color = Color.accentColor
    @State private var opaque = Color.orange

    var body: some View {
        Form {
            Section {
                ColorPicker("Colour", selection: $color)
                ColorPicker("Without opacity", selection: $opaque, supportsOpacity: false)
            } footer: {
                APICaption("ColorPicker, the UIColorWell equivalent")
            }

            Section("Preview") {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12).fill(color)
                    RoundedRectangle(cornerRadius: 12).fill(opaque)
                }
                .frame(height: 80)
            }
        }
    }
}

// MARK: - Photos Picker

struct PhotosPickerPage: View {
    @State private var item: PhotosPickerItem?
    @State private var image: Image?

    var body: some View {
        Form {
            Section {
                PhotosPicker(selection: $item, matching: .images) {
                    Label("Choose a photo", systemImage: "photo.on.rectangle")
                }
            } footer: {
                APICaption("PhotosPicker, the UIImagePickerController equivalent. It needs no photo library permission.")
            }

            if let image {
                Section("Selected") {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
        .onChange(of: item) { _, newItem in
            Task {
                guard let data = try? await newItem?.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                image = Image(uiImage: uiImage)
            }
        }
    }
}
