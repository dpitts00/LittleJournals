//
//  PageGalleryCell.swift
//  LittleJournals
//
//  Created by Daniel Pitts on 8/12/21.
//

import UIKit

class PageGalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "page-gallery-cell-reuse-identifier"
    let vStack = UIStackView()
    let hStackT = UIStackView()
    let hStackB = UIStackView()
    
    let imageTL = UIImageView()
    let imageTT = UIImageView()
    let imageBL = UIImageView()
    let imageBT = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        imageTL.translatesAutoresizingMaskIntoConstraints = false
        imageTT.translatesAutoresizingMaskIntoConstraints = false
        imageBL.translatesAutoresizingMaskIntoConstraints = false
        imageBT.translatesAutoresizingMaskIntoConstraints = false
        imageTL.contentMode = .scaleAspectFit
        imageTT.contentMode = .scaleAspectFit
        imageBL.contentMode = .scaleAspectFit
        imageBT.contentMode = .scaleAspectFit

        
//        imageTL.backgroundColor = .systemGray
//        imageTT.backgroundColor = .systemGray2
//        imageBL.backgroundColor = .systemGray3
//        imageBT.backgroundColor = .systemGray4
        
        contentView.addSubview(imageTL)
        contentView.addSubview(imageTT)
        contentView.addSubview(imageBL)
        contentView.addSubview(imageBT)
        
        // will come back for UIStackView() later to learn what to fix
        
        let inset = CGFloat(4)
        NSLayoutConstraint.activate([
            imageTL.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageTL.trailingAnchor.constraint(equalTo: imageTT.leadingAnchor, constant: -inset),
            imageTL.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageTL.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -inset * 3 / 2),
            imageTL.heightAnchor.constraint(equalTo: imageTL.widthAnchor),
            
            imageTT.leadingAnchor.constraint(equalTo: imageTL.trailingAnchor, constant: inset),
            imageTT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageTT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageTT.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -inset * 3 / 2),
            imageTT.heightAnchor.constraint(equalTo: imageTT.widthAnchor),
            
            imageBL.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageBL.trailingAnchor.constraint(equalTo: imageBT.leadingAnchor, constant: -inset),
            // bottomAnchor to contentView? unnecessary so far.
            imageBL.topAnchor.constraint(equalTo: imageTL.bottomAnchor, constant: inset),
            imageBL.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -inset * 3 / 2),
            imageBL.heightAnchor.constraint(equalTo: imageBL.widthAnchor),
            
            imageBT.leadingAnchor.constraint(equalTo: imageBL.trailingAnchor, constant: inset),
            imageBT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageBT.topAnchor.constraint(equalTo: imageTT.bottomAnchor, constant: inset),
            // bottomAnchor to contentView? unnecessary so far.
            imageBT.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -inset * 3 / 2),
            imageBT.heightAnchor.constraint(equalTo: imageTT.widthAnchor),
        ])
 
    }
}
