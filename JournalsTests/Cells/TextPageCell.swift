//
//  TextPageCell.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/9/21.
//

import UIKit

class TextPageCell: UITableViewCell {

    @IBOutlet var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //    MARK: Text view methods -- ??
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.placeholderText {
                textView.text = ""
                textView.textColor = UIColor.label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = "Placeholder text"
                textView.textColor = .placeholderText
            }
        }

}
