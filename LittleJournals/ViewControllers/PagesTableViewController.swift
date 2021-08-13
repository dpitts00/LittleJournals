//
//  PagesTableViewController.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/8/21.
//

import UIKit

protocol PagesTableViewControllerDelegate {
    func saveEntry(savedEntry: Entry)
}

class PagesTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)

    var entry: Entry?
    var delegate: PagesTableViewControllerDelegate!
    var textViewIndex: IndexPath?
    var imageAspectRatio: CGFloat = 1
    var entryIndex: IndexPath?
    
    var doneToolbar: UIToolbar!
    var isDateEditing: Bool = false
    var isGallery: Bool = false
    var galleryCellIndex: IndexPath?
    var galleryGridCell: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entry {
            let titleText = entry.title
            let subtitleText = entry.date.monthDay()
            let titleAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor: bgColor,
                .font: UIFont(name: "Avenir Next", size: 18)! // ! Fix
            ]
            let subtitleAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor: bgColor,
                .font: UIFont(name: "Avenir Next", size: 14)! // ! Fix
            ]
            let title = NSMutableAttributedString(string: titleText, attributes: titleAttributes)
            let subtitle = NSMutableAttributedString(string: subtitleText, attributes: subtitleAttributes)
            title.append(NSAttributedString(string: "\n"))
            title.append(subtitle)
            
            let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44))
            titleLabel.backgroundColor = .clear
            titleLabel.attributedText = title
            titleLabel.numberOfLines = 2
            titleLabel.textAlignment = NSTextAlignment.center
            self.navigationItem.titleView = titleLabel
        }
        
        tableView.backgroundColor = bgColor
        tableView.estimatedRowHeight = UITableView.automaticDimension // why??
        
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addPage))
        navigationItem.rightBarButtonItems = [composeButton]
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        doneToolbar = UIToolbar()
        doneToolbar.items = [spacer, doneButton]
        doneToolbar.sizeToFit()
        
