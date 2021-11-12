//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController { //upadated and changed from UIViewController

    //create array to put in to do list...change from let to var to be able to append items to it
    //var array = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    //replace array with array of Item(Data Model)
    var array = [Item]()
    
    //create file path to documents folder...returns array of URLS(need .first)...add plist file to file path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //dataFilePath no longer needed for CoreData but need to print file path to locate file
    
    //create UserDefaults - Persistent Local Data Storage
    //let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //singleton (same as AppDelegate) need to tap into for 'context'
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //create instance of Item(Data Model)...no longer needed since already saved in plist with loadItems()
        /*let newItem = Item()
        newItem.title = "Find Mike"
        array.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        array.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        array.append(newItem3) */
        
        //USER DEFAULTS - not efficient for saving this data. Will implement another option.
        //to load saved data set array = array in user defaults...need to check if nil (put in if let statement)
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //    array = items
        //}
        
        loadItems() //method to load saved data in plist
        
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
        
        //code example to "Delete" data from CoreData...remove item when clicked

//        context.delete(array[indexPath.row]) //deletes from CoreData persistent container...call first before below code
//        array.remove(at: indexPath.row) //only removes cell from current view
        
        
        //add if statement to add checkmark(accessory) to selected cell or deselect/remove checkmark if it exists
        //put below code in 'cellForRowAt' to address checkmark reuseable cell bug
        //if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //} else {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //}
        
        saveItems()
        
        //add reloadData() to fix checkmark not displaying
        //tableView.reloadData() //no need for this since it exists in saveItems()
        
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
                
                let newItem = Item(context: self.context)  //must update to CoreData DataModel file
                newItem.title = textField.text! //create to tap into Item property (title)
                
                newItem.done = false //set to false by default since it's optional...otherwise it's 'nil' and will give error
                
                self.array.append(newItem)
                
                //save new item
                //self.defaults.set(self.array, forKey: "TodoListArray") //replacing user defaults with another method (creating plist file)..see method/function below
                self.saveItems()
                
                //print(self.array)
                
                
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
    
    //MARK: - Model Manipulation Methods (save data, etc.)
    
    //copied 'encoder' code from addButtonPressed action...solves bug of 'item.done' not saving
    
    func saveItems() {
        //let encoder = PropertyListEncoder() //Encoder no longer need for CoreData
        do {
            //let data = try encoder.encode(array)
            //try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        //to add item entered to table cell
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) { //give parameter default value so loadItems doesn't have to take a parameter

        //let request : NSFetchRequest<Item> = Item.fetchRequest() //need to specify the data type " : NSFetchRequest<Item>" //not needed since function already take a parameter with same type
        do {
            array = try context.fetch(request) //set array to quest Item in saved file
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
//        code below will be replaced for CoreData "Read"
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            let decoder = PropertyListDecoder()
//
//            do {
//            array = try decoder.decode([Item].self, from: data)
//            }catch {
//                print("Error decoding data, \(error)")
//            }
//        }
//
//
//    }
    
    
}

//MARK: - Extension to add SearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    //method to reload table view after search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //need to add request to read data being searched
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //add to query data being searched
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //[cd] makes search case/diacritic insensitive
        
        request.predicate = predicate
        
        //sort data that comes back
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor] //make sortDescriptor an array to conform to 'sortDescriptors'
        
        
        //need to fetch data being searched...same as loadItems()
        loadItems(with: request)
        
        //reload tableView
        //tableView.reloadData() //not needed since it is in loadItems()
        
        
        //what data comes back when user clicks search
        print(searchBar.text!)
    }
    
}

