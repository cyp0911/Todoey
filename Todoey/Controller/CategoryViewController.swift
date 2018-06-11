//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yinpeng Chen on 2018-06-08.
//  Copyright © 2018 Yinpeng Chen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // "what will be after user clicks the Add Item button on our Alert"
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
//            self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
            
        }
        
        
        present(alert, animated: true, completion: nil)

        
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCategoryCell", for: indexPath)
        
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        
        return cell
    }
    
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToitems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manupulation Methods
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error save is \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
        
    }


}
