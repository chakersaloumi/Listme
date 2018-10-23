//
//  ViewController.swift
//  Listme
//
//  Created by Chaker on 10/23/18.
//  Copyright © 2018 Chaker Saloumi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggoes", "Destroy Demogorgan"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
    }

    //Mark - Table View Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // nicer
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "List me", style: .default) { (action) in
            // what happens when button on alert is clicked
            
           self.itemArray.append(textField.text!)
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData() 
           
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create me"
            textField = alertTextField
        }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
            

    }
    

}

