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
    let dataFilePAth = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    //MARK - tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = listArray[indexPath.row].title
        cell.accessoryType = listArray[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArray.count
    }
    
    //MARK - tableview deleget methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        
        
        let alert = UIAlertController(title: "new ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = ItemList()
            item.title = newItem.text!
            if item.title != ""{
                self.listArray.append(item)
                
                self.tableView.reloadData()
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        self.saveData()
    }
    //save persestant data
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(listArray)
            try data.write(to: dataFilePAth!)
        }catch{
            print("error in write data pathfile\(error)")
        }
        tableView.reloadData()
    }
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePAth!){
            let decoder = PropertyListDecoder()
            do{
                listArray = try decoder.decode([ItemList].self, from : data)
            }catch{
                print("error in load data fron decoder\(error)")
            }
        }
        
        
    }
    
}
