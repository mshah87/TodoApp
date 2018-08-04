//
//  ViewController.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-07-31.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController  {
    
    //turn itemarr into an array of Item objects
    var itemarr = [Item]()
    
    //what should happen when variable gets set with new value
    var selectedcategory : Category? {
        didSet{
            loaditems()

        }
    }
    
    //we're tapping into shared singleton object which corresponds to current app as an object
    //context is pretty much a temporary area where u might create, read, update, or destroy data in databases
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
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
        
        //first remove nsmanagedobject from context
//        context.delete(itemarr[indexPath.row])
//        itemarr.remove(at: indexPath.row)
//
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
            
            //Item is an object of type NSManagedObeject, which are rows inside table, and every row is an nsmanagedobject
            let anitem = Item(context: self.context)
            
            //force unwrap text because text property will never equal nil
            anitem.title = textfield.text!
            
            anitem.done = false
            anitem.parentCategory = self.selectedcategory
        
            self.itemarr.append(anitem)
            
            self.saveitems()

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - data manipulation methods

    func saveitems(){
        do {
           try context.save()
            
        } catch {
            print("error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //has default parameter aswell that fetches all data
    func loaditems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedcategory!.name!)
        
        //make sure it is not nil
        if let additionpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionpredicate])
        } else {
            request.predicate = categorypredicate
        }

        do {
          itemarr = try context.fetch(request)
        } catch {
            print("error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - search bar methods
extension TodoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //fetch results in form of item
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loaditems(with: request, predicate: predicate)
        
    }
    
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
