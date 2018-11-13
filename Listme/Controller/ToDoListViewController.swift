//
//  ViewController.swift
//  Listme
//
//  Created by Chaker on 10/23/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var currentDate = Date()
    var itemArray: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
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
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }

        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            do{
            try realm.write {
               // realm.delete(item) // deletes the item
                item.done = !item.done
            }
            } catch{
                print("error updating state of task: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) // nicer
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item to the list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "List me", style: .default) { (action) in
            // what happens when button on alert is clicked
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("error adding items: \(error)")
                    }
                
                
            }
 
         //   self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
            
            alert.addTextField { (alertTextField) in
                
                alertTextField.placeholder = "Create me"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            
        }
    //Mark: - Model Manipulation Methods
    
//    func save(item: Item){
//            do {
//                try realm.write {
//                    realm.add(item)
//                }
//            } catch {
//                print("Error saving context: \(error)")
//
//            }
//            tableView.reloadData()
//        }
    
    
    func loadItems() { // with is an external paramater and request is an internal parameter, adding default value in case no parameter is given
        
        
            itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest() // specifying type of request, already creating in arguments
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data from context: \(error)")
//        }
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
       

    }
    
 
    
}
//Mark: - SearchBar Methods

extension ToDoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)// no need to call load items after sorting
        tableView.reloadData() // because we are updating date
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // nspredicate language : %@ is the value that will be passed in
//        // cd is case and diac insensitive
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

//        loadItems(with: request, predicate: predicate)

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



