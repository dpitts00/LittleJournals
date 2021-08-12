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
        
        // does this make a difference? no?
//        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.cornerRadius = 12.0
        
        // but this does, dealing with subviews directly -- this is the vertical stack view
        self.contentView.subviews[1].layer.masksToBounds = true
        self.contentView.subviews[1].layer.cornerRadius = 12.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
