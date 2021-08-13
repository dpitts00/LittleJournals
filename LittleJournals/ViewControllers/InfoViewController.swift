//
//  InfoViewController.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/1/21.
//

import UIKit

class InfoViewController: UIViewController {
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Getting Started"
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
