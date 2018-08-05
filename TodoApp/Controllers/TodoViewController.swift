//
//  ViewController.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-07-31.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController  {
    
    //collection of results that are Item objects
    var todoitems: Results<Item>?
    
    let realm = try! Realm()
    
    //what should happen when variable gets set with new value
    var selectedcategory : Category? {
        didSet{
            loaditems()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoitems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //ternary operator
            //if cell accessorytype is true, set to checkmark, otherwise none
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "no items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoitems?.count ?? 1
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check if todo list items is not nil
        if let item = todoitems? [indexPath.row] {
            do {
                try realm.write {
                    //toggling
                    item.done = !item.done
                }
            } catch {
                print("error saving done status, \(error)")
            }
           
        }
        
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
            
            if let currentcategory = self.selectedcategory {
                do {
                    try self.realm.write {
                        let anitem = Item()
                        anitem.datecreated = Date()
                        anitem.title = textfield.text!
                        currentcategory.items.append(anitem)
                    }
                    
                } catch {
                    print("error saving context, \(error)")
                }
             }
            
       
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - data manipulation methods

    
    //has default parameter aswell that fetches all data
    func loaditems(){

        todoitems = selectedcategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - search bar methods
extension TodoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoitems = todoitems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "datecreated", ascending: true)
        
        tableView.reloadData()
    }
    
    
    //dismissing search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditems()

            //run in foreground
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
