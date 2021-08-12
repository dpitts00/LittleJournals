//
//  GalleryPageCell.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/11/21.
//

import UIKit

class GalleryPageCell: UITableViewCell {

    @IBOutlet var galleryLabel: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image1.backgroundColor = .systemRed
        image2.backgroundColor = .systemBlue
        image3.backgroundColor = .systemGreen
        image4.backgroundColor = .systemYellow
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
