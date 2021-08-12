//
//  ImagePageCell.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/8/21.
//

import UIKit

class ImagePageCell: UITableViewCell {
    
    @IBOutlet var customImageView: UIImageView!
    @IBOutlet var customTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // does this make a difference?
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // trying to get a margin!!
    override func layoutSubviews() {
        super.layoutSubviews()
        // this clips the bottom of the image in the cell
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
  
    }

}
/*
 class ImagePageCell: UITableViewCell {
     
     @IBOutlet var customImageView: UIImageView!
     @IBOutlet var customTextLabel: UILabel!
     
     override func awakeFromNib() {
         super.awakeFromNib()
         
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
         
         // Configure the view for the selected state
     }
     
     // trying to get a margin!!
     override func layoutSubviews() {
         super.layoutSubviews()
         // this clips the bottom of the image in the cell
         contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
   
     }

 }
 */
