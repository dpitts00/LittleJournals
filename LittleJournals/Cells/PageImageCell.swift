//
//  PageImageCell.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/15/21.
//

import UIKit

// ***Does any of this need to remain?? These classes are not used.

class PageImageCell: UICollectionViewCell {
    static let reuseIdentifier = "page-image-cell-reuse-identifier"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        let inset = CGFloat(4)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])
    }
}
