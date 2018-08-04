//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-08-03.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadcategories()

    }
    
    
    //MARK: - tableview datasource methods
    //display all categories inside persistent container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    //triggered just before we performed segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedcategory = categories[indexpath.row]
        }
    }
    
    
    
    
    //MARK: - data manipulation methods
    //save data and load data (CRUD)
    
    func saveCategories(){
        do {
            try context.save()
            
        } catch {
            print("error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //has default parameter aswell that fetches all data
    func loadcategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new category"
            
            textfield = alertTextField

        }
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            //category is an object of type NSManagedObeject, which are rows inside table, and every row is an nsmanagedobject
            let Acategory  = Category(context: self.context)
        
            //force unwrap text because text property will never equal nil
            Acategory.name = textfield.text!
        
            self.categories.append(Acategory)
        
            self.saveCategories()
    
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
}
    
    
}


