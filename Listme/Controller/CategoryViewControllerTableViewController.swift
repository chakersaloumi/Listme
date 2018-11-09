//
//  CategoryViewControllerTableViewController.swift
//  Listme
//
//  Created by Chaker on 11/8/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    //Mark: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    //Mark: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //Mark: - Data Manipulation save or load data
    func saveCategory(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
       let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //Mark: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Categorize me", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create me"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
 
        
    }
    
   
    
    
    
    
    
    
}
