//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Phil Madarang on 11/17/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var array = [Category]()
    //var array = ["Grocery", "Christmas"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()


    }
    
    //MARK: - TableView Datasource Methods
        //display categories(table cell) in database
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayItem = array[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = arrayItem.name //add .name
                
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
        //methods to save and load data
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) { //give parameter default value to loadCategories doesn't have to take a parameter

        do {
            array = try context.fetch(request) //set array to quest Item in saved file
        } catch {
            print("Error fetching data from context \(error)")
        }
        
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
                
                let newCategory = Category(context: self.context)  //must update to CoreData DataModel file
                newCategory.name = textField.text! //create to tap into Item property (title)
                                
                self.array.append(newCategory)
                                
                self.saveCategories()
                                
                
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
            destinationVC.selectedCategory = array[indexPath.row] //create 'selectedCategory' property in ToDoListViewController
        }
        
        
    }
    
}
