//
//  ViewController.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/7/21.
//

import UIKit

protocol EntriesViewControllerDelegate {
    func saveJournal(savedJournal: Journal, entryIndex: Int)
}

class EntriesViewController: UITableViewController, UINavigationControllerDelegate, PagesTableViewControllerDelegate {
    
    var entries: [Entry] = []
    var journal: Journal?
    var delegate: EntriesViewControllerDelegate!
    
    var dateFormatter = DateFormatter()
    
    // for the year-sorted sections
    var years: [Int] = []
    var sortedEntries: [Entry] = []
    
    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = bgColor
        
        if let selectedJournal = journal {
            entries = selectedJournal.entries.sorted(by: { $0.date < $1.date })
            for entry in entries {
                if !years.contains(entry.date.year()) {
                    years.append(entry.date.year())
                }
            }
            years.sort()
            print(years)
        }
        validateEntries()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry)),
            UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(displayGrid))
        ]
        
        
    }
    
    @objc func displayGrid() {
        print("displayGrid")
        // send to new VC with collectionView
        // send years, entriesForYear?, entries?, journal (for title AND entries)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GridView") as? GridViewController {
            vc.entries = entries
            vc.title = journal?.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    @objc func renameJournal() {
        let ac = UIAlertController(title: "Rename Journal", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = journal?.title
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
                self?.title = title
                self?.journal?.title = title
            }
               
            if let journal = self?.journal {
                self?.delegate.saveJournal(savedJournal: journal, entryIndex: 0)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addEntry() {
        let ac = UIAlertController(title: "Name your Entry:", message: "", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].autocapitalizationType = .words
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
                let newEntry = Entry(title: title, text: "", date: Date())
                self?.saveEntry(savedEntry: newEntry)
                // new part
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PagesView") as? PagesTableViewController {
                    vc.delegate = self
//                    vc.entry = entries[indexPath.row]
                    vc.entry = newEntry
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveEntry(savedEntry: Entry) {
        print("saveEntry()")
        if let index = entries.firstIndex(where: { $0.id == savedEntry.id }) {
            entries[index] = savedEntry
        } else {
            entries.append(savedEntry)
        }
        
        // remove unused years - WIP
        for year in years {
            if entries.filter({ $0.date.year() == year }).isEmpty {
                if let index = years.firstIndex(of: year) {
                    years.remove(at: index)
                }
            }
        }
        
        // add year to years
        if !years.contains(savedEntry.date.year()) {
            years.append(savedEntry.date.year())
        }
        
        // save entries to journal anytime entries is edited
        entries.sort(by: { $0.date < $1.date })
        journal?.entries = entries
        if let journal = journal,
           let delegate = delegate,
           let entryIndex = entries.firstIndex(where: { $0.id == savedEntry.id }) {
            delegate.saveJournal(savedJournal: journal, entryIndex: entryIndex)
            // ***KEEP HERE?
            self.syncJournals()

            print(journal.id, journal.title, journal.entries[entryIndex].text)
        }
        
        
        tableView.reloadData()
    }
    
//    MARK: Tableview Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.font = UIFont(name: "Avenir Next", size: 16)

        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        years.sort()
        let year = years.sorted()[section]
        return String(year)
//        if section == 0 {
//            if let journal = journal {
//                if !journal.entries.isEmpty {
//                    return "Entries for \(journal.title)"
//                } else {
//                    return "Add New Entries for \(journal.title)"
//                }
//            }
//        }
//        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return entries.count
        let entriesForYear = entries.filter( { $0.date.year() == years[section] } )
        return entriesForYear.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
//        let entry = entries[indexPath.row]
//        cell.textLabel?.text = entry.title
//        cell.detailTextLabel?.textColor = .systemGray
//        cell.detailTextLabel?.text = entry.date.monthDay() // custom method on Date
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateEntryCell", for: indexPath) as! EntryDateTableViewCell // force unwrap okay??
//        let entry = entries[indexPath.row]
        // this seems VERY COMPUTATIONALLY expensive
        let entriesForYear = entries.filter( { $0.date.year() == years[indexPath.section] } )
        let entry = entriesForYear[indexPath.row]
        cell.entryLabel.text = entry.title
        cell.monthLabel.text = entry.date.month()
        
//        cell.dateButton.backgroundColor = .systemGray
        cell.dayLabel.text = entry.date.day()
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PagesView") as? PagesTableViewController {
            vc.delegate = self
            // this needs to change now to id or ...
            let entriesForYear = entries.filter( { $0.date.year() == years[indexPath.section] } )
            let entry = entriesForYear[indexPath.row]
            vc.entry = entry
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //    MARK: trailingSwipe...
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let renameAction = UIContextualAction(style: .normal, title: "Rename") {
                [weak self] action, view, completion in
                self?.renameEntry(indexPath: indexPath)
            }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                
//                if let index = self?.journal?.entries.firstIndex(where: { $0.id == self?.journal?.entries[indexPath.row].id }) {
//                    self?.journal?.entries.remove(at: index)
//                }
                if let entries = self?.entries {
                    self?.entries.remove(at: indexPath.row)
                    self?.journal?.entries = entries
                    if let journal = self?.journal {
                        self?.delegate.saveJournal(savedJournal: journal, entryIndex: 0)
                    }
                }

                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            renameAction.backgroundColor = .systemBlue
            deleteAction.backgroundColor = .systemRed
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
            return swipeActions
        }
    
    @objc func renameEntry(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename Entry", message: nil, preferredStyle: .alert)
        ac.addTextField()
        // change this to selection by id? I think it's fine, because we're reading from, not writing to.
        var entry = journal?.entries[indexPath.row]
        ac.textFields?[0].text = entry?.title
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
                entry?.title = title
            }
               
            if let entry = entry {
                self?.saveEntry(savedEntry: entry)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    

}

