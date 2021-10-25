//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController { //upadated and changed from UIViewController

    //create array to put in to do list
    let array = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }


    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayItem = array[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = arrayItem
        
        return cell
    }
    
    
}

