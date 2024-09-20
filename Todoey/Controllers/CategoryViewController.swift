//
//  CategoryViewController.swift
//  Todoey
//
//  Created by elsayed mansour mahfouz on 1/22/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeViewController {

    var categoryArray = [Category]()
    var deletedCategory  : Category!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category .plist")
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // print(dataFilePath)
       loadCategory()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
    }

    //MARK: - tableview Datasources Methods:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let category = categoryArray[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category.name
        if let categoryColor = UIColor(hexString: (category.color ?? "2792FF")){
        cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
//MARK:- tableView delegete methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK:- Add new categories:
       
        @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Todoey Category ", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                self.categoryArray.append(newCategory)
                self.saveCategories(category: newCategory)
                
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new category"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
  
        //MARK: - Data Manipulation Methods:
    func saveCategories(category : Category){
        do{
            try context.save()
        }catch{
            print("Error saving Data \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
        categoryArray = try context.fetch(request)
        }catch{
            print("Error Fetchinf Data\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- Delete Data from Swipe V.C:
    override func updateModel(at indexPath: IndexPath) {
        
        

        if self.categoryArray.count > 0{
            self.deletedCategory  = self.categoryArray[indexPath.row]
            context.delete(deletedCategory)
            self.categoryArray.remove(at: indexPath.row)
        }
    }
  
}

    
   