//        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backButtonDisplayMode = .minimal
//        navigationItem.backButtonTitle = nil
//        navigationItem.leftBarButtonItem = self.editButtonItem
        
        // adding toolbar to the bottom
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(changeEntryDate))
        self.toolbarItems = [self.editButtonItem, spacer, calendarButton]
        navigationController?.toolbar.tintColor = bgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)

    }
        
    // called from .addTarget selector
    @IBAction func selectDate(_ sender: UIDatePicker) {
        if let entry = entry {
            var newEntry = entry
            newEntry.date = sender.date
            delegate.saveEntry(savedEntry: newEntry)
            title = newEntry.title + ": " + newEntry.date.monthDay()
        }
    }
    
    @objc func changeEntryDate() {
        isDateEditing = !isDateEditing
        tableView.reloadData()
        
    }
    
    @objc func doneEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @objc func addPage() {
        let ac = UIAlertController(title: "Select a page type:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Text Page", style: .default) {
                [weak self] action in
            let page = Page(id: UUID(), text: "", image: nil, pageType: "text")
            self?.entry?.pages.append(page)
            
            if let entry = self?.entry {
                self?.delegate.saveEntry(savedEntry: entry)
            }
            
            self?.tableView.reloadData()
            
            var mainSection = 0
            if let lastRow = self?.entry?.pages.count {
                if self?.isDateEditing == true {
                    mainSection = 1
                }
                self?.tableView.scrollToRow(at: IndexPath(row: lastRow - 1, section: mainSection), at: .top, animated: true)
            }
            
        })
        ac.addAction(UIAlertAction(title: "Image Page", style: .default) {
                [weak self] action in
            let page = Page(id: UUID(), text: nil, image: nil, pageType: "image")
            self?.entry?.pages.append(page)
            
            if let entry = self?.entry {
                self?.delegate.saveEntry(savedEntry: entry)
            }
            
            self?.tableView.reloadData()
            
            var mainSection = 0
            if let lastRow = self?.entry?.pages.count {
                if self?.isDateEditing == true {
                    mainSection = 1
                }
                self?.tableView.scrollToRow(at: IndexPath(row: lastRow - 1, section: mainSection), at: .top, animated: true)
            }
        })
        // NEW
        ac.addAction(UIAlertAction(title: "Gallery Page", style: .default) {
            [weak self] action in
            // ***COME BACK HERE 0 -- does the gallery mess anything up?
            let page = Page(id: UUID(), text: nil, image: nil, gallery: ["", "", "", ""], pageType: "gallery")
            // copied this over, same as other pages
            self?.entry?.pages.append(page)
            
            if let entry = self?.entry {
                self?.delegate.saveEntry(savedEntry: entry)
            }
            
            self?.tableView.reloadData()
            
            var mainSection = 0
            if let lastRow = self?.entry?.pages.count {
                if self?.isDateEditing == true {
                    mainSection = 1
                }
                self?.tableView.scrollToRow(at: IndexPath(row: lastRow - 1, section: mainSection), at: .top, animated: true)
            }
            // is that it?
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func renameEntry() {
        let ac = UIAlertController(title: "Rename Entry", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = entry?.title
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
                self?.title = title
                self?.entry?.title = title
            }
               
            if let entry = self?.entry {
                self?.delegate.saveEntry(savedEntry: entry)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
//    MARK: saveText(), savePage()
    
    func saveText(editedPage: Page) {
        // this should save text to the selectedPage
        if let index = entry?.pages.firstIndex(where: { $0.id == editedPage.id }) {
            entry?.pages[index] = editedPage
        } else {
            entry?.pages.append(editedPage)
        }
        
        tableView.reloadData()
                
        if let entry = entry {
            delegate.saveEntry(savedEntry: entry)
        }
    }
    
    func savePage() {
        if let indexPath = entryIndex {
            if let cell = tableView.cellForRow(at: indexPath) as? TextPageCell,
               let page = entry?.pages[indexPath.row] {
                var editedPage = page
                editedPage.text = cell.textView.text
                saveText(editedPage: editedPage)
            }
            
        }

    }
    
    // MARK: Text view delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .placeholderText
        }
        savePage()
    }
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isDateEditing {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isDateEditing {
            if section == 1 {
                if let entry = entry {
                    if entry.pages.isEmpty {
                        return "Add Pages for \(entry.title)"
                    } else {
                        return "Pages for \(entry.title)"
                    }
                } else {
                    return "Pages"
                }
                
            } else {
                return "Select Entry Date"
            }
        } else {
            if let entry = entry {
                if entry.pages.isEmpty {
                    return "Add Pages for \(entry.title)"
                } else {
                    return "Pages for \(entry.title)"
                }
            }
        }
       return "Pages"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.font = UIFont(name: "Avenir Next", size: 16)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDateEditing {
            if section == 1 {
                return entry?.pages.count ?? 0
            } else {
                return 1
            }
        } else {
            return entry?.pages.count ?? 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
    }

//    MARK: cellForRowAt()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1  && isDateEditing) || (indexPath.section == 0 && !isDateEditing) {
            var reuseIdentifier = ""
            var text: String?
            var image: String?
            // gallery - Optional Array<String> or no?
            var gallery: [String] = []
            var textColor: UIColor = .label
            
            if let page = entry?.pages[indexPath.row] {
                switch page.pageType {
                case "title":
                    reuseIdentifier = "TitleCell"
                case "text":
                    reuseIdentifier = "TextCell"
                    if page.text == "" {
                        text = "Write something!"
                        textColor = .placeholderText
                    } else {
                        text = page.text
                        textColor = .label
                    }
                    image = nil
                case "image":
                    reuseIdentifier = "ImageCell"
                    text = nil
                    if page.image != nil {
                        image = page.image
                    } else {
                        image = nil
                    }
                case "gallery":
                    reuseIdentifier = "GalleryCell"
                    text = nil
                    gallery = page.gallery
                    
                default:
                    reuseIdentifier = "TextCell"
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            if let text = text,
               let cell = cell as? TextPageCell {
                cell.textView?.text = text
                cell.textView?.textColor = textColor
                cell.textView.delegate = self // just added!
                cell.textView.inputAccessoryView = doneToolbar
            }
            
            if let image = image {
                let imageURL = getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: data) {
                        
                        if let cell = cell as? ImagePageCell {
                            cell.customImageView.image = image
                            cell.customImageView.layer.masksToBounds = true
                            // shouldRasterize - only if needed for performance
                            cell.customImageView.layer.cornerRadius = 12.0
                        }
                        
                        imageAspectRatio = image.size.height / image.size.width
                    }
                }
            }
            
            if !gallery.isEmpty {
                
                if let cell = cell as? GalleryPageCell {
                    cell.image1.image = nil
                    cell.image2.image = nil
                    cell.image3.image = nil
                    cell.image4.image = nil
                    cell.galleryLabel.text = "Pick images..."
                }
                
                for (index, image) in gallery.enumerated() {
                    let imageURL = getDocumentsDirectory().appendingPathComponent(image)
                    if let data = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: data) {
                            
                            if let cell = cell as? GalleryPageCell {
                                cell.galleryLabel.text = nil
                                let imageViews = [cell.image1, cell.image2, cell.image3, cell.image4]
                                imageViews[index]?.image = image
                                cell.contentView.layer.masksToBounds = true
                                cell.contentView.layer.cornerRadius = 12.0
                            }
                        }
                    }
                }
            }
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
            if let date = entry?.date {
                cell.datePicker.date = date
                cell.datePicker?.addTarget(self, action: #selector(selectDate), for: .valueChanged)
                
            }
            return cell
        }
    }
        
