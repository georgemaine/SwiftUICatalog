/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A simple outline view for the sample app's main UI.
Adapted from UIKit Catalog: each item opens a SwiftUI page, hosted in a UIHostingController,
instead of a storyboard.
*/

import SwiftUI
import UIKit

class OutlineViewController: UIViewController {

    enum Section {
        case main
    }

    class OutlineItem: Identifiable, Hashable {
        let title: String
        let subitems: [OutlineItem]
        let page: CatalogPage?
        let imageName: String?

        init(title: String, imageName: String?, page: CatalogPage? = nil, subitems: [OutlineItem] = []) {
            self.title = title
            self.subitems = subitems
            self.page = page
            self.imageName = imageName
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.id == rhs.id
        }

    }

    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    var outlineCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        
        // Add a translucent background to the primary view controller for the Mac.
        splitViewController!.primaryBackgroundStyle = .sidebar
        view.backgroundColor = UIColor.clear
          
        // Listen for when the split view controller is expanded or collapsed for iPad multi-tasking,
        // and on device rotate (iPhones that support regular size class).
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDetailTargetChangeObserved),
                                               name: UIViewController.showDetailTargetDidChangeNotification,
                                               object: nil)
        
        if navigationController!.traitCollection.userInterfaceIdiom == .mac {
            navigationController!.navigationBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Launch with `-OpenPage gauges` to open a page directly, for screenshots and quick checks.
        if let name = UserDefaults.standard.string(forKey: "OpenPage"), let page = CatalogPage(rawValue: name),
           let item = allItems(menuItems).first(where: { $0.page == page }) {
            UserDefaults.standard.removeObject(forKey: "OpenPage")
            pushOrPresentPage(page, title: item.title)
        }
    }

    private func allItems(_ items: [OutlineItem]) -> [OutlineItem] {
        items.flatMap { [$0] + allItems($0.subitems) }
    }

    // Re-load the data source, the disclosure indicators need to change (push vs. present on a cell).
    @objc
    private func showDetailTargetChangeObserved() {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(menuItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    lazy var controlsOutlineItem: OutlineItem = {
        
        // Determine the content of the UIButton grouping.
        var buttonItems = [
            OutlineItem(title: NSLocalizedString("ButtonsTitle", comment: ""), imageName: "rectangle",
                        page: .buttons),
            OutlineItem(title: NSLocalizedString("MenuButtonsTitle", comment: ""), imageName: "list.bullet.rectangle",
                        page: .menuButtons)
        ]
        // UIPointerInteraction to UIButtons is applied for iPad.
        if navigationController!.traitCollection.userInterfaceIdiom == .pad {
            buttonItems.append(contentsOf:
                [OutlineItem(title: NSLocalizedString("PointerInteractionButtonsTitle", comment: ""),
                             imageName: "cursorarrow.rays",
                             page: .pointerInteraction) ])
        }
    
        var controlsSubItems = [
            OutlineItem(title: NSLocalizedString("ButtonsTitle", comment: ""), imageName: "rectangle.on.rectangle", subitems: buttonItems),
            
            OutlineItem(title: NSLocalizedString("PageControlTitle", comment: ""), imageName: "photo.on.rectangle",
                        page: .pageControl),
            
            OutlineItem(title: NSLocalizedString("SearchBarsTitle", comment: ""), imageName: "magnifyingglass",
                        page: .searchBar),
            
            OutlineItem(title: NSLocalizedString("SegmentedControlsTitle", comment: ""), imageName: "square.split.3x1",
                        page: .segmentedControl),
            OutlineItem(title: NSLocalizedString("SlidersTitle", comment: ""), imageName: nil,
                        page: .sliders),
            OutlineItem(title: NSLocalizedString("SwitchesTitle", comment: ""), imageName: nil,
                        page: .switches),
            OutlineItem(title: NSLocalizedString("TextFieldsTitle", comment: ""), imageName: nil,
                        page: .textFields)
        ]
        
        if traitCollection.userInterfaceIdiom != .mac {
            // UIStepper class is not supported when running Mac Catalyst apps in the Mac idiom.
            let stepperItem =
                OutlineItem(title: NSLocalizedString("SteppersTitle", comment: ""), imageName: nil, page: .steppers)
            controlsSubItems.append(stepperItem)
        }
        
        return OutlineItem(title: "Controls", imageName: "slider.horizontal.3", subitems: controlsSubItems)
    }()
    
    lazy var pickersOutlineItem: OutlineItem = {
        var pickerSubItems = [
            OutlineItem(title: NSLocalizedString("DatePickerTitle", comment: ""), imageName: nil,
                        page: .datePicker),
            OutlineItem(title: NSLocalizedString("ColorPickerTitle", comment: ""), imageName: nil,
                        page: .colorPicker),
            OutlineItem(title: NSLocalizedString("FontPickerTitle", comment: ""), imageName: nil,
                        page: .fontPicker),
            OutlineItem(title: NSLocalizedString("ImagePickerTitle", comment: ""), imageName: nil,
                        page: .imagePicker)
        ]
        
        if traitCollection.userInterfaceIdiom != .mac {
            // UIPickerView class is not supported when running Mac Catalyst apps in the Mac idiom.
            // To use a picker in macOS, use UIButton with changesSelectionAsPrimaryAction set to "true".
            let pickerViewItem =
                OutlineItem(title: NSLocalizedString("PickerViewTitle", comment: ""), imageName: nil, page: .pickerView)
            pickerSubItems.append(pickerViewItem)
        }
        
        return OutlineItem(title: "Pickers", imageName: "list.bullet", subitems: pickerSubItems)
    }()
    
    lazy var viewsOutlineItem: OutlineItem = {
        OutlineItem(title: "Views", imageName: "rectangle.stack.person.crop", subitems: [
            OutlineItem(title: NSLocalizedString("GaugesTitle", comment: ""), imageName: "gauge.with.dots.needle.67percent",
                        page: .gauges),
            OutlineItem(title: NSLocalizedString("ActivityIndicatorsTitle", comment: ""), imageName: nil,
                        page: .activityIndicators),
            OutlineItem(title: NSLocalizedString("AlertControllersTitle", comment: ""), imageName: nil,
                        page: .alertControllers),
            OutlineItem(title: NSLocalizedString("TextViewTitle", comment: ""), imageName: nil,
                        page: .textView),
            
            OutlineItem(title: NSLocalizedString("ImagesTitle", comment: ""), imageName: "photo", subitems: [
                OutlineItem(title: NSLocalizedString("ImageViewTitle", comment: ""), imageName: nil,
                            page: .imageView),
                OutlineItem(title: NSLocalizedString("SymbolsTitle", comment: ""), imageName: nil,
                            page: .symbols)
            ]),
            
            OutlineItem(title: NSLocalizedString("ProgressViewsTitle", comment: ""), imageName: nil,
                        page: .progressViews),
            OutlineItem(title: NSLocalizedString("StackViewsTitle", comment: ""), imageName: nil,
                        page: .stackViews),
            
            OutlineItem(title: NSLocalizedString("ToolbarsTitle", comment: ""), imageName: "hammer",
                        page: .toolbars),
            
            OutlineItem(title: NSLocalizedString("VisualEffectTitle", comment: ""), imageName: nil, page: .visualEffect),
            
            OutlineItem(title: NSLocalizedString("WebViewTitle", comment: ""), imageName: nil, page: .webView)
        ])
    }()
    
    private lazy var menuItems: [OutlineItem] = {
        return [
            controlsOutlineItem,
            viewsOutlineItem,
            pickersOutlineItem
        ]
    }()

}

// MARK: - UICollectionViewDiffableDataSource

extension OutlineViewController {

    private func configureCollectionView() {
        let collectionView =
            UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.outlineCollectionView = collectionView
        collectionView.delegate = self
    }

    private func configureDataSource() {

        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in

            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
           
            if let image = menuItem.imageName {
                contentConfiguration.image = UIImage(systemName: image)
            }
            
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            
            let background = UIBackgroundConfiguration.clear()
            cell.backgroundConfiguration = background
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            
            if let image = menuItem.imageName {
                contentConfiguration.image = UIImage(systemName: image)
            }
            
            cell.contentConfiguration = contentConfiguration
            
            let background = UIBackgroundConfiguration.clear()
            cell.backgroundConfiguration = background
            
            cell.accessories = self.splitViewWantsToShowDetail() ? [] : [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
            // Return the cell.
            if item.subitems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        }

        // Load our initial data.
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }

    private func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }

    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()

        func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.subitems.isEmpty {
                addItems(menuItem.subitems, to: menuItem)
            }
        }
        
        addItems(menuItems, to: nil)
        return snapshot
    }

}

