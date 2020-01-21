//
//  EditTaskViewController.swift
//  C0757769_LabAssignment_2_ios
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {

    var taskArray = [Task]()
    var task = Task()
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var noOfDays: UITextField!
    @IBOutlet weak var descLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = task.title
        noOfDays.text = "\(task.noOfDays)"
        descLabel.text = task.description
        
        loadFromCoreData()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBtn(_ sender: Any)
    {
        print(taskArray.count)
        let title = titleLabel.text ?? ""
        let desc = descLabel.text ?? ""
        let days = Int16(noOfDays.text ?? "0") ?? 0
        
        let task = Task(title: title, description: desc, noOfDays: Int(days), datae: Date())
        
        self.deleteSelectedTask()
        self.taskArray.removeAll()
        loadFromCoreData()
        taskArray.append(task)
        print(taskArray.count)
        saveToCoreData()
        
    }
    
    
    
    
    func deleteSelectedTask()
    {
        
                  // create an instance of app delegate
                  
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  
                   let context = appDelegate.persistentContainer.viewContext
               
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")

               fetchRequest.returnsObjectsAsFaults = false

               
               let predicate = NSPredicate(format: "title=%@", "\(task.title)")
               fetchRequest.predicate = predicate
               if let result = try? context.fetch(fetchRequest) {
                   for object in result {
                       context.delete(object as! NSManagedObject)
                   }
               }
              
                              
                                 do
                                 {
                                    try context.save()
                                 }
                                 catch{
                                     
                                     print("error")
                                 }
        
    }
    func saveToCoreData()
    {
        //deleteData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
        for i in taskArray
        {
            newTask.setValue(i.title, forKey: "title")
            newTask.setValue(Int16(i.noOfDays), forKey: "noOfDays")
            newTask.setValue(i.description, forKey: "desc")
            newTask.setValue(i.dateString, forKey: "date")
        
        
        do
                   {
                        try context.save()
                       print(newTask, "is saved")
                   }catch
                   {
                       print(error)
                   }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