//    MARK: didSelectRowAt()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch entry?.pages[indexPath.row].pageType {
            case "title":
                return
            case "text":
                if let cell = tableView.cellForRow(at: indexPath) as? TextPageCell {
                    cell.textView.becomeFirstResponder()
                    entryIndex = indexPath
                }
                
            case "image":
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                present(imagePicker, animated: true)
                
            case "gallery":
                isGallery = true
                galleryCellIndex = indexPath
                
                selectGridImage()
                
            default:
                return
            }
 
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        
        // for GalleryPageCell
        if isGallery {
            if let index = galleryCellIndex?.row {
                if let imageData = image.jpegData(compressionQuality: 0.8),
                   let entry = entry {
                    var page = entry.pages[index]
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let filename = imageName + ".jpeg"
                    let fullPath = documentsDirectory[0].appendingPathComponent(filename)
                    page.gallery[galleryGridCell] = filename
                    saveText(editedPage: page)
                    try? imageData.write(to: fullPath)
                }
            }
            tableView.reloadData()
            dismiss(animated: true)
            isGallery = false
            return
        }
        
        // for ImagePageCell
        let indexPath = tableView.indexPathForSelectedRow!
        
        if let imageData = image.jpegData(compressionQuality: 0.8),
           let entry = entry {
            var page = entry.pages[indexPath.row]
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = imageName + ".jpeg"
            let fullPath = documentsDirectory[0].appendingPathComponent(filename)
            page.image = filename
            page.text = nil
            saveText(editedPage: page)
            try? imageData.write(to: fullPath)
        }
        
        // this is unused
        imageAspectRatio = image.size.height / image.size.width
        
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = entry?.pages.firstIndex(where: { $0.id == entry?.pages[indexPath.row].id }) {

                if let imageName = entry?.pages[index].image {
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let filename = imageName + ".jpeg"
                    let fullPath = documentsDirectory[0].appendingPathComponent(filename)
                    let fileManager = FileManager()
                    try? fileManager.removeItem(at: fullPath)
                }
                entry?.pages.remove(at: index)

                if let entry = entry {
                    delegate.saveEntry(savedEntry: entry)
                    self.syncJournals()
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        var pages: [Page] = []
        if let entry = entry {
            pages = entry.pages
            let fromPage = entry.pages[fromIndexPath.row]
            let toPage = entry.pages[to.row]
            
            for page in entry.pages {
                if page == fromPage {
                    pages[to.row] = page
                } else if page == toPage {
                    pages[fromIndexPath.row] = page
                }
            }
            
            let newEntry = Entry(id: entry.id, title: entry.title, text: entry.text, pages: pages, date: entry.date)
            delegate.saveEntry(savedEntry: newEntry)
            
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (isDateEditing && indexPath.section == 0) || (!isDateEditing && indexPath.section == 1) {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (isDateEditing && indexPath.section == 0) || (!isDateEditing && indexPath.section == 1) {
            return false
        }
        return true
    }
    
}
