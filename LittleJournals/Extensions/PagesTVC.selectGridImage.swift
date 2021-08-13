//
//  PagesTVC.selectGridImage.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/13/21.
//

import UIKit

extension PagesTableViewController {
    func selectGridImage() {
        let ac = UIAlertController(title: "Select a Grid Image", message: nil, preferredStyle: .actionSheet)
        let topLeadingImage = UIAlertAction(title: "Image 1", style: .default) { _ in
            self.galleryGridCell = 0
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        let topTrailingImage = UIAlertAction(title: "Image 2", style: .default) { _ in
            self.galleryGridCell = 1
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        let bottomLeadingImage = UIAlertAction(title: "Image 3", style: .default) { _ in
            self.galleryGridCell = 2
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        let bottomTrailingImage = UIAlertAction(title: "Image 4", style: .default) { _ in
            self.galleryGridCell = 3
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        // MARK: Grid image icons
        let tlImage = UIImage(named: "square.grid.2x2.fill.top.leading")
        let ttImage = UIImage(named: "square.grid.2x2.fill.top.trailing")
        let blImage = UIImage(named: "square.grid.2x2.fill.bottom.leading")
        let btImage = UIImage(named: "square.grid.2x2.fill.bottom.trailing")
        topLeadingImage.setValue(tlImage, forKey: "image")
        topTrailingImage.setValue(ttImage, forKey: "image")
        bottomLeadingImage.setValue(blImage, forKey: "image")
        bottomTrailingImage.setValue(btImage, forKey: "image")
                
        ac.addAction(topLeadingImage)
        ac.addAction(topTrailingImage)
        ac.addAction(bottomLeadingImage)
        ac.addAction(bottomTrailingImage)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
