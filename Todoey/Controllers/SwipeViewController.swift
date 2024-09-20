//
//  SwipeViewController.swift
//  Todoey
//
//  Created by elsayed mansour mahfouz on 1/25/24.

//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController , SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //MARK:- table view data sources methods :
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
          cell.delegate = self
            return cell
    }

     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                                self.updateModel(at: indexPath)
               
                                 action.fulfill(with: .delete)
                                
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-Icon")

            return [deleteAction]
        }
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
         
            return options
        }
    func updateModel( at indexPath : IndexPath ){
        
    }
    }

