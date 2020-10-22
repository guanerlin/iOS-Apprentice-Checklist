//
//  AllListTableViewController.swift
//  Checklists
//
//  Created by zhenglin on 2020/10/15.
//  Copyright © 2020 zhenglin. All rights reserved.
//

import UIKit

class AllListTableViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    let cellIdentifier = "ChecklistCell"
    /// syntactic sugar
    /// var checklists = [Checklist]()
    
    var dataModel: DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
//        dummyData()
        dataModel.loadChecklists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let list = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: list)
        }
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /*
    func dummyData() {
        var list = Checklist(name: "Birthdays")
        checklists.append(list)
        
        list = Checklist(name: "Groceries")
        checklists.append(list)
        
        list = Checklist(name: "Cool apps")
        checklists.append(list)
        
        list = Checklist(name: "To Do")
        checklists.append(list)
    }
 */
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let list = dataModel.lists[indexPath.row]
        cell.textLabel!.text = "\(list.name)"
        cell.accessoryType = .detailDisclosureButton
        if list.countUncheckedItem() == 0 {
            cell.detailTextLabel?.text = "All Done"
        } else {
        	cell.detailTextLabel?.text = "\(list.countUncheckedItem()) Remaining"
        }
        
        if list.items.count == 0 {
            cell.detailTextLabel?.text = "(No iItem)"
        }
        cell.imageView!.image = UIImage(named: list.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK:- Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = dataModel.lists[indexPath.row]
        dataModel.indexOfSelectedChecklist = indexPath.row
        performSegue(withIdentifier: "ShowChecklist", sender: list)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let list = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "EditChecklist", sender: list)
    }
    
    // MARK: - ListDetialViewControllerDelegate
    func listDetailViewControllerDidCancel(_ controller:ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller:ListDetailViewController, didFinishAdding list: Checklist) {
        dataModel.lists.append(list)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller:ListDetailViewController, didFinishEditing list: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            let list = sender as! Checklist
            controller.checklist = list
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailViewController
            let list = sender as! Checklist
            controller.checklistToEdit = list
            controller.delegate = self
        }
    }
    
    // MARK: - Navigation delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
