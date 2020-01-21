//
//  NotesTableViewController.swift
//  C0757769_LabAssignment_2_ios
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {

    
    var taskArray = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCoreData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                                    let x = try context.fetch(fetchRequest)
                                    let result = x as! [Tasks]
                                   print(result.count)
                                    
                                let resultcurr = result[indexPath.row]
                                    
                                        
                                     let days = resultcurr.value(forKey: "noOfDays") as! Int16
                                    
                                    resultcurr.setValue(days-1, forKey: "noOfDays")
                                                           
                       
                                    print(indexPath.row )
                                    do
                                    {
                                       try context.save()
                                    }
                                    catch{
                                        
                                        //Something shit has already happened.
                                    }
                                    let newtask = self.taskArray[indexPath.row]
                                    newtask.noOfDays -= 1
                                    
                                                           
                                    
                                            
                                    tableView.reloadData()
                                    
                                }
                                catch
                                {
                                    
                                }
                
                
                                completion(true)
           })

        
           action.backgroundColor = .blue
        
        
        
        // second action for delete
        
        let action1 = UIContextualAction(
               style: .normal,
               title: "Delete Task",
               handler: { (action, view, completion) in

                let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                                       
                             let context = appdelegate.persistentContainer.viewContext
                             let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
                
                 
                 do
                 {
                     let x = try context.fetch(fetchRequest)
                     let result = x as! [Tasks]
                    print(result.count)
                     
                     print("deleting \(result[indexPath.row])")
                     context.delete(result[indexPath.row])
                     //print(zotes)
                     print(indexPath.row )
                     do
                     {
                        try context.save()
                     }
                     catch{
                         
                         //Something shit has already happened.
                     }
                    self.taskArray.remove(at: indexPath.row)
                     tableView.deleteRows(at: [indexPath], with: .fade)
                     tableView.reloadData()
                     
                 }
                 catch
                 {
                     
                 }
                
                completion(true)
           })

        
           action1.backgroundColor = .red
        
        
           let configuration = UISwipeActionsConfiguration(actions: [action1, action])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
    }
    
   override func viewWillAppear(_ animated: Bool) {

        loadFromCoreData()
       tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return taskArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        cell.titleLabel.text = taskArray[indexPath.row].title
        cell.descLabel.text = taskArray[indexPath.row].description
        cell.dateLabel.text = taskArray[indexPath.row].dateString
        cell.daysLeft.text = "\(taskArray[indexPath.row].noOfDays)"
        

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
