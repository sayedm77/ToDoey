//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework
class TodoListViewController:  SwipeViewController {

    var itemArray = [Item]()
  
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category?{
        didSet{
             loadItems()
            
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item .plist")
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
       
    }
    override func viewWillAppear(_ animated: Bool) {
         if let colorHex = selectedCategory?.color{
            title = selectedCategory!.name
           
                   guard let navBar = navigationController?.navigationBar else{ fatalError("navigation controller does not exist")
                       
                   }
            if let navBarColor = UIColor(hexString: colorHex){
              navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
             searchBar.barTintColor = navBarColor
            }}
    }

    //MARK: -  Table DataResources


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        if let color = UIColor.init(hexString: (selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray.count)){
              cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
        }
      
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    //MARK: -  TableView Delegets:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        let item = itemArray[indexPath.row]
//        context.delete(item)
//        itemArray.remove(at: indexPath.row)
       item.done = !item.done
        safeItems(item: item)
         tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: -  add New Items:
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.safeItems(item: newItem)
       
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
     
    func safeItems(item : Item) {
       
                   do{
                   try context.save()
                   }catch{
                       print("Error saving context\(error)")
                   }
        
    }

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), with predicate : NSPredicate? = nil){
        do{
            let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            if let additionalpredicate = predicate{
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate , additionalpredicate])
            }else{
                request.predicate = categorypredicate
            }
       
       itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
         var item = itemArray[indexPath.row]
        if self.itemArray.count > 0 {
            item  = self.itemArray[indexPath.row]
            context.delete(item)
            self.itemArray.remove(at: indexPath.row)
             
    }
        
    }
    }


// MARK: - Search Bar Methods:

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest <Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request , with : predicate)
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
