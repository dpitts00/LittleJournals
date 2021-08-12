//
//  GridViewController.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/15/21.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Page>! = nil
    var collectionView: UICollectionView! = nil
    
    var entries: [Entry] = []
    var years: [Int] = []
    var sortedPages: [Page] = []
    var appearance = ""
    
    static let sectionHeaderElementKind = "section-header"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entries.sort(by: { $0.date < $1.date })
        
        for entry in entries {
            if !years.contains(entry.date.year()) {
                years.append(entry.date.year())
            }
            for page in entry.pages {
                sortedPages.append(page)
            }
        }
        years.sort()
        
        // print to verify contents of entries and population of pages
        print("number of years: \(years.count)")
        print("number of entries: \(entries.count)")
        print("number of pages: \(sortedPages.count)")
        
        // FUTURE: need to include cover page and maybe years as section dividers?
        appearance = "grid"
        configureHierarchy()
        configureDataSource()
        
        let listViewIcon = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(displayList))
        let gridButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(displayGrid))
        let pageButton = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(displayPage))
        let bookButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportBook))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [listViewIcon, spacer, gridButton, spacer, pageButton, spacer, bookButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: Navigation buttons
    
    @objc func displayList() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func displayGrid() {
        print("displayGrid()")
        if appearance == "grid" {
            return
        } else {
            appearance = "grid"
            configureHierarchy()
            configureDataSource()
        }
    }
    
    @objc func displayPage() {
        print("displayPage()")
        if appearance == "page" {
            return
        } else {
            appearance = "page"
            configureHierarchy()
            configureDataSource()
        }
    }
    
    @objc func exportBook() {
        print("exportBook()")
        // let's make it page view first
        if appearance != "page" {
            appearance = "page"
            configureHierarchy()
            configureDataSource()
        }
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 600, height: 600))
        let pdf = renderer.pdfData {
            (context) in
            let attributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 14),
            ]
            for page in sortedPages {
                context.beginPage()
                if page.pageType == "text" {
                    if let text = page.text {
                        text.draw(in: CGRect(x: 20, y: 20, width: 560, height: 560), withAttributes: attributes)
                    }
                } else if page.pageType == "image" {
                    if let image = page.image {
                        let imageURL = self.getDocumentsDirectory().appendingPathComponent(image)
                        if let data = try? Data(contentsOf: imageURL) {
                            if let image = UIImage(data: data) {
                                image.draw(in: CGRect(x: 0, y: 0, width: 600, height: 600))
                            }
                        }
                    }
                }
                
            }
        }
        // saves the PDF
        if let title = title {
            let url = getDocumentsDirectory().appendingPathComponent(title).appendingPathExtension("pdf")
            try? pdf.write(to: url, options: .noFileProtection)
        // shares the PDF
            let shareController = UIActivityViewController(activityItems: [title, url], applicationActivities: [])
            present(shareController, animated: true)
        }
    }
    
    // MARK: createGridLayout()
    
    func createGridLayout() -> UICollectionViewLayout {
        
        if appearance == "grid" {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            var groupCount: Int {
                if view.frame.width < 400 {
                    return 2
                } else {
                    return 4
                }
            }
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 1 // between "rows"
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        } else {
            // if appearance == "page"
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            var groupCount: Int {
                if view.frame.width < 400 {
                    return 1
                } else {
                    return 2
                }
            }
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 1 // between "rows"
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            section.orthogonalScrollingBehavior = .groupPaging
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
    }
    
    func configureHierarchy() {
        let layout = createGridLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let textCellRegistration = UICollectionView.CellRegistration<PageTextCell, Page> { (cell, indexPath, page) in
            // cell = PageTextCell, page = Page
            cell.backgroundColor = .systemBackground
            cell.label.text = page.text
            if self.appearance == "grid" {
                cell.label.font = .systemFont(ofSize: 6)
            } else {
                cell.label.font = .systemFont(ofSize: 12)
            }
            cell.layer.cornerRadius = 12
        }
        
        let imageCellRegistration = UICollectionView.CellRegistration<PageImageCell, Page> { (cell, indexPath, page) in
            // cell = PageImageCell, page = Page
            cell.backgroundColor = .systemBackground
            if let image = page.image {
                let imageURL = self.getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: data) {
                        cell.imageView.image = image
                        // put the aspect ratio back
//                        imageAspectRatio = image.size.height / image.size.width
                    }
                }
            }
            
            cell.layer.cornerRadius = 12
        }
        
        // HERE!***
        // MARK: galleryCellRegistration
        
        let galleryCellRegistration = UICollectionView.CellRegistration<PageGalleryCell, Page> { (cell, indexPath, page) in
            // cell = PageGalleryCell, page = page
            cell.backgroundColor = .systemBackground
            if !page.gallery.isEmpty {
                for (index, image) in page.gallery.enumerated() {
                    let imageURL = self.getDocumentsDirectory().appendingPathComponent(image)
                    if let data = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: data) {
                            let imageViews = [cell.imageTL, cell.imageTT, cell.imageBL, cell.imageBT]
                            imageViews[index].image = image
                        }
                    }
                }
            }
            
            cell.layer.cornerRadius = 12
        }
        
        // MARK: - Data source
        
        dataSource = UICollectionViewDiffableDataSource<Int, Page>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, page: Page) -> UICollectionViewCell? in
            if page.pageType == "image" {
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: page)
            } else if page.pageType == "gallery" {
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: page)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: page)
            }
        }
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Page>()
        snapshot.appendSections([0])
        snapshot.appendItems(sortedPages)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        
    }


}
