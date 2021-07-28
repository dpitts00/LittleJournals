//
//  Entry.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/17/21.
//

import Foundation

struct Entry: Codable, Hashable {
    var id = UUID().uuidString
    var title: String
    var text: String
    var pages: [Page] = []
    var date: Date
}
