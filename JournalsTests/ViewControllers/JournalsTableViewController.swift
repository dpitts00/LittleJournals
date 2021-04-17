//
//  JournalsTableViewController.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/7/21.
//

import UIKit

struct Journal: Codable, Hashable {
    var id = UUID().uuidString
    var title: String
    var entries: [Entry]
    // UIColor does not conform to Codable, so use UIColor(named:)
    // this doesn't work for this one, maybe the preformatting
    var color = "systemGreen"
    
}

class JournalsTableViewController: UITableViewController, EntriesViewControllerDelegate {
    
    var journals = [Journal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        title = "Journals"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJournal))
        
//        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let addJournalButton = UIBarButtonItem(title: "Add Journal", style: .plain, target: self, action: #selector(addJournal))
//        toolbarItems = [spacer, addJournalButton]
//        navigationController?.toolbar.isHidden = false
        
        loadJournals()
        // just checking journals are all there
//        for journal in journals {
//            print(journal.title)
//        }
        
        if journals.isEmpty {
            generateJournals()
        }
        
        for i in 0..<journals.count {
            if journals[i].entries.isEmpty {
                journals[i].entries = generateEntries()
            }
        }
        
        validateJournals()
       
    }
    
    @objc func addJournal() {
        let ac = UIAlertController(title: "Name your Journal:", message: "", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].autocapitalizationType = .words
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
//                let newJournal = Journal(title: title, entries: [Entry(title: "Untitled Entry", text: "")])
                let newJournal = Journal(title: title, entries: [])
                self?.saveJournal(savedJournal: newJournal, entryIndex: 0)
                
                // new part
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "EntriesView") as? EntriesViewController {
                    vc.journal = newJournal
                    vc.title = newJournal.title
                    vc.delegate = self
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
        
    func saveJournal(savedJournal: Journal, entryIndex: Int) {
        if let index = journals.firstIndex(where: { $0.id == savedJournal.id }) {
            journals[index] = savedJournal
            print(journals[index].id, journals[index].title, journals[index].entries[entryIndex].text)
        } else {
            journals.append(savedJournal)
        }
        saveJournals()
        // just checking that all journals saved
//        for journal in journals {
//            print(journal.title)
//        }
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // change to return journals.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if journals.isEmpty {
                return "Add a New Journal to Get Started"
            }
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count
        // change to return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // change to journals[indexPath.section]; AND ALL THE OTHER ONES in save methods
        let journal = journals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
        cell.textLabel?.text = journal.title
        cell.detailTextLabel?.text = "Entries: \(journal.entries.count)"
//        cell.detailTextLabel?.text = journal.id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EntriesView") as? EntriesViewController {
            let journal = journals[indexPath.row]
            vc.journal = journal
            vc.title = journal.title
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //    MARK: trailingSwipe...
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let renameAction = UIContextualAction(style: .normal, title: "Rename") {
                [weak self] action, view, completion in
                self?.renameJournal(indexPath: indexPath)
            }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                
//                if let index = self?.journal?.entries.firstIndex(where: { $0.id == self?.journal?.entries[indexPath.row].id }) {
//                    self?.journal?.entries.remove(at: index)
//                }
                
                self?.journals.remove(at: indexPath.row)
                self?.saveJournals()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            renameAction.backgroundColor = .systemBlue
            deleteAction.backgroundColor = .systemRed
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
            return swipeActions
        }
    
    @objc func renameJournal(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename Journal", message: nil, preferredStyle: .alert)
        ac.addTextField()
        // change this to selection by id? I think it's fine, because we're reading from, not writing to.
        var journal = journals[indexPath.row]
        ac.textFields?[0].text = journal.title
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] action in
            if let title = ac?.textFields?[0].text {
                journal.title = title
                self?.saveJournal(savedJournal: journal, entryIndex: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                // what animation works best here?
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}
