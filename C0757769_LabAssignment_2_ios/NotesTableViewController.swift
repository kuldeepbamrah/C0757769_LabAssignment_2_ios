//
//  NotesTableViewController.swift
//  C0757769_LabAssignment_2_ios
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController, UISearchBarDelegate
{

    
    @IBOutlet weak var searchBAr: UISearchBar!
    @IBOutlet weak var sortBy: UIBarButtonItem!
    var taskArray = [Task]()
    var searchArray = [Task]()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBAr.delegate = self
        //deleteData()
        loadFromCoreData()
    }
   
    
    
    
   override func viewWillAppear(_ animated: Bool) {

        taskArray.removeAll()
        loadFromCoreData()
    print(taskArray.count)
       tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        if isSearch{
            return searchArray.count
        }else
        {
        return taskArray.count
        }   
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        if isSearch{
        cell.descLabel.textColor = UIColor.gray
        cell.dateLabel.textColor = UIColor.gray
        cell.titleLabel.text = searchArray[indexPath.row].title
        cell.descLabel.text = searchArray[indexPath.row].description
        cell.dateLabel.text = searchArray[indexPath.row].dateString
        cell.daysLeft.text = "\(searchArray[indexPath.row].noOfDays)"
        
        if taskArray[indexPath.row].noOfDays == 0
        {
            cell.statusLabel.textColor = UIColor.green
            cell.statusLabel.text = "Completed"
            
        }else
        {
            cell.statusLabel.textColor = UIColor.red
            cell.statusLabel.text = "Incomplete"
            
        }
        
        }
        else{
            cell.descLabel.textColor = UIColor.gray
            cell.dateLabel.textColor = UIColor.gray
            cell.titleLabel.text = taskArray[indexPath.row].title
            cell.descLabel.text = taskArray[indexPath.row].description
            cell.dateLabel.text = taskArray[indexPath.row].dateString
            cell.daysLeft.text = "\(taskArray[indexPath.row].noOfDays)"
            
            if taskArray[indexPath.row].noOfDays == 0
            {
                cell.statusLabel.text = "Completed"
            }else
            {
                cell.statusLabel.text = "Incomplete"
            }
            
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
              let newVC = sb.instantiateViewController(identifier: "editTask") as! EditTaskViewController
            newVC.task = self.taskArray[indexPath.row]
         
       
            
        
              
              navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
       override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // first action for adding day
         let action = UIContextualAction(
               style: .normal,
               title: "Add Day",
               handler: { (action, view, completion) in
                
                let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
                               
                do
                {
                    let fetchedRequest = try context.fetch(fetchRequest)
                    let result = fetchedRequest as! [Tasks]
                    let currResult = result[indexPath.row]
                    let days = currResult.value(forKey: "noOfDays") as! Int16
                    if days <= 0
                    {
                        print("isdfi")
                    }else
                    {currResult.setValue(days-1, forKey: "noOfDays")
                do
                {
                    try context.save()
                }
                catch{
                        print(error)
                    }
                    let currtask = self.taskArray[indexPath.row]
                    currtask.noOfDays -= 1
                    tableView.reloadData()
                }
                    }
                catch
                {
                    print(error)
                }
                completion(true)
           })
        action.backgroundColor = .blue
        
        
        
        // second action for delete
        
        let action1 = UIContextualAction(
               style: .normal,
               title: "Delete",
               handler: { (action, view, completion) in

                let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
                
                do
                 {
                     let fetchedRequest = try context.fetch(fetchRequest)
                     let result = fetchedRequest as! [Tasks]
                     context.delete(result[indexPath.row])
                     do
                     {
                        try context.save()
                     }
                     catch
                     {
                         print(error)
                     }
                    self.taskArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                     
                 }
                 catch
                 {
                     print(error)
                 }
                
                completion(true)
           })

        
           action1.backgroundColor = .red
        
        
           let configuration = UISwipeActionsConfiguration(actions: [action1, action])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
    }
    
    @IBAction func sortBy(_ sender: Any)
    {
        let alert = UIAlertController(title: "Sort Table", message: "Please Select one option", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "By Title", style: .default, handler: {
            action in
           
            self.taskArray.sort(by:  {$0.title.lowercased() < $1.title.lowercased()} )
         
         self.tableView.reloadData()
            
        }))
        
          alert.addAction(UIAlertAction(title: "By Date", style: .default, handler: {
              action in
             
             
             self.taskArray.sort(by: {$0.date < $1.date} )
           
           self.tableView.reloadData()
              
          }))
                              
                              self.present(alert, animated: true)
    }
    func loadFromCoreData()
    {
        
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              
               let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do{
            let results = try context.fetch(fetchRequest)
            if results is [NSManagedObject]
            {
                for result in results as! [NSManagedObject]
                {
                    let title = result.value(forKey: "title") as! String
                    let desc = result.value(forKey: "desc") as! String
                    let days = result.value(forKey: "noOfDays") as! Int16
                    let date = result.value(forKey: "date") as! String
                    let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yyyy"
                  let temp = formatter.date(from: date)
                  let task = Task(title: title, description: desc, noOfDays: Int(days), datae:temp!)
                  
                  self.taskArray.append(task)

                }
            }
        } catch{
            print(error)
        }
                      
        
    }
    func deleteData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                     
        let context = appDelegate.persistentContainer.viewContext
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            
            for managedObjects in results{
                if let managedObjectsData = managedObjects as? NSManagedObject
                {
                    context.delete(managedObjectsData)
                }
            
            }

            
            
        }catch{
            print(error)
        }
        
        
        
    }

   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let filtered = taskArray.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased())}
                
        if filtered.count>0
        {
         //tasks = []
            searchArray = filtered;
            isSearch = true;
        }
        else
        {
         searchArray = self.taskArray
            isSearch = false;
        }
        self.tableView.reloadData();
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true;
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
