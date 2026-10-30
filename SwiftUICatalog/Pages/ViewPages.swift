/*
Abstract:
Images, symbols, layout, materials, paging, web content, alerts and toolbars.
*/

import SwiftUI
import WebKit

// MARK: - Image

struct ImagePage: View {
    var body: some View {
        Form {
            Section("Scaled to fit") {
                Image(systemName: "mountain.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.teal)
            }

            Section("Clipped and filled") {
                LinearGradient(colors: [.indigo, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 140)
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
            }

            Section {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.gray)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.gray)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(.blue, lineWidth: 3))
                }
            } header: {
                Text("Shapes")
            } footer: {
                APICaption("Image, the UIImageView equivalent")
            }
        }
    }
}

// MARK: - SF Symbols

struct SymbolsPage: View {
    @State private var strength = 0.6
    @State private var bounce = 0

    var body: some View {
        Form {
            Section("Rendering modes") {
                HStack(spacing: 24) {
                    symbol("cloud.sun.rain.fill", mode: .monochrome, name: "monochrome")
                    symbol("cloud.sun.rain.fill", mode: .hierarchical, name: "hierarchical")
                    symbol("cloud.sun.rain.fill", mode: .palette, name: "palette")
                    symbol("cloud.sun.rain.fill", mode: .multicolor, name: "multicolor")
                }
                .frame(maxWidth: .infinity)
            }

            Section {
                HStack(spacing: 24) {
                    Image(systemName: "wifi", variableValue: strength)
                    Image(systemName: "speaker.wave.3.fill", variableValue: strength)
                    Image(systemName: "chart.bar.fill", variableValue: strength)
                }
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                Slider(value: $strength, in: 0...1)
            } header: {
                Text("Variable value")
            } footer: {
                APICaption("Image(systemName:variableValue:)")
            }

            Section("Effects") {
                HStack(spacing: 32) {
                    Image(systemName: "bell.fill")
                        .symbolEffect(.bounce, value: bounce)
                    Image(systemName: "heart.fill")
                        .symbolEffect(.pulse)
                        .foregroundStyle(.red)
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .symbolEffect(.rotate, value: bounce)
                }
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                Button("Play") { bounce += 1 }
            }
        }
    }

    private func symbol(_ name: String, mode: SymbolRenderingMode, name label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: name)
                .symbolRenderingMode(mode)
                .foregroundStyle(.blue, .orange, .teal)
                .font(.largeTitle)
            APICaption(".\(label)")
        }
    }
}

// MARK: - Stacks and Grids

struct StackPage: View {
    @State private var spacing = 8.0

    var body: some View {
        Form {
            Section("HStack") {
                HStack(spacing: spacing) { tiles(3) }
            }
            Section("VStack") {
                VStack(spacing: spacing) { tiles(3) }
            }
            Section("ZStack") {
                ZStack {
                    tile(.blue).frame(width: 120, height: 80)
                    tile(.orange).frame(width: 80, height: 50)
                    tile(.green).frame(width: 40, height: 25)
                }
                .frame(maxWidth: .infinity)
            }
            Section("Grid") {
                Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                    GridRow { tiles(3) }
                    GridRow {
                        tile(.purple).gridCellColumns(2)
                        tile(.mint)
                    }
                }
            }
            Section("Spacing") {
                Slider(value: $spacing, in: 0...24)
            }
        }
    }

    private let colors: [Color] = [.blue, .orange, .green]

    private func tiles(_ count: Int) -> some View {
        ForEach(0..<count, id: \.self) { tile(colors[$0 % colors.count]) }
    }

    private func tile(_ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.gradient)
            .frame(minHeight: 36)
    }
}

// MARK: - Materials

