//
//  CatigoryTableViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/30/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CatigoryTableViewController: UITableViewController {
    var catigoryArray  : Results<Category>?
    let realm = try! Realm()
    let color = UIColor.randomFlat.hexValue()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 80.0
       updateUI(withHexCode: "0096FF")
    }
    func updateUI(withHexCode hexColor : String){
        guard let navBar = navigationController?.navigationBar else{fatalError("navigation controler doesnot exist")}
        
        guard let selectedCoategoryColor = UIColor(hexString: hexColor) else {fatalError()}
        navBar.tintColor = ContrastColorOf(selectedCoategoryColor, returnFlat: true)
        navBar.barTintColor = selectedCoategoryColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :ContrastColorOf(selectedCoategoryColor, returnFlat: true)]
        
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let category = catigoryArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color)else { fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catigoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contexyualAction, view, action) in
            self.deleteCategory(indexpath: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            action(true)
        }
        delete.image = UIImage(named: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       var newCategory = UITextField()
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category()
            category.name = newCategory.text!
            category.color = self.color
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
    
    func deleteCategory(indexpath : IndexPath){
        if let deletedCategory = self.catigoryArray?[indexpath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deletedCategory)
                }
            }catch{
                print("error in category deletion\(error)")
            }
        }
    }
    
    
 
}
