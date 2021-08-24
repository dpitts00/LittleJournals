//
//  EditViewController.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/12/21.
//

import UIKit

protocol EditViewControllerDelegate {
    func saveJournal(savedJournal: Journal, entryIndex: Int)
}

class EditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIColorPickerViewControllerDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var coverTextField: UITextField!
    @IBOutlet var colorButton: UIButton!
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = colorButton.tintColor
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    @IBOutlet var colorButtonBG: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var selectImageButton: UIButton!
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet var colorStackView: UIStackView!
    @IBOutlet var imageStackView: UIStackView!
    var imageFileName: String = ""
    
    var selectedColor: UIColor = .black
    
//    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)
    
    var journal: Journal?
    var delegate: EditViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Journal"
        
//        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveJournal))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        // checking colors
        view.backgroundColor = UIColor(named: "table-background")
        navigationController?.navigationBar.tintColor = UIColor(named: "blue-green")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor(named: "blue-green")
        
        colorStackView.layer.cornerRadius = 4.0
        imageStackView.layer.cornerRadius = 4.0
        imageView.layer.cornerRadius = 4.0
        
        titleTextField.text = journal?.title
        coverTextField.text = journal?.coverTitle
        colorButton.tintColor = UIColor(red: journal?.red ?? 0, green: journal?.green ?? 0, blue: journal?.blue ?? 0, alpha: 1.0)
        colorButtonBG.tintColor = UIColor.label
        
        if let image = journal?.coverImage {
            if !image.isEmpty {
                imageFileName = image
                let imageURL = getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: data) {
                        imageView.image = image
                    }
                }
            }
        }
        
        imageView.contentMode = .scaleAspectFit
        
    }
    
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveJournal() {
        if let journal = journal {
            var editedJournal = journal
            editedJournal.title = titleTextField?.text ?? ""
            editedJournal.coverTitle = coverTextField?.text ?? ""
            
            let colorComponents = colorButton.tintColor.cgColor.components
            if let red = colorComponents?[0],
               let green = colorComponents?[1],
               let blue = colorComponents?[2] {
                editedJournal.red = red
                editedJournal.green = green
                editedJournal.blue = blue
            }
            
            editedJournal.coverImage = imageFileName
            
            delegate.saveJournal(savedJournal: editedJournal, entryIndex: 0)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
                
        imageView.image = image
        
        let imageName = UUID().uuidString
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = imageName + ".jpeg"
            let fullPath = documentsDirectory[0].appendingPathComponent(filename)
            try? imageData.write(to: fullPath)
            if let journal = journal {
                var editedJournal = journal
                editedJournal.coverImage = filename
                imageFileName = filename
                delegate.saveJournal(savedJournal: editedJournal, entryIndex: 0)
            }
        }
        dismiss(animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorButton.tintColor = viewController.selectedColor
        let colorComponents = viewController.selectedColor.cgColor.components
        if let journal = journal {
            var editedJournal = journal
            if let red = colorComponents?[0],
               let green = colorComponents?[1],
               let blue = colorComponents?[2] {
                editedJournal.red = red
                editedJournal.green = green
                editedJournal.blue = blue
                delegate.saveJournal(savedJournal: editedJournal, entryIndex: 0)
            }
        }
    }
    
}