struct MaterialsPage: View {
    private let materials: [(String, Material)] = [
        ("ultraThin", .ultraThinMaterial), ("thin", .thinMaterial), ("regular", .regularMaterial),
        ("thick", .thickMaterial), ("ultraThick", .ultraThickMaterial),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(materials, id: \.0) { name, material in
                    Text(".\(name)Material")
                        .font(.headline.monospaced())
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(material, in: .rect(cornerRadius: 16))
                }
                if #available(iOS 26, *) {
                    Text(".glassEffect()")
                        .font(.headline.monospaced())
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .glassEffect(in: .rect(cornerRadius: 16))
                }
            }
            .padding()
        }
        .background {
            LinearGradient(colors: [.orange, .pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }
}

// MARK: - Paged Tab View

struct PageControlPage: View {
    @State private var page = 0
    private let colors: [Color] = [.red, .orange, .green, .blue, .purple]

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: $page) {
                ForEach(colors.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 24)
                        .fill(colors[index].gradient)
                        .overlay {
                            Text("Page \(index + 1)")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 320)

            APICaption(".tabViewStyle(.page), the UIPageControl equivalent")
        }
        .padding(.vertical)
    }
}

// MARK: - Web View

struct WebViewPage: View {
    var body: some View {
        if #available(iOS 26, *) {
            WebView(url: URL(string: "https://developer.apple.com/documentation/swiftui/gauge"))
        } else {
            ContentUnavailableView("Needs iOS 26", systemImage: "safari", description: Text("SwiftUI's WebView arrived in iOS 26. Earlier versions wrap WKWebView."))
        }
    }
}

// MARK: - Alerts and Dialogs

struct AlertsPage: View {
    @State private var showsAlert = false
    @State private var showsDestructive = false
    @State private var showsTextAlert = false
    @State private var showsDialog = false
    @State private var showsSheet = false
    @State private var name = ""
    @State private var result = "None"

    var body: some View {
        Form {
            Section("Alerts") {
                Button("Simple alert") { showsAlert = true }
                Button("Destructive alert") { showsDestructive = true }
                Button("Alert with a text field") { showsTextAlert = true }
            }
            Section("Others") {
                Button("Confirmation dialog") { showsDialog = true }
                Button("Sheet") { showsSheet = true }
            }
            Section {
                LabeledContent("Result", value: result)
            } footer: {
                APICaption(".alert and .confirmationDialog, the UIAlertController equivalents")
            }
        }
        .alert("Saved", isPresented: $showsAlert) {
            Button("OK", role: .cancel) { result = "OK" }
        } message: {
            Text("Your changes were saved.")
        }
        .alert("Delete this item?", isPresented: $showsDestructive) {
            Button("Delete", role: .destructive) { result = "Deleted" }
            Button("Cancel", role: .cancel) { result = "Cancelled" }
        } message: {
            Text("This can't be undone.")
        }
        .alert("Rename", isPresented: $showsTextAlert) {
            TextField("Name", text: $name)
            Button("Save") { result = "Renamed to \(name)" }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Share this page", isPresented: $showsDialog, titleVisibility: .visible) {
            Button("Copy Link") { result = "Copied" }
            Button("Message") { result = "Message" }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showsSheet) {
            NavigationStack {
                Text("A sheet with detents")
                    .navigationTitle("Sheet")
                    .toolbar {
                        Button("Done") { showsSheet = false }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

// MARK: - Toolbar

struct ToolbarPage: View {
    @State private var lastTapped = "None"

    var body: some View {
        Form {
            Section {
                LabeledContent("Last tapped", value: lastTapped)
            } footer: {
                APICaption(".toolbar with ToolbarItem placements, the UIToolbar equivalent")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Share", systemImage: "square.and.arrow.up") { lastTapped = "Share" }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Back", systemImage: "chevron.backward") { lastTapped = "Back" }
                Spacer()
                Button("Bookmark", systemImage: "book") { lastTapped = "Bookmark" }
                Spacer()
                Button("Tabs", systemImage: "square.on.square") { lastTapped = "Tabs" }
            }
        }
    }
}
