//
//  InfoViewController.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/1/21.
//

import UIKit

class InfoViewController: UIViewController {
       
    @IBOutlet var infoLabel1: UILabel!
    @IBOutlet var infoLabel2: UILabel!
    @IBOutlet var infoLabel3: UILabel!
    @IBOutlet var infoLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Getting Started"
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
        
        infoLabel1.text = "Welcome to Little Journals, a journaling app designed to make recording your memories and ideas easy. This app also lets you export your journals in PDF format, making sharing and printing simple. Tap on the ? anytime to view this guide again.\n\nOn the Journals page, you can tap on the + to create new journals. Swipe to rename or delete existing journals."
        infoLabel2.text = "You can create, edit, and view your entries in each journal. Entries are automatically sorted by date and grouped by year."
        infoLabel3.text = "Little Journals emphasizes simple and easy-to-use formatting. Add text or images, edit or reorder pages, and change the entry date."
        infoLabel4.text = "When you're all done creating a journal, you can view all of a journal's pages in grid or page form, and share or print a PDF of your journal."

    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
