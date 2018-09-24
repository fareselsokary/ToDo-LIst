//
//  ViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/24/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit

class ToDoLIstViewController: UITableViewController {
    var listArray = ["egg" ,"Milk" ,"Cheese" ,"Butter"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK - tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    //MARK - tableview deleget methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        let alert = UIAlertController(title: "new ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.listArray.append(newItem.text!)
            self.tableView.reloadData()
            print("yes")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

