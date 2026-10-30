/*
Abstract:
Every built-in gauge style side by side, driven by one value. UIKit has no gauge, which is why
this catalog exists. Apple's docs describe the two circular styles as an "open ring with a
marker" (a value's position on a scale) and a "closed ring that's partially filled" (capacity).
*/

import SwiftUI

struct GaugePage: View {
    @State private var value = 0.71

    private let range = 0.0...1.0
    private let scoreGradient = Gradient(colors: [.red, .orange, .yellow, .green])

    var body: some View {
        Form {
            Section {
                Slider(value: $value, in: range) {
                    Text("Value")
                }
            } header: {
                Text("Value")
            } footer: {
                Text(value, format: .percent.precision(.fractionLength(0)))
            }

            Section {
                HStack(alignment: .top) {
                    cell(".accessoryCircular", note: "Open ring, marker") {
                        labeledGauge.gaugeStyle(.accessoryCircular)
                    }
                    cell(".accessoryCircularCapacity", note: "Closed ring, filled") {
                        labeledGauge.gaugeStyle(.accessoryCircularCapacity)
                    }
                }
            } header: {
                Text("Circular")
            } footer: {
                Text("The open ring shows where a value sits on a scale. The closed ring shows how full something is.")
            }

            Section("Circular, tinted with a gradient") {
                HStack(alignment: .top) {
                    cell(".accessoryCircular", note: "tint(Gradient)") {
                        labeledGauge
                            .gaugeStyle(.accessoryCircular)
                            .tint(scoreGradient)
                    }
                    cell(".accessoryCircularCapacity", note: "tint(Gradient)") {
                        labeledGauge
                            .gaugeStyle(.accessoryCircularCapacity)
                            .tint(scoreGradient)
                    }
                }
            }

            Section("Linear") {
                VStack(alignment: .leading, spacing: 20) {
                    linearRow(".automatic") { labeledGauge.gaugeStyle(.automatic) }
                    linearRow(".linearCapacity") { labeledGauge.gaugeStyle(.linearCapacity) }
                    linearRow(".accessoryLinear") { labeledGauge.gaugeStyle(.accessoryLinear) }
                    linearRow(".accessoryLinearCapacity") { labeledGauge.gaugeStyle(.accessoryLinearCapacity) }
                    linearRow(".accessoryLinear, tint(Gradient)") {
                        labeledGauge
                            .gaugeStyle(.accessoryLinear)
                            .tint(scoreGradient)
                    }
                }
                .padding(.vertical, 8)
            }

            Section {
                HStack(alignment: .top) {
                    cell("Label only", note: "no current value") {
                        Gauge(value: value, in: range) {
                            Image(systemName: "shield.lefthalf.filled")
                        }
                        .gaugeStyle(.accessoryCircular)
                    }
                    cell("Symbol value", note: "currentValueLabel") {
                        Gauge(value: value, in: range) {
                            Text("Battery")
                        } currentValueLabel: {
                            Image(systemName: "bolt.fill")
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(.green)
                    }
                }
            } header: {
                Text("Labels")
            } footer: {
                Text("Gauge(value:in:label:currentValueLabel:minimumValueLabel:maximumValueLabel:). The circular styles put the minimum and maximum labels in the ring's opening.")
            }
        }
    }

    private var labeledGauge: some View {
        Gauge(value: value, in: range) {
            Text("Score")
        } currentValueLabel: {
            Text(Int((value * 100).rounded()), format: .number)
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text("100")
        }
    }

    private func cell<Content: View>(_ name: String, note: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 10) {
            content()
            VStack(spacing: 2) {
                APICaption(name)
                Text(note)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func linearRow<Content: View>(_ name: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            content()
            APICaption(name)
        }
    }
}

#Preview {
    NavigationStack { GaugePage() }
}