// MARK: - UICollectionViewDelegate

extension OutlineViewController: UICollectionViewDelegate {
    
    private func splitViewWantsToShowDetail() -> Bool {
        return splitViewController?.traitCollection.horizontalSizeClass == .regular
    }
    
    private func pushOrPresentViewController(viewController: UIViewController) {
        if splitViewWantsToShowDetail() {
            let navVC = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(navVC, sender: navVC) // Replace the detail view controller.
            
            if navigationController!.traitCollection.userInterfaceIdiom == .mac {
                navVC.navigationBar.isHidden = true
            }
        } else {
            navigationController?.pushViewController(viewController, animated: true) // Just push instead of replace.
        }
    }
    
    private func pushOrPresentPage(_ page: CatalogPage, title: String) {
        let hostingController = UIHostingController(rootView: page.view)
        hostingController.title = title
        pushOrPresentViewController(viewController: hostingController)
        // SwiftUI's bottom-bar toolbar items only show when the hosting navigation controller's toolbar does.
        hostingController.navigationController?.setToolbarHidden(page != .toolbars, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    
        if let page = menuItem.page {
            pushOrPresentPage(page, title: menuItem.title)
            
            if navigationController!.traitCollection.userInterfaceIdiom == .mac {
                if let windowScene = view.window?.windowScene {
                    if #available(iOS 15, *) {
                        windowScene.subtitle = menuItem.title
                    }
                }
            }
        }
    }
    
}
