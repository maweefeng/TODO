//
//  CategoryTableViewController.swift
//  CoreDataDemo
//
//  Created by Alex wee on 2019/1/30.
//  Copyright © 2019年 Alex wee. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
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
            
            let newCategory  = Category(context: self.context)
            if let categoryString = textfield.text{
                
                if categoryString.count > 0{
                    
                    newCategory.name = categoryString
                    self.categories.append(newCategory)
                    self.saveCategory()
                    
                }
                
            }
        
            
            
        }
        vc.addAction(action)
        
        present(vc, animated: true, completion: nil)
        

    }
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        
        let request:NSFetchRequest<Category> = Category.fetchRequest()

        do {
           categories = try context.fetch(request)
        } catch  {
            
        }
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
         performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        
        if segue.identifier == "goToItems" {
            if let indexPath = tableView.indexPathForSelectedRow{
                
                destination.selectedCategory = categories[indexPath.row]
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! GradientTableViewCell
        cell.addGradientColor(colors:[UIColor.rgbColorFromHex(rgb:0x5FBCFF).cgColor,UIColor.rgbColorFromHex(rgb:0xD1EBFF).cgColor], locations: [0.5,1.0], stratPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))

        cell.textLabel?.text  = categories[indexPath.row].name
        
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
