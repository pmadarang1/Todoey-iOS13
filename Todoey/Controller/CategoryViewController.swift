//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Phil Madarang on 11/17/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//import SwipeCellKit //not needed since using SwipeTableViewController

class CategoryViewController: SwipeTableViewController { //UITableViewController -- removed...will inherit from SwipeTableViewController instead
    
    let realm = try! Realm() //initialize Realm
    
    //var array = [Category]()
    var categories: Results<Category>? //created this to make loadCategories variable valid...make optional and use nil coalescing operator in tableview numberofrowsinsection
    //var array = ["Grocery", "Christmas"]
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //not need for Realm

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        
        //tableView.rowHeight = 80.0 //move to SwipeTableViewController instead to have item cells same height


    }
    
    //MARK: - TableView Datasource Methods
        //display categories(table cell) in database
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //array is optional 'Result'
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayItem = categories?[indexPath.row]
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = arrayItem?.name ?? "No Categories Added Yet" //add .name...optional so use nil coalescing operator
        
        //cell.delegate = self
                
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
    
    
    //MARK:- Delete Data from Swipe Action
    
    //use override func of updateModel
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            
            //tableView.reloadData() //not needed if method to add 'slide delete all the way' added
            
        }
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

//MARK:- SwipeCellKit Delegate Methods - moved to SwipeTableViewController to create super class

//extension CategoryViewController: SwipeTableViewCellDelegate {
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion - use realm to delete table cell
//            //print("Item Deleted")
//            
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//                
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                } catch {
//                    print("Error deleting category, \(error)")
//                }
//                
//                //tableView.reloadData() //not needed if method to add 'slide delete all the way' added
//
//            }
//            
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//    
//    //to make cell slide all the way to delete
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        //options.transitionStyle = .border
//        return options
//    }
//
//    
//
//}
