//
//  Journal.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/17/21.
//

import Foundation

struct Journal: Codable, Hashable {
    var id = UUID().uuidString
    var title: String
    var entries: [Entry]
    // UIColor does not conform to Codable, so use UIColor(named:)
    // this doesn't work for this one, maybe the preformatting
    // revert to hex/rgb conversions for JSON, seems to be standard
    // will need for web/mobile consistency
    var color = "systemGreen"
    var lastModified: Date = Date()
    
}
