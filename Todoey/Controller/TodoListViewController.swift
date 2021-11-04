//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController { //upadated and changed from UIViewController

    //create array to put in to do list...change from let to var to be able to append items to it
    //var array = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    //replace array with array of Item(Data Model)
    var array = [Item]()
    
    //create UserDefaults - Persistent Local Data Storage
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //create instance of Item(Data Model)
        let newItem = Item()
        newItem.title = "Find Mike"
        array.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        array.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        array.append(newItem3)
        
        //to load saved data set array = array in user defaults...need to check if nil (put in if let statement)
        //if let items = defaults.array(forKey: "TodoListArray") as? [String] {
        //    array = items
        //}
        
    }


    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayItem = array[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = arrayItem.title //added 'title' since array is of type Item and need to tap into title property
        
        //add code to display/remove checkmark if user taps on cell
        //if arrayItem.done == true {
        //    cell.accessoryType = .checkmark
        //} else {
        //    cell.accessoryType = .none
        //}
        
        //instead of above code...can use Ternary Operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = arrayItem.done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(array[indexPath.row])
        
        //add 'done' property from Item(Data Model)
        array[indexPath.row].done = !array[indexPath.row].done //set 'done' property to opposite value('true')
        
        //add if statement to add checkmark(accessory) to selected cell or deselect/remove checkmark if it exists
        //put below code in 'cellForRowAt' to address checkmark reuseable cell bug
        //if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //} else {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //}
        
        //add reloadData() to fix checkmark not displaying
        tableView.reloadData()
        
        //this removes grey 'selected state' and only flashes grey when cell is tapped
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create local variable for text field so value in text field will be known to action button
        var textField = UITextField()
        
        //add alert with text field to enter item to add to list
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //add dismiss button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item Button
            //print(textField.text ?? "No Text Entered")
            
            
            //add item created in text field and append to list...add validation code later to prevent from adding empty String
            if textField.hasText {
                
                let newItem = Item()
                newItem.title = textField.text! //create to tap into Item property (title)
                
                self.array.append(newItem)
                
                //save new item
                self.defaults.set(self.array, forKey: "TodoListArray")
                print(self.array)
                
                //to add item entered to table cell
                self.tableView.reloadData()
            } else {
                print("No text entered")
            }

        }
        
        //add text field to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        //add action item(button) to alert
        alert.addAction(action)
        //add dismiss button
        alert.addAction(cancel)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
}

