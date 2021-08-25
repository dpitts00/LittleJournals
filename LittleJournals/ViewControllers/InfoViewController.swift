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
    @IBOutlet var infoLabel5: UILabel!
    @IBOutlet var infoLabel6: UILabel!
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Getting Started"
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
        
        infoLabel1.text = "Create journals, and swipe for editing options."
        infoLabel2.text = "Create entries in a journal, sorted automatically by date, grouped by year."
        infoLabel3.text = "Add text, image, and gallery pages to each entry, or change the entry date."
        infoLabel4.text = "Edit the cover title, cover image, and title color of a journal."
        infoLabel5.text = "View the pages of your journal in grid or page format!"
        infoLabel6.text = "Export your journal as a PDF for sharing or printing!"
        
        image1.image = UIImage(named: "info1")
        image2.image = UIImage(named: "info2")
        image3.image = UIImage(named: "info3")
        image4.image = UIImage(named: "info4")
        image5.image = UIImage(named: "info5")
        image6.image = UIImage(named: "info6")
        
        let shadowColor = UIColor(named: "date-view-shadow")?.cgColor ?? UIColor.systemGray.cgColor
        let shadowRadius: CGFloat = 24.0
        let shadowOpacity: Float = 1.0
        image1.layer.shadowColor = shadowColor
        image1.layer.shadowRadius = shadowRadius
        image1.layer.shadowOpacity = shadowOpacity
        image2.layer.shadowColor = shadowColor
        image2.layer.shadowRadius = shadowRadius
        image2.layer.shadowOpacity = shadowOpacity
        image3.layer.shadowColor = shadowColor
        image3.layer.shadowRadius = shadowRadius
        image3.layer.shadowOpacity = shadowOpacity
        image4.layer.shadowColor = shadowColor
        image4.layer.shadowRadius = shadowRadius
        image4.layer.shadowOpacity = shadowOpacity
        image5.layer.shadowColor = shadowColor
        image5.layer.shadowRadius = shadowRadius
        image5.layer.shadowOpacity = shadowOpacity
        image6.layer.shadowColor = shadowColor
        image6.layer.shadowRadius = shadowRadius
        image6.layer.shadowOpacity = shadowOpacity
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
