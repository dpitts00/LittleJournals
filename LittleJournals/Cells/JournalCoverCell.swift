//
//  JournalCoverCell.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/13/21.
//

import UIKit

class JournalCoverCell: UICollectionViewCell {
    static let reuseIdentifier = "journal-cover-cell-reuse-identifier"
    let imageView = UIImageView()
    let label = UILabel()
    
    let coverTitle = "Sample Title"
    let titleColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.image = coverImage (gotten from data)
        contentView.addSubview(imageView)
        
        label.font = .systemFont(ofSize: contentView.frame.maxX / 6, weight: .bold)
        label.textAlignment = .center
        
        label.textColor = titleColor
        label.text = coverTitle
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
        contentView.addSubview(label)
        contentView.bringSubviewToFront(label)
        
        let inset = CGFloat(4)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: contentView.frame.maxX / 2),
            
        ])
    }
}
