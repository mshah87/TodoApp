//
//  ViewController.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-07-31.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var itemarr = ["buy shoes", "get books", "hockey stick"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "todoarr") as? [String] {
            itemarr = items
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemarr[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemarr.count
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemarr[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            //force unwrap text because text property will never equal nil
            self.itemarr.append(textfield.text!)
            
            //save updated itemarr to defaults
            
            self.defaults.set(self.itemarr, forKey: "todoarr")
            
            self.tableView.reloadData()

        }
        
      
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
 

}

