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
    
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(datafilepath)
        
        //load items from item.plist instead of defaults
        loaditems()
        
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
        
        saveitems()
        
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
            
            self.saveitems()

        }
        
      
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - data manipulation methods (encode and decode)
    //we are encoding itemarr (an array of custom objects) into data that can be written in plist
    //then when we need data back, we use plist decoder to take out data in form of array of items
    
    func saveitems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemarr)
            try data.write(to: datafilepath!)
            
        } catch {
            print("error in encoding item array. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loaditems(){
        if let data = try? Data(contentsOf: datafilepath!){
            let decoder = PropertyListDecoder()
            
            do {
                //decode data from datafilepath
                itemarr = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding array, \(error)")
            }
         
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
 

}

