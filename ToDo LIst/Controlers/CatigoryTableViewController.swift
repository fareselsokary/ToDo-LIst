//
//  CatigoryTableViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/30/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit
import RealmSwift
class CatigoryTableViewController: UITableViewController {
    var catigoryArray  : Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = catigoryArray?[indexPath.row].name ?? "No category add yet"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catigoryArray?.count ?? 1
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       var newCategory = UITextField()
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category()
            category.name = newCategory.text!
            if category.name != ""{
                self.saveCategory(category: category)
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            newCategory = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! ToDoLIstViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destenationVC.selectedCategory = catigoryArray?[indexpath.row]
        }
    }
    
    
    
    
    
    //save data to dataBase
    func saveCategory(category : Category){
        do{
            try realm.write{
                realm.add(category)
            }
            
        }catch{
            print("error in save category\(error)")
            tableView.reloadData()
        }
    }
    
    //load data from dataBase
    func loadCategory(){
        catigoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    
 
}
