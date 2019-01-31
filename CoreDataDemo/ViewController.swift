//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var selectedCategory : Category?
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArr:[Item] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
            
            let newItem  = Item(context: self.context)
            
            newItem.title = textfield.text
            newItem.parentCatogory = self.selectedCategory
            self.itemArr.append(newItem)
            self.saveItem()
            
    
        }
        vc.addAction(action)
        
        present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func saveItem()  {
        do {
            
            try context.save()
        } catch  {
            
        }
        self.tableView.reloadData()
        
        
    }
    
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil)  {
        
        let categoryPredicate = NSPredicate(format: "parentCatogory.name MATCHES %@", selectedCategory!.name!)
        
        if let addiationPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addiationPredicate])
            
            
        }else{
            
             request.predicate = categoryPredicate
        }
        
        
        do {
            itemArr = try context.fetch(request)
        } catch  {
            
        }
        if itemArr.count > 0 {
            
            tableView.reloadData()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ViewController : UITableViewDelegate{
    
    
    
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = UITableViewCell()
        cell = tableView .dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row].title
        return cell
        
        
    }
    
    
  
    
    
    
}

extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)

        self.loadItems(with: Item.fetchRequest(), predicate: predicate)
        
      
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
