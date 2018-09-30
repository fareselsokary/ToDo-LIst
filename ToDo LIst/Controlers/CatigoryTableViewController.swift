//
//  CatigoryTableViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/30/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit
import CoreData
class CatigoryTableViewController: UITableViewController {
    var catigoryArray  = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = catigoryArray[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catigoryArray.count
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       var newCategory = UITextField()
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = newCategory.text!
            if category.name != ""{
                self.catigoryArray.append(category)
                self.saveCategory()
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
            destenationVC.selectedCategory = catigoryArray[indexpath.row]
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //save data to dataBase
    func saveCategory(){
        do{
           try context.save()
        }catch{
            print("error in save category\(error)")
            tableView.reloadData()
        }
    }
    
    //load data from dataBase
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            catigoryArray = try context.fetch(request)
        }catch{
            print("error in featch reaquest\(error)")
        }
        tableView.reloadData()
    }
    
    
    
 
}
