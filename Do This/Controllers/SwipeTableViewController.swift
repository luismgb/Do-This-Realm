//
//  SwipeTableViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/29/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var swipeToDeleteTextDescription: String?
    var swipeToEditTextDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell // swiftlint:disable:this force_cast
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        var actions = [SwipeAction]()
        
        let deleteAction = SwipeAction(style: .destructive, title: swipeToDeleteTextDescription) { _, indexPath in
            self.deleteFromModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        actions.append(deleteAction)
        
        let editAction = SwipeAction(style: .default, title: swipeToEditTextDescription) { (swipeAction, indexPath) in
            // TODO: - Implement editing when user clicks on more after swiping cell
        }
        editAction.image = UIImage(named: "more48x48")
        actions.append(editAction)
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions { // swiftlint:disable:this line_length
        var options = SwipeOptions()
        options.transitionStyle = .border
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteFromModel(at indexPath: IndexPath) {
        // This method is meant to be overriden by subclasses.
    }
    
}
