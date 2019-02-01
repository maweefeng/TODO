//
//  CategoryTableViewController.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.view.addSubview(refreshControl!)
        
        

    }
    
     @objc  func refresh()  {
        
        DispatchQueue.global().asyncAfter(deadline: .now()+1, execute: {
            DispatchQueue.main.async(execute: {
                self.refreshControl?.endRefreshing()
                
            })

            
        })
   
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let vc = UIAlertController(title: "创建新分类", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        var textfield = UITextField()
        
        vc.addTextField { (alertTextField) in
            alertTextField.placeholder = "分类名称"
            textfield = alertTextField
        }
        let action = UIAlertAction(title: "添加", style: .default) { (action) in
            
            let newCategory  = Category()
            if let categoryString = textfield.text{
                
                if categoryString.count > 0{
                    
                    newCategory.name = categoryString
                    newCategory.colour = UIColor.randomFlat.hexValue()
                    self.save(category: newCategory)
                    
                }
                
            }
        
            
            
        }
        vc.addAction(action)
        
        present(vc, animated: true, completion: nil)
        

    }
    
    func save(category:Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
         performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListController
        
        if segue.identifier == "goToItems" {
            if let indexPath = tableView.indexPathForSelectedRow{
                
                destination.selectedCategory = categories?[indexPath.row]
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        
        cell.delegate = self
        
        if let colour = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6") {
            cell.backgroundColor = colour
            
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            
        }


        cell.textLabel?.text  = categories?[indexPath.row].name ?? "没有任何的类别"
                
        cell.selectionStyle = .none
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CategoryViewController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "删除") { (action, indexPath) in
            
            if let category = self.categories?[indexPath.row]{
                
                do{
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                }catch{
                    
                }
            }
            print("类别被删除")
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
