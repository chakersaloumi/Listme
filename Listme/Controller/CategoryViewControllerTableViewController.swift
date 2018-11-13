//
//  CategoryViewControllerTableViewController.swift
//  Listme
//
//  Created by Chaker on 11/8/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllerTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        loadCategory()
    }

    //Mark: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories Yet"
        return cell
        
    }
    //Mark: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    //Mark: - Data Manipulation save or load data
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    
    //Mark: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Categorize me", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
        
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create me"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
 
        
    }
    
    
}
