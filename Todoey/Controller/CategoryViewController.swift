//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Phil Madarang on 11/17/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() //initialize Realm
    
    //var array = [Category]()
    var categories: Results<Category>? //created this to make loadCategories variable valid...make optional and use nil coalescing operator in tableview numberofrowsinsection
    //var array = ["Grocery", "Christmas"]
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //not need for Realm

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()


    }
    
    //MARK: - TableView Datasource Methods
        //display categories(table cell) in database
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //array is optional 'Result'
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayItem = categories?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = arrayItem?.name ?? "No Categories Added Yet" //add .name...optional so use nil coalescing operator
                
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
        //methods to save and load data
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
    
        categories = realm.objects(Category.self) //declare above with type 'Result' to make categories global variable
        
        //code below not need...applicable to CoreData only
        //do {
        //    array = try context.fetch(request) //set array to quest Item in saved file
        //} catch {
        //    print("Error fetching data from context \(error)")
        //}
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create local variable for text field so value in text field will be known to action button
        var textField = UITextField()
        
        //add alert with text field to enter item to add to list
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //add dismiss button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            
            //add item created in text field and append to list...add validation code later to prevent from adding empty String
            if textField.hasText {
                
                let newCategory = Category()  //no need for context from CoreData
                newCategory.name = textField.text! //create to tap into Item property (title)
                                
                //self.array.append(newCategory) //not needed since 'Results' is an auto updating container
                                
                self.save(category: newCategory) //need to fix method and remove 'context' from CoreData
                                
                
            } else {
                print("No text entered")
            }

        }
        
        //add text field to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        //add action item(button) to alert
        alert.addAction(action)
        //add dismiss button
        alert.addAction(cancel)
        
        //show alert
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when category is selected, segue to ToDoListViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //need to prepare for segue and load only items associated with selected category
        let destinationVC = segue.destination as! TodoListViewController
        
        //get 'Category' that corresponds to the selected cell...can be optional so put in 'if let'
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] //create 'selectedCategory' property in ToDoListViewController...add as optional
        }
        
        
    }
    
}
