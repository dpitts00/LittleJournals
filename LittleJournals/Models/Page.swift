//
//  Page.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/17/21.
//

import Foundation

struct Page: Codable, Hashable {
    var id = UUID().uuidString
    var text: String?
    var image: String?
    var gallery: [String] = []
    var pageType: String
}
