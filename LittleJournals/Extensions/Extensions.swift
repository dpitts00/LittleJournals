//
//  Extensions.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/8/21.
//

import UIKit

// MARK: FileManager
extension UIViewController {
    func getDocumentsDirectory() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(url.absoluteString)
        return url
    }
    
    func iCloudDocumentsDirectory() -> URL? { let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        print(url?.absoluteString ?? "")
        return url?.appendingPathComponent("journals").appendingPathExtension(".json")
    }
    
    // identifier nil or the one I use?
    
    func syncJournals() {
        if let iCloudURL = iCloudDocumentsDirectory() {
            
            let journalsURL = getDocumentsDirectory().appendingPathComponent("journals.json")
            if let data = try? Data(contentsOf: journalsURL) {
                try? data.write(to: iCloudURL, options: .noFileProtection)
                print("Data synced from device to iCloud.")
            }
        }
    }
    
    func loadSyncedJournals() {
        if let iCloudURL = iCloudDocumentsDirectory() {
            let journalsURL = getDocumentsDirectory().appendingPathComponent("journals").appendingPathExtension(".json")
            if let data = try? Data(contentsOf: iCloudURL) {
                try? data.write(to: journalsURL, options: .noFileProtection)
                print("Data synced from iCloud to device.")
            }
        }
    }

}



// MARK: JournalsTableViewController
extension JournalsTableViewController {
    
    func saveJournals() {
        let journalsURL = getDocumentsDirectory().appendingPathComponent("journals").appendingPathExtension(".json")
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(journals) {
            try? encodedData.write(to: journalsURL, options: .noFileProtection)
        }
    }
    
    func loadJournals() {
        let journalsURL = getDocumentsDirectory().appendingPathComponent("journals").appendingPathExtension(".json")
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: journalsURL),
           let decodedData = try? decoder.decode([Journal].self, from: data) {
            journals = decodedData
        }
    }
}

extension JournalsTableViewController {
    
    func generateJournals() {
        for i in 0...4 {
            journals.append(Journal(title: "Journal \(i)", entries: []))
        }
    }
    
    func generateEntries() -> [Entry] {
        var entries = [Entry]()
        for i in 0..<20 {
            var components = DateComponents()
            components.day = Int.random(in: 0...30)
            components.month = Int.random(in: 0...11)
            components.year = Int.random(in: 2018...2020)
            let date = Calendar.current.date(from: components) ?? Date()
            entries.append(Entry(title: "entry \(i)", text: "", date: date))
        }
        return entries
    }
    
    func validateJournals() {
        for i in 0..<journals.count {
            if let index = journals.firstIndex(where: { $0.id == journals[i].id }) {
                assert(index == i, "Journal IDs are not consistent with journal indices.")
            }
        }
        print("Journal IDs consistent.")
    }
    
    func validateJournalsAndEntries() {
        for i in 0..<journals.count {
            if let index = journals.firstIndex(where: { $0.id == journals[i].id }) {
                assert(index == i, "Journal IDs are not consistent with journal indices.")
            }
            for j in 0..<journals[i].entries.count {
                if let index = journals[i].entries.firstIndex(where: { $0.id == journals[i].entries[j].id }) {
                    assert(index == i, "Entry IDs are not consistent with entry indices.")
                }
            }
        }
    }
    
}

//MARK: EntriesViewController
extension EntriesViewController {
    
    func validateEntries() {
        for i in 0..<entries.count {
            if let index = entries.firstIndex(where: { $0.id == entries[i].id }) {
                assert(index == i, "Entry IDs are not consistent with entry indices.")
            }
        }
        print("Entry IDs consistent.")
    }
    
    func generateEntries() {
        for i in 0...10 {
            var components = DateComponents()
            components.day = Int.random(in: 0...30)
            components.month = Int.random(in: 0...11)
            components.year = Int.random(in: 2018...2020)
            let date = Calendar.current.date(from: components) ?? Date()
            entries.append(Entry(title: "entry \(i)", text: "", date: date))
        }
        tableView.reloadData()
    }
    
}

// MARK: Date
extension Date {
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func year() -> Int {
        let currentComponents = Calendar.current.dateComponents([.year], from: self)
        return currentComponents.year ?? 0
        
    }
    
    func monthDay() -> String {
        let dateString = self.date()
        let monthDay = dateString.split(separator: ",")
        return String(monthDay[0])
    }
    
    func day() -> String {
        let currentComponents = Calendar.current.dateComponents([.day], from: self)
        if let day = currentComponents.day {
            return String(day)
        }
        return "1"
    }
    
    func month() -> String {
        let dateString = self.date()
        if let end = dateString.firstIndex(of: " ") {
            let monthString = dateString[dateString.startIndex...end].uppercased()
            return monthString
        }
        return "JAN"
    }
    
}

