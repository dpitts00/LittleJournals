//
//  InfoViewController.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/1/21.
//

import UIKit

class InfoViewController: UIViewController {
   
//    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Getting Started"
//        navigationController?.navigationBar.backgroundColor = bgColor
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
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
