/*
Abstract:
Progress views and the basic controls: buttons, toggles, sliders, steppers, segmented pickers,
menus and pointer hover effects.
*/

import SwiftUI

// MARK: - Activity Indicators

struct ActivityIndicatorPage: View {
    var body: some View {
        Form {
            Section {
                ProgressView()
                ProgressView("Loading")
                ProgressView().controlSize(.large)
                ProgressView().tint(.purple)
            } footer: {
                APICaption("ProgressView() with no value, the UIActivityIndicatorView equivalent")
            }
        }
    }
}

// MARK: - Progress View

struct ProgressPage: View {
    @State private var progress = 0.0
    @State private var isRunning = false

    var body: some View {
        Form {
            Section {
                ProgressView(value: progress)
                ProgressView(value: progress) {
                    Text("Downloading")
                } currentValueLabel: {
                    Text(progress, format: .percent.precision(.fractionLength(0)))
                }
                ProgressView(value: progress)
                    .tint(.orange)
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                Button(isRunning ? "Running…" : "Start") {
                    progress = 0
                    isRunning = true
                }
                .disabled(isRunning)
            } header: {
                Text("Determinate")
            } footer: {
                APICaption("ProgressView(value:), the UIProgressView equivalent")
            }
        }
        .task(id: isRunning) {
            guard isRunning else { return }
            while progress < 1 {
                try? await Task.sleep(for: .milliseconds(40))
                progress = min(1, progress + 0.01)
            }
            isRunning = false
        }
    }
}

// MARK: - Button

struct ButtonPage: View {
    @State private var taps = 0

