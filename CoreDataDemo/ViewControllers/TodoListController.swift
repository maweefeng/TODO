//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListController: UIViewController {

    var selectedCategory : Category?
    
    let realm = try!Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems:Results<Item>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        
        let vc = UIAlertController(title: "创建新事项", message: "", preferredStyle: UIAlertControllerStyle.alert)

        var textfield = UITextField()

        vc.addTextField { (alertTextField) in
            alertTextField.placeholder = "新项目名称"
            textfield = alertTextField
        }
        let action = UIAlertAction(title: "添加", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    
                }
                self.tableView.reloadData()
            }
            
      
            


        }
        vc.addAction(action)

        present(vc, animated: true, completion: nil)


        
    }
    
    
    func loadItems()  {

  
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
        
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension TodoListController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("saved item satus failed")
            }
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TodoListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = UITableViewCell()
        cell = tableView .dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            
            cell.textLabel?.text = "没有代办事项"

        }
        return cell
        
        
    }
    
    
    
    
    
    
}

extension TodoListController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0  {
            loadItems()
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
