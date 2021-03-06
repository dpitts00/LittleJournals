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
    
//    let bgColor = UIColor(red: 3/255, green: 110/255, blue: 125/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(named: "table-background")
        navigationController?.navigationBar.tintColor = UIColor(named: "blue-green")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor(named: "blue-green")
        
        
        
        if let selectedJournal = journal {
            entries = selectedJournal.entries.sorted(by: { $0.date < $1.date })
            for entry in entries {
                if !years.contains(entry.date.year()) {
                    years.append(entry.date.year())
                }
            }
            years.sort()
        }
        validateEntries()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry)),
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(displayGrid))
        ]
        
    }
    
    @objc func displayGrid() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GridView") as? GridViewController {
            vc.entries = entries
            vc.title = journal?.title
            vc.titleColor = UIColor(red: journal?.red ?? 0, green: journal?.green ?? 0, blue: journal?.blue ?? 0, alpha: 1.0)
            vc.coverTitle = journal?.coverTitle ?? journal?.title ?? ""
            vc.coverImage = journal?.coverImage ?? ""
            
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

                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PagesView") as? PagesTableViewController {
                    vc.delegate = self
                    vc.entry = newEntry
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveEntry(savedEntry: Entry) {
        if let index = entries.firstIndex(where: { $0.id == savedEntry.id }) {
            entries[index] = savedEntry
        } else {
            entries.append(savedEntry)
        }
        
        // remove unused years
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

            self.syncJournals()
        }
        
        tableView.reloadData()
    }
    
//    MARK: Tableview Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            if let font = headerView.textLabel?.font {
                headerView.textLabel?.font = font.bold()
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let year = years.sorted()[section]
        return String(year)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return entries.count
        let entriesForYear = entries.filter( { $0.date.year() == years[section] } )
        return entriesForYear.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateEntryCell", for: indexPath) as! EntryDateTableViewCell // force unwrap okay??
        let entriesForYear = entries.filter( { $0.date.year() == years[indexPath.section] } )
        let entry = entriesForYear[indexPath.row]
        cell.entryLabel.text = entry.title
//        cell.entryLabel.adjustsFontForContentSizeCategory = true
        cell.monthLabel.text = entry.date.month()
        cell.monthLabel.font = cell.monthLabel.font.bold()
        cell.dayLabel.text = "\(entry.date.day())"
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
                
                let ac = UIAlertController(title: "Delete Entry", message: "Are you sure you want to delete this entry", preferredStyle: .alert)
                let delete = UIAlertAction(title: "Delete", style: .destructive) {
                    _ in
                    if let entries = self?.entries {
                        self?.entries.remove(at: indexPath.row)
                        self?.journal?.entries = entries
                        if let journal = self?.journal {
                            self?.delegate.saveJournal(savedJournal: journal, entryIndex: 0)
                        }
                    }

                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                ac.addAction(cancel)
                ac.addAction(delete)
                self?.present(ac, animated: true)
                
                
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

