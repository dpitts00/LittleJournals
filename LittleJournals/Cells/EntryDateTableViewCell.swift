//
//  EntryDateTableViewCell.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/12/21.
//

import UIKit



class EntryDateTableViewCell: UITableViewCell {
    
    @IBOutlet var dateStackView: UIStackView!
    @IBOutlet var entryLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        dateStackView.layer.shadowColor = UIColor.systemGray3.cgColor
        dateStackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        dateStackView.layer.shadowOpacity = 1
        dateStackView.layer.shadowRadius = 2
        
        monthLabel.layer.cornerRadius = 6
        monthLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        dayLabel.layer.cornerRadius = 6
        dayLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dateStackView.layer.cornerRadius = 6
                
    }

}
