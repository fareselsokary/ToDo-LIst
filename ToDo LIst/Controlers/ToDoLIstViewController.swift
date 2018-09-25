//
//  ViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/24/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit

class ToDoLIstViewController: UITableViewController {
    var listArray = [ItemList]()
    let defaulets = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        defaulets.array(forKey: "toDoList")
        let thing = ItemList()
        thing.title = "00000000000000000"
        listArray.append(thing)
        
        let thing1 = ItemList()
        thing1.title = "11111111111111111"
        listArray.append(thing1)
        
        let thing2 = ItemList()
        thing2.title = "22222222222222222"
        listArray.append(thing2)
        print(listArray)
    }
    //MARK - tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row].title
        cell.accessoryType = listArray[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listArray.count)
        return listArray.count
    }
    
    //MARK - tableview deleget methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listArray[indexPath.row])
        
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        let item = ItemList()
        item.title = newItem.text!
        let alert = UIAlertController(title: "new ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.listArray.append(item)
            self.defaulets.set(self.listArray, forKey: "toDoLIst")
            self.tableView.reloadData()
            print(self.listArray)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

