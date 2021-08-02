//
//  InfoViewController.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/1/21.
//

import UIKit

class InfoViewController: UIViewController {
   
//    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)
    
    @IBOutlet var journalsScreenImageView: UIImageView!
    @IBOutlet var entriesScreenImageView: UIImageView!
    @IBOutlet var pagesScreenImageView: UIImageView!
    @IBOutlet var gridScreenImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Getting Started"
//        navigationController?.navigationBar.backgroundColor = bgColor
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
        
//        journalsScreenImageView.layer.borderWidth = 1
//        journalsScreenImageView.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
//        entriesScreenImageView.layer.borderWidth = 1
//        entriesScreenImageView.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
//        pagesScreenImageView.layer.borderWidth = 1
//        pagesScreenImageView.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
//        gridScreenImageView.layer.borderWidth = 1
//        gridScreenImageView.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
        
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
