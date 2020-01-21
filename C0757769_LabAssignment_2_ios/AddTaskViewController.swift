//
//  AddTaskViewController.swift
//  C0757769_LabAssignment_2_ios
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
 import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var numberOfDaysLabel: UITextField!
    @IBOutlet weak var descTextField: UITextView!
    
    var taskArray : [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //deleteData()
        loadFromCoreData()
        print(taskArray.count)
    
        
       

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBtn(_ sender: Any)
    {
        let title = titleLabel.text
        let days =  Int(numberOfDaysLabel.text!)
        let desc = descTextField.text
        
       let task = Task(title: title!, description: desc!, noOfDays: days!, datae: Date())
        self.taskArray.append(task)
        print(task.dateString)
        saveToCoreData()
    }
    
    func saveToCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
        
        newTask.setValue(titleLabel.text, forKey: "title")
        newTask.setValue(Int16(numberOfDaysLabel.text!), forKey: "noOfDays")
        newTask.setValue(descTextField.text, forKey: "desc")
        newTask.setValue(Date().dateformatter(), forKey: "date")
        
        
        do
                   {
                        try context.save()
                       print(newTask, "is saved")
                   }catch
                   {
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
    
    func loadFromCoreData()
      {
          
        if taskArray.count != 0
        {
            deleteData()
        }

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
