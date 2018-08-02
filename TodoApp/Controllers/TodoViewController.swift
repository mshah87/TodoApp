//
//  ViewController.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-07-31.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    //turn itemarr into an array of Item objects
    var itemarr = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let newitem = Item()
        newitem.title = "get shoes"
        itemarr.append(newitem)
        
        let newitem2 = Item()
        newitem2.title = "buy food"
        itemarr.append(newitem2)
        
        let newitem3 = Item()
        newitem3.title = "get shirt"
        itemarr.append(newitem3)
        
        if let items = defaults.array(forKey: "todoarr") as? [Item] {
            itemarr = items
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemarr[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //if cell accessorytype is true, set to checkmark, otherwise none
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemarr.count
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemarr[indexPath.row])
        
        //sets done property to its opposite, shorter way than if else statements
        itemarr[indexPath.row].done = !itemarr[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
            textfield = alertTextField
        }
        
        //the button ur gonna press
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen when user presses add button on the alert
            
            let anitem = Item()
            
            //force unwrap text because text property will never equal nil
            anitem.title = textfield.text!
        
            self.itemarr.append(anitem)
            
            //save updated itemarr to defaults
            self.defaults.set(self.itemarr, forKey: "todoarr")
            
            self.tableView.reloadData()

        }
        
      
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
 

}

