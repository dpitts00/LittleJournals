//
//  PagesTableViewController.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/8/21.
//

import UIKit

struct Page: Codable, Hashable {
    var id = UUID().uuidString
    var text: String?
    var image: String?
    var pageType: String
}

protocol PagesTableViewControllerDelegate {
    func saveEntry(savedEntry: Entry)
}

class PagesTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    

    var entry: Entry?
    var delegate: PagesTableViewControllerDelegate!
    var textViewIndex: IndexPath?
    var imageAspectRatio: CGFloat = 1
    var entryIndex: IndexPath?
    
    var doneToolbar: UIToolbar!
    var isDateEditing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entry {
            title = entry.title + ": " + entry.date.monthDay()
        }
        
        view.backgroundColor = .systemGroupedBackground
        
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addPage)),
            UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(changeEntryDate))
        ]
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        doneToolbar = UIToolbar()
        doneToolbar.items = [spacer, doneButton]
        doneToolbar.sizeToFit()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    // called from .addTarget selector
    @IBAction func selectDate(_ sender: UIDatePicker) {
        print("selectDate()")
        if let entry = entry {
            var newEntry = entry
            newEntry.date = sender.date
            delegate.saveEntry(savedEntry: newEntry)
            title = newEntry.title + ": " + newEntry.date.monthDay()
        }
    }
    
    @objc func changeEntryDate() {
        // placeholder for now
//        showDatePicker()
        print("changeEntryDate")
        isDateEditing = !isDateEditing
//        tableView.insertSections([1], with: .automatic)
        // should use insert/deleteSection but haven't
        tableView.reloadData()
        
    }
    
    @objc func doneEditing() {
        print("doneEditing")
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        tableView.isUserInteractionEnabled = true
//        savePage()
    }
    
    @objc func addPage() {
        let ac = UIAlertController(title: "Select a page type:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Text Page", style: .default) {
                [weak self] action in
            let page = Page(text: "", image: nil, pageType: "text")
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
            let page = Page(text: nil, image: nil, pageType: "image")
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
        print("saveText")
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
        print("savePage")
        if let indexPath = entryIndex {
            print(indexPath)
            if let cell = tableView.cellForRow(at: indexPath) as? TextPageCell,
               let page = entry?.pages[indexPath.row] {
                print("cell and page exist")
                var editedPage = page
                editedPage.text = cell.textView.text
//                guard page.text != cell.textView.text else { return }
                saveText(editedPage: editedPage)
                
//                cell.textView.isUserInteractionEnabled = false // ??
            }
            // this work?
//            tableView.deselectRow(at: entryIndexRow, animated: true)
            
        }

    }
    
    // MARK: Text view delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
//        savePage()
//        neither method works here.
//        doneEditing()
        if textView.text == "" {
            textView.textColor = .placeholderText
//            textView.text = "Write something!"
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

//    MARK: cellForRowAt()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1  && isDateEditing) || (indexPath.section == 0 && !isDateEditing) {
            var reuseIdentifier = ""
            var text: String?
            var image: String?
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
                        cell.imageView?.image = image
                        imageAspectRatio = image.size.height / image.size.width
                    }
                }
            }
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
            if let date = entry?.date {
                cell.datePicker.date = date
//                if let datePicker = cell.datePicker {
//                    datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
//                }
                cell.datePicker?.addTarget(self, action: #selector(selectDate), for: .valueChanged)
                
            }
            return cell
        }
    }
        
//    MARK: didSelectRowAt()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let pageType = entry?.pages[indexPath.row].pageType
//        print("you selected " + pageType! + " at: ")
//        print(indexPath)
//        tableView.isUserInteractionEnabled = false
        
        // to save for previous entryIndex ???
        
        switch entry?.pages[indexPath.row].pageType {
            case "title":
                print("click Title")
            case "text":
                print("click Text")
                
                if let cell = tableView.cellForRow(at: indexPath) as? TextPageCell {
//                    cell.textView.isUserInteractionEnabled = true // no?
                    cell.textView.becomeFirstResponder()
                    /* PUT THIS BACK IF IT DOESN'T WORK
                    if cell.textView.textColor == .placeholderText {
                        cell.textView.text = ""
                        cell.textView.textColor = .label
                    }
                    */
//                    *** MAJOR WORK NEEDS DONE HERE FOR BUGS, AND save() methods ALSO
                    entryIndex = indexPath
//                    savePage() // ??
//                    doneEditing() // ??
//                    cell.textView.resignFirstResponder()
//                    cell.textView.isUserInteractionEnabled = true // ??? major bugs here before
                }
                print(indexPath)
                
            case "image":
                print("click Image")
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                present(imagePicker, animated: true)
            default:
                print("default")
            }
 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        // this might not work, calling selectedRow
        let indexPath = tableView.indexPathForSelectedRow!
//        currentImageView.image = image
//        entry.pages[currentCell].images?.append(image)
        
        // save the image to .documentsDirectory
        let imageName = UUID().uuidString
        if let imageData = image.jpegData(compressionQuality: 0.8),
           let entry = entry {
            var page = entry.pages[indexPath.row]
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = imageName + ".jpeg"
            let fullPath = documentsDirectory[0].appendingPathComponent(filename)
            page.image = filename
            page.text = nil
            // the saveText method isn't working here
            print(page)
            saveText(editedPage: page)
            try? imageData.write(to: fullPath)
        }
        
        imageAspectRatio = image.size.height / image.size.width
        // maybe expand to imageAspectRatios.append() ??
        
//        if let imageCell = tableView.cellForRow(at: indexPath) {
//            imageCell.imageView?.image = image
//            imageCell.imageView?.contentMode = .scaleAspectFit
//        }
        tableView.reloadData()
        dismiss(animated: true)
    }
    
//     this doesn't work as needed
//    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        doneEditing()
//    }
    
//    MARK: heightForRowAt()
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         setting height for textView doesn't work like this.
        if (isDateEditing && indexPath.section == 1) || (!isDateEditing && indexPath.section == 0) {
            if entry?.pages[indexPath.row].pageType == "text" {
                return UITableView.automaticDimension
            }
            if entry?.pages[indexPath.row].pageType == "image" {
                return (view.frame.width - 15 - 16 - 15 - 16) * imageAspectRatio
            } else {
                return UITableView.automaticDimension

            }
        }
        return 60
        
    }
    
/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
*/
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // This might be wrong...
            // But it works on simulator.
            if let index = entry?.pages.firstIndex(where: { $0.id == entry?.pages[indexPath.row].id }) {
                // deleting the image isn't working
                if let imageName = entry?.pages[index].image {
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let filename = imageName + ".jpeg"
                    let fullPath = documentsDirectory[0].appendingPathComponent(filename)
                    let fileManager = FileManager()
                    try? fileManager.removeItem(at: fullPath)
                }
                entry?.pages.remove(at: index)
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    


    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        var pages = [Page]()
        if let entry = entry {
            pages = entry.pages
            let fromPage = entry.pages[fromIndexPath.row]
            let toPage = entry.pages[to.row]
            print(fromPage)
            print(toPage)
            
            
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

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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
