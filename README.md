# SwiftUI Catalog

Apple's [UIKit Catalog](https://developer.apple.com/documentation/uikit/uikit-catalog-creating-and-customizing-views-and-controls) shell, filled with SwiftUI instead of UIKit.

The sidebar, split view, storyboards and Mac Catalyst setup are UIKit Catalog's own, copied from `georgemaine/UIKitCatalog`. Each outline item that used to load a storyboard now opens a SwiftUI page, hosted in a `UIHostingController`. So the two apps can be run side by side, control by control.

## What's different from UIKit Catalog

- **Gauges** is new, at the top of Views. UIKit has no gauge; SwiftUI's `Gauge` shows every style side by side: the open ring with a marker (`.accessoryCircular`), the filled closed ring (`.accessoryCircularCapacity`), and the linear styles.
- UIKit Catalog's default and custom variants (page controls, search bars, toolbars) are one page each, because SwiftUI has one API for each.
- Font Picker shows text styles and font designs: SwiftUI has no font picker.

| Outline item | SwiftUI |
| -- | -- |
| Buttons, Menu Buttons, Pointer Interaction | `Button` and `buttonStyle`, `Menu`, `hoverEffect` |
| Page Controls | `TabView` with `.tabViewStyle(.page)` |
| Search Bars | `searchable` |
| Segmented Controls, Sliders, Switches, Steppers | `Picker(.segmented)`, `Slider`, `Toggle`, `Stepper` |
| Text Fields, Text View | `TextField`, `SecureField`, `TextEditor` |
| Gauges | `Gauge` and every `GaugeStyle` |
| Activity Indicators, Progress Views | `ProgressView` without and with a value |
| Alert Controllers | `alert`, `confirmationDialog`, `sheet` |
| Image View, SF Symbol | `Image`, rendering modes, variable values, `symbolEffect` |
| Stack Views | `HStack`, `VStack`, `ZStack`, `Grid` |
| Toolbars | `toolbar` with `ToolbarItem` placements |
| Visual Effect | `Material`, and `glassEffect` on iOS 26 |
| Web View | SwiftUI `WebView` on iOS 26 |
| Date, Color, Image and Picker View pickers | `DatePicker`, `MultiDatePicker`, `ColorPicker`, `PhotosPicker`, `Picker` styles |

## Run

Open `SwiftUICatalog.xcodeproj` in Xcode 27 and run on an iPhone or iPad simulator, or on My Mac (Mac Catalyst). It targets iOS 18; a few pages use iOS 26 APIs behind availability checks.

To open a page directly, launch with `-OpenPage <page>`, where `<page>` is a `CatalogPage` case:

```sh
xcrun simctl launch booted com.georgemaine.SwiftUICatalog -OpenPage gauges
```

## License

The shell is Apple sample code; see `LICENSE.txt`.
