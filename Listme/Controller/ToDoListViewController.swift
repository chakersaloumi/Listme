//
//  ViewController.swift
//  Listme
//
//  Created by Chaker on 10/23/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // tapping into AppDelegate class to get persistent container
    
    //let defaults = UserDefaults.standard
    
    //data file path inside of defaults
    let dataFilePath = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
       
        //if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
        //itemArray = items
        
      //  }
    }
    

    //Mark: - Table View Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
     
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true) // nicer
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item to the list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "List me", style: .default) { (action) in
            // what happens when button on alert is clicked
            
     
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
           self.itemArray.append(newItem)
            
            
            
         //   self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
            
            
        }
            
            alert.addTextField { (alertTextField) in
                
                alertTextField.placeholder = "Create me"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            
        }
    //Mark: - Model Manipulation Methods
        func saveItems(){
        
            do {
               try context.save()
            } catch {
                print("Error saving context: \(error)")
               
            }
            
            tableView.reloadData()
        }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) { // with is an external paramater and request is an internal parameter, adding default value in case no parameter is given
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest() // specifying type of request, already creating in arguments
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context: \(error)")
        }
        
        tableView.reloadData()

    }
    
 
    
}
//Mark: - SearchBar Methods

extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // nspredicate language : %@ is the value that will be passed in
        // cd is case and diac insensitive
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
    
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems() // default request to fetch all items
            
            DispatchQueue.main.async { // remove keyboard and me this function run on main thread
            searchBar.resignFirstResponder()
            }
            
        }
    }
}
        


