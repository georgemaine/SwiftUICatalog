/*
Abstract:
The SwiftUI page behind each outline item. The outline is UIKit Catalog's own; each item that
used to load a storyboard now names one of these pages, which the outline hosts in a
UIHostingController.
*/

import SwiftUI

enum CatalogPage: String, CaseIterable {
    case buttons, menuButtons, pointerInteraction, pageControl, searchBar, segmentedControl
    case sliders, switches, textFields, steppers
    case gauges, activityIndicators, alertControllers, textView, imageView, symbols
    case progressViews, stackViews, toolbars, visualEffect, webView
    case datePicker, colorPicker, fontPicker, imagePicker, pickerView

    @ViewBuilder
    var view: some View {
        switch self {
        case .buttons: ButtonPage()
        case .menuButtons: MenuPage()
        case .pointerInteraction: HoverPage()
        case .pageControl: PageControlPage()
        case .searchBar: SearchPage()
        case .segmentedControl: SegmentedPage()
        case .sliders: SliderPage()
        case .switches: TogglePage()
        case .textFields: TextFieldPage()
        case .steppers: StepperPage()
        case .gauges: GaugePage()
        case .activityIndicators: ActivityIndicatorPage()
        case .alertControllers: AlertsPage()
        case .textView: TextEditorPage()
        case .imageView: ImagePage()
        case .symbols: SymbolsPage()
        case .progressViews: ProgressPage()
        case .stackViews: StackPage()
        case .toolbars: ToolbarPage()
        case .visualEffect: MaterialsPage()
        case .webView: WebViewPage()
        case .datePicker: DatePickerPage()
        case .colorPicker: ColorPickerPage()
        case .fontPicker: FontsPage()
        case .imagePicker: PhotosPickerPage()
        case .pickerView: PickerPage()
        }
    }
}

/// A caption that names the API shown above it, in code style.
struct APICaption: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption.monospaced())
            .foregroundStyle(.secondary)
    }
}
