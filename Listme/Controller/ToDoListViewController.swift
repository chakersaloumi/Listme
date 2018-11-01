//
//  ViewController.swift
//  Listme
//
//  Created by Chaker on 10/23/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Items]()
    
    //let defaults = UserDefaults.standard
    
    //data file path inside of defaults
    let dataFilePath = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
        
        
        //if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
        //itemArray = items
        
      //  }
    }
    

    //Mark - Table View Data source Methods
    
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
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true) // nicer
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "List me", style: .default) { (action) in
            // what happens when button on alert is clicked
            let newItem = Items()
            
            newItem.title = textField.text!
            
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
    
        func saveItems(){
            let encoder = PropertyListEncoder()
            
            do {
                
                let data = try encoder.encode(itemArray)
                
                try data.write(to: dataFilePath!)
                
                
                
            } catch {
                
                print("error encoding item array: \(error)")
            }
            
            self.tableView.reloadData()
        }
    
    
    func loadItems() {
        
        if let data = try?  Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do{
                
            itemArray = try decoder.decode([Items].self , from: data)
                
            }catch{
                
                print("error decoding item array, \(error)")
                
            }
        
    }
     self.tableView.reloadData()
}
    
}
        