    var body: some View {
        Form {
            Section("Styles") {
                Button("Automatic") { taps += 1 }
                Button("Bordered") { taps += 1 }.buttonStyle(.bordered)
                Button("Bordered Prominent") { taps += 1 }.buttonStyle(.borderedProminent)
                Button("Borderless") { taps += 1 }.buttonStyle(.borderless)
                Button("Plain") { taps += 1 }.buttonStyle(.plain)
                if #available(iOS 26, *) {
                    Button("Glass") { taps += 1 }.buttonStyle(.glass)
                    Button("Glass Prominent") { taps += 1 }.buttonStyle(.glassProminent)
                }
            }

            Section("Roles") {
                Button("Destructive", role: .destructive) { taps += 1 }
                Button("Cancel", role: .cancel) { taps += 1 }
            }

            Section("Sizes") {
                ForEach(Array(sizes.enumerated()), id: \.offset) { _, size in
                    Button("Control size") { taps += 1 }
                        .buttonStyle(.borderedProminent)
                        .controlSize(size)
                }
            }

            Section("Labels and shapes") {
                Button { taps += 1 } label: {
                    Label("Add Item", systemImage: "plus")
                }
                Button { taps += 1 } label: {
                    Image(systemName: "heart.fill")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                Button("Capsule") { taps += 1 }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                Button("Disabled") {}
                    .disabled(true)
            }

            Section {
                Text("Tapped \(taps) times")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private let sizes: [ControlSize] = [.mini, .small, .regular, .large, .extraLarge]
}

// MARK: - Toggle

struct TogglePage: View {
    @State private var isOn = true
    @State private var isBold = false

    var body: some View {
        Form {
            Section {
                Toggle("Default", isOn: $isOn)
                Toggle("Tinted", isOn: $isOn).tint(.purple)
                Toggle(isOn: $isOn) {
                    Label("With a symbol", systemImage: "airplane")
                }
                Toggle("Disabled", isOn: .constant(true)).disabled(true)
            } footer: {
                APICaption(".toggleStyle(.switch), the UISwitch equivalent")
            }

            Section("Button style") {
                Toggle(isOn: $isBold) {
                    Image(systemName: "bold")
                }
                .toggleStyle(.button)
            }
        }
    }
}

// MARK: - Slider

struct SliderPage: View {
    @State private var value = 42.0
    @State private var stepped = 3.0

    var body: some View {
        Form {
            Section {
                Slider(value: $value, in: 0...100)
                Slider(value: $value, in: 0...100) {
                    Text("Volume")
                } minimumValueLabel: {
                    Image(systemName: "speaker.fill")
                } maximumValueLabel: {
                    Image(systemName: "speaker.wave.3.fill")
                }
                Slider(value: $value, in: 0...100).tint(.green)
                Text(value, format: .number.precision(.fractionLength(0)))
                    .monospacedDigit()
            } header: {
                Text("Continuous")
            }

            Section {
                Slider(value: $stepped, in: 0...5, step: 1)
                Text("Step \(Int(stepped))")
            } header: {
                Text("Stepped")
            }
        }
    }
}

// MARK: - Stepper

struct StepperPage: View {
    @State private var count = 3
    @State private var custom = 0

    var body: some View {
        Form {
            Stepper("Value: \(count)", value: $count, in: 0...10)
            Stepper("By 5: \(count)", value: $count, in: 0...100, step: 5)
            Stepper("Custom: \(custom)") {
                custom += 1
            } onDecrement: {
                custom -= 1
            }
        }
    }
}

// MARK: - Segmented Picker

struct SegmentedPage: View {
    enum Mode: String, CaseIterable, Identifiable {
        case day = "Day", week = "Week", month = "Month"
        var id: Self { self }
    }

    @State private var mode = Mode.week
    @State private var alignment = "left"

    var body: some View {
        Form {
            Section {
                Picker("Range", selection: $mode) {
                    ForEach(Mode.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
            } footer: {
                APICaption(".pickerStyle(.segmented), the UISegmentedControl equivalent")
            }

            Section("Symbols") {
                Picker("Alignment", selection: $alignment) {
                    Image(systemName: "text.alignleft").tag("left")
                    Image(systemName: "text.aligncenter").tag("center")
                    Image(systemName: "text.alignright").tag("right")
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// MARK: - Menu

struct MenuPage: View {
    @State private var sort = "Name"
    @State private var lastAction = "None"

    var body: some View {
        Form {
            Section {
                Menu("Options") {
                    Button("Duplicate", systemImage: "plus.square.on.square") { lastAction = "Duplicate" }
                    Button("Rename", systemImage: "pencil") { lastAction = "Rename" }
                    Divider()
                    Menu("Sort By") {
                        Picker("Sort By", selection: $sort) {
                            Text("Name").tag("Name")
                            Text("Date").tag("Date")
                            Text("Size").tag("Size")
                        }
                    }
                    Divider()
                    Button("Delete", systemImage: "trash", role: .destructive) { lastAction = "Delete" }
                }

                Menu {
                    Button("Save as Draft") { lastAction = "Save as Draft" }
                    Button("Save as Template") { lastAction = "Save as Template" }
                } label: {
                    Text("Save")
                } primaryAction: {
                    lastAction = "Save"
                }
            } footer: {
                APICaption("Menu, the UIButton with UIMenu equivalent. The second has a primaryAction.")
            }

            Section {
                LabeledContent("Last action", value: lastAction)
                LabeledContent("Sort", value: sort)
            }
        }
    }
}

// MARK: - Hover Effects

struct HoverPage: View {
    var body: some View {
        Form {
            Section {
                Button("Automatic") {}.hoverEffect(.automatic)
                Button("Highlight") {}.hoverEffect(.highlight)
                Button("Lift") {}
                    .buttonStyle(.borderedProminent)
                    .hoverEffect(.lift)
            } footer: {
                Text("Hover effects show with a pointer on iPad and Mac, and with gaze on visionOS. They replace UIKit's UIPointerStyle.")
            }
        }
    }
}

#Preview("Progress") { NavigationStack { ProgressPage() } }
#Preview("Button") { NavigationStack { ButtonPage() } }
