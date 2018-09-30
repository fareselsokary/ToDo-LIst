//
//  ViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/24/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit
import CoreData
class ToDoLIstViewController: UITableViewController {
    var listArray = [ItemList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
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
            let item = ItemList(context: self.context)
            item.title = newItem.text!
            item.done = false
            item.parentCatigoury = self.selectedCategory
            if item.title != ""{
                
                self.listArray.append(item)
                self.saveData()
                self.tableView.reloadData()
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //save persestant data
    func saveData(){
        
        do{
            try context.save()
        }catch{
            print("error in write data \(error)")
        }
        tableView.reloadData()
    }
    func loadData(with request : NSFetchRequest<ItemList> = ItemList.fetchRequest(), predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCatigoury.name MATCHES %@", selectedCategory!.name!)
        if let aditinalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditinalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
            listArray = try context.fetch(request)
        }catch{
            print("error in featch reaquest\(error)")
        }
        tableView.reloadData()
    }
    
}
extension ToDoLIstViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ItemList> = ItemList.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            loadData()
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
}
