//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class TodoListController: UIViewController {

    var selectedCategory : Category?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try!Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems:Results<Item>?
    override func viewWillDisappear(_ animated: Bool) {
        guard let originColour = UIColor(hexString: "1D9BF6") else {
            fatalError()
        }
        navigationController?.navigationBar.barTintColor = originColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:FlatWhite()]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colour = selectedCategory?.colour {
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else{
                fatalError("导航栏不存在")
            }
            if let navBarColor = UIColor(hexString: colour){
            
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        tableView.separatorStyle = .none
    }
    
    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        
        let vc = UIAlertController(title: "创建新事项", message: "", preferredStyle: UIAlertControllerStyle.alert)

        var textfield = UITextField()

        vc.addTextField { (alertTextField) in
            alertTextField.placeholder = "新项目名称"
            textfield = alertTextField
        }
        let action = UIAlertAction(title: "添加", style: .default) { (action) in

            guard (textfield.text?.count)! > 0 else {
                
                return
            }
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
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
}

extension TodoListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView .dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! SwipeTableViewCell
        
        if let todoItem = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = todoItem.title
            cell.accessoryType = todoItem.done == true ? .checkmark : .none
            cell.delegate = self
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((todoItems?.count)!)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)

            }

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


extension TodoListController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "删除") { (action, indexPath) in
            
            if let todoItemSelectedDelete = self.todoItems?[indexPath.row]{
                
                do{
                    try self.realm.write {
                        self.realm.delete(todoItemSelectedDelete)
                    }
                }catch{
                    
                }
            }
            print("item被删除")
        }
        deleteAction.image = UIImage(named: "delete");
        
        return [deleteAction]
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    
    
    
    
    
}

