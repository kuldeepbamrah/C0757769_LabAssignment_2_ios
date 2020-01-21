//
//  Task.swift
//  C0757769_LabAssignment_2_ios
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation

class Task
{
    
    var title : String
    var description : String
    var noOfDays : Int
    //var currDate : Int64
    var date : Date
    var dateString : String
    
    
    internal init(title: String,description: String,noOfDays : Int, datae : Date  )
    {
        self.title = title
        self.description = description
        self.noOfDays = noOfDays
        self.date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.dateString = formatter.string(from: date)
        
    }
    
    internal init()
    {
        self.title = String()
        self.description = String()
        self.noOfDays = Int()
        //var currDate : Int64
        self.date =  Date()
        self.dateString = String()
        
    }
    
    
    
}
extension Date
{
    
    func dateformatter() -> String {
        let dateFormatterPrint=DateFormatter()
        dateFormatterPrint.dateFormat="dd/MM/yyyy"
        let formattedDate = dateFormatterPrint.string(from: self)
        return formattedDate
        
    }
    
    
}
