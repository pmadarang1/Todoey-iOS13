//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Phil Madarang on 12/1/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let arrayItem = categories?[indexPath.row] //not needed in super class...same for below cell.textLabel...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //cell.textLabel?.text = arrayItem?.name ?? "No Categories Added Yet" //add .name...optional so use nil coalescing operator
        
        cell.delegate = self
                
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion - use realm to delete table cell
            //print("Item Deleted")
            
            //call function to update cell (delete cell)
            self.updateModel(at: indexPath)
            

            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    //to make cell slide all the way to delete
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }


    //function to update cell (delete) when swiped
    func updateModel(at indexPath: IndexPath) {
        
        
        
    }
    
    //MARK: - Generate Random Hex Code Function and Conver to UIColor Methods
    func randomHex() -> String {
      let a = ["1","2","3","4","5","6","7","8","9","A","B","C","C","E","F"]
     
     var s = ""
        for _ in 0 ..< 6 {
            s.append(a.randomElement()!)
        }
        return s
    }
    
    func hexToUIColor(hex: String) -> UIColor {
        
        if hex.count != 6 {
            return UIColor.systemGray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0)
        
    }
    

}

