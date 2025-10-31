//
//  ViewController.swift
//  TodoApp
//
//  Created by                     Nand Parikh on 10/10/25.
//

import UIKit
import CoreData

class ViewController: UITableViewController, UIAlertViewDelegate {
    
    var itemArray: [Item] = []
    var itemText : String = ""
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        print(dataFilePath)
        
        loadItems()
    }
    
    @IBAction func btnAddClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Todo", message: "Add your todo item", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
            
            if let itemText = textField.text {
                
                let newItem = Item(context: self.context)
                newItem.title = itemText
                newItem.done = false
                self.itemArray.append(newItem)
            }
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            textField.placeholder = "Enter your todo item"
            textField = alertTextField
        }
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        itemArray[indexPath.row].done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        //        updateTitle(index: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        saveItems()
    }
    
    //    func updateTitle(index : Int){
    //        var textField = UITextField()
    //
    //        let alert = UIAlertController(title: "Todo", message: "Update Item Name", preferredStyle: .alert)
    //        let okButton = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
    //
    //            self.itemArray[index].setValue(textField.text, forKey: "title")
    //
    //            self.saveItems()
    //        }
    //
    //        alert.addTextField { alertTextField in
    //            textField.placeholder = "Enter your todo item"
    //            textField = alertTextField
    //        }
    //
    //        alert.addAction(okButton)
    //        self.present(alert, animated: true)
    //
    //    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func saveItems(){
        
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()
    ){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching from context \(error)")
        }
        tableView.reloadData()
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
