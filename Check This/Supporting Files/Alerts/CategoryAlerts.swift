//
//  CategoryAlerts.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

struct CategoryAlerts {
    
    // MARK: - Alerts Methods For CategoryVC
    
    /// Presents an alert to add a new category.
    static func presentAlertToAddNewCategory(from categoryVC: CategoryVC) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addCategoryAction = UIAlertAction(title: "Add", style: .default) { _ in
            if !textField.text!.isEmpty {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colorHexValue = categoryVC.differentCategoryColorHex()
                categoryVC.save(newCategory)
                categoryVC.setTableViewAppearance()
                categoryVC.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addCategoryAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Category Name"
            alertTextField.autocorrectionType = .yes
        }
        categoryVC.present(alert, animated: true)
    }
    
    /// Returns an UIAlertController to edit a category.
    static func editCategoryAlertController(from categoryVC: CategoryVC, at indexPath: IndexPath) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editNameAction = CategoryAlerts.editCategoryNameAction(from: categoryVC, at: indexPath)
        let editColorAction = CategoryAlerts.editCategoryColorAction(from: categoryVC)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            guard let cell = categoryVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(categoryVC)
        }
        
        alertController.addAction(editNameAction)
        alertController.addAction(editColorAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = categoryVC.view
            popoverController.sourceRect = CGRect(x: categoryVC.view.bounds.midX, y: categoryVC.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        return alertController
    }
    
    /// Returns a UIAlertAction to edit a categorie's name.
    static func editCategoryNameAction(from categoryVC: CategoryVC, at indexPath: IndexPath) -> UIAlertAction {
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { (_) in
            let editNameAlertController = CategoryAlerts.categoryEditNameAlertController(on: categoryVC, at: indexPath)
            categoryVC.present(editNameAlertController, animated: true)
        }
        return editNameAction
    }
    
    /// Returns a UIAlertAction to edit a categorie's color.
    static func editCategoryColorAction(from categoryVC: CategoryVC) -> UIAlertAction {
        let editColorAction = UIAlertAction(title: "Change Color", style: .default) { (_) in
            categoryVC.performSegue(withIdentifier: "goToColorPickerVC", sender: categoryVC)
        }
        return editColorAction
    }
    
    /// Returns a UIAlertController used to edit a categorie's name.
    static func categoryEditNameAlertController(on categoryVC: CategoryVC, at indexPath: IndexPath) -> UIAlertController {
        let categoryAtIndexPath = categoryVC.categories![indexPath.row]
        guard let cell = categoryVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Edit Category Name:", message: nil, preferredStyle: .alert)
        
        let editCategoryNameAction = UIAlertAction(title: "Save", style: .default) { (_) in
            categoryVC.edit(category: categoryAtIndexPath, newName: textField.text!)
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(categoryVC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(categoryVC)
        }
        
        alertController.addAction(editCategoryNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = categoryAtIndexPath.name
            alertTextField.autocorrectionType = .yes
        }
        
        return alertController
    }
    
}
