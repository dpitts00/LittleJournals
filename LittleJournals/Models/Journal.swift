//
//  Journal.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/17/21.
//

import Foundation
import UIKit

struct Journal: Codable, Hashable {
    var id = UUID().uuidString
    var title: String
    var coverTitle: String = ""
    var coverImage: String = ""
    // for the image filename, same as the rest
    var entries: [Entry]
    
    var lastModified: Date = Date()
    
    // UIColor does not conform to Codable, so use UIColor(named:)
    // this doesn't work for this one, maybe the preformatting
    // revert to hex/rgb conversions for JSON, seems to be standard
    // will need for web/mobile consistency
    var red: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var green: CGFloat = 0.0
    
}
