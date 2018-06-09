//
//  ViewController.swift
//  Todoey
//
//  Created by Yinpeng Chen on 2018-06-05.
//  Copyright © 2018 Yinpeng Chen. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [item]{
//            itemArray = items
//        }
        
        
    }
    
    //MART - Function used to append new itme to the array
    func appendItems(items : String) -> Void {
        let newItem = Item(context: context)
        newItem.title = items
        newItem.done = false
        newItem.parentCategory = selectedCategory
        itemArray.append(newItem)
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operation
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        
        return cell
    }
    

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        saveItems()
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Additem Button Action
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // "what will be after user clicks the Add Item button on our Alert"
            
            
            
            self.appendItems(items: textField.text!)
            
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        
        
        
        do{
            try context.save()
        }catch{
            print("error save is \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error when fetch: \(error)")
        }
        
        tableView.reloadData()
        
    }
    

}

extension ToDoListViewController: UISearchBarDelegate{
    
    //MARK - SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
            
        loadItems(with: request)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}

