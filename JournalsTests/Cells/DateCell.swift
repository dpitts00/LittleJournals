//
//  DateCell.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/13/21.
//

import UIKit

class DateCell: UITableViewCell {
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
            datePicker = UIDatePicker()
            datePicker?.date = Date()
            datePicker?.locale = .current
            datePicker?.preferredDatePickerStyle = .compact
            datePicker?.datePickerMode = .date

    }

}
