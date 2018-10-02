//
//  ViewController.swift
//  ToDo LIst
//
//  Created by fares elsokary on 9/24/18.
//  Copyright © 2018 fares elsokary. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoLIstViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItem : Results<ItemList>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
        
    }
    /////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = false
        tableView.rowHeight = 80.0
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let categoryColor = selectedCategory?.color else{fatalError()}
        updateUI(withHexCode: categoryColor)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateUI(withHexCode: "0096FF")
        
    }
    
    
    
    
    
    
    //MARK - tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
    
        if let item = toDoItem?[indexPath.row]{
           
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItem!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        }else{
            cell.textLabel?.text = "No item add yet"
        }
        
        return cell
        
    }
    //////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
            return toDoItem?.count ?? 1
        
    }
    
   
    
    //MARK - tableview deleget methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
                
            }catch{
                print("error in adding done(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contexyualAction, view, action) in
            self.deleteItem(indexpath: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            action(true)
        }
        delete.image = UIImage(named: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    /////////////////////////////////////add new item
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        
        
        let alert = UIAlertController(title: "new ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let item = ItemList()
                        item.title = newItem.text!
                        
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("error adding new item \(error)")
                }
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
    
    
    
    //Load data fro realm
    func loadData(){
        toDoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true).sorted(byKeyPath: "done", ascending: true)
        tableView.reloadData()
    }
    
    
    func updateUI(withHexCode hexColor : String){
        guard let navBar = navigationController?.navigationBar else{fatalError("navigation controler doesnot exist")}
        
        guard let selectedCoategoryColor = UIColor(hexString: hexColor) else {fatalError()}
        navBar.tintColor = ContrastColorOf(selectedCoategoryColor, returnFlat: true)
        navBar.barTintColor = selectedCoategoryColor
        searchBar.barTintColor = selectedCoategoryColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :ContrastColorOf(selectedCoategoryColor, returnFlat: true)]
    }
}
extension ToDoLIstViewController : UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItem = toDoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            loadData()
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        searchBar.showsCancelButton = false
        searchBar.text = nil
        loadData()
    }
    
    func deleteItem(indexpath : IndexPath){
        if let deletedItem = self.toDoItem?[indexpath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deletedItem)
                }
            }catch{
                print("error in category deletion\(error)")
            }
        }
    }
    
}
