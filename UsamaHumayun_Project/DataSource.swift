//
//  DataSource.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataSource {
    var holidays: [Holiday] = []
    
    init() {
        retrieveFromCoreData()
        if holidays.isEmpty {
            retrieveFromJSON()
        }
    }
    
    func retrieveFromJSON() {
        print("Fetching from JSON")
              if let path = Bundle.main.path(forResource: "holidays", ofType: "json") {
                    if let jsonToParse = NSData(contentsOfFile: path) {
                        
                        // https://www.dotnetperls.com/guard-swift
                        guard let json = try? JSON(data: jsonToParse as Data) else {
                            print("Error with JSON")
                            return
                        }
                                                
                        let total = json.count
                    
                        
                        for index in 0..<total {
                 
                            if let remarks = json[index]["remarks"].string, let local_name = json[index]["local_name"].string, let english_name = json[index]["english_name"].string, let date = json[index]["date"].string, let searchQuery = json[index]["searchQuery"].string {
                                appendHoliday(remarks: remarks, local_name: local_name, english_name: english_name, date: date, searchQuery: searchQuery)
                            }
                            else {
                                print("Error occurred during optional unwrapping while fetching from JSON")
                            }
                        }
                    }
                    else {
                        print("NSdata error while fetching from JSON")
                    }
                }
                else {
                    print("NSURL error while fetching from JSON")
                }
       }
    
    func retrieveFromCoreData(){
       print("Fetching from Core Data")
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Holiday")
          
          //3
          do {
            holidays = try managedContext.fetch(fetchRequest) as! [Holiday]
          } catch let error as NSError {
            print("Could not fetch from Core Data. \(error), \(error.userInfo)")
          }
    }
    
    func appendHoliday(remarks: String, local_name: String, english_name: String, date: String, searchQuery: String) -> Bool {
       guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "Holiday",
                                     in: managedContext)!
        
        let holiday = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        let dateFormatter = DateFormatter()
                   
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        // print(dateFormatter.string(from: date)) // December 31
        let formattedDate = dateFormatter.date(from: date)
        
        // 3
        holiday.setValue(remarks, forKeyPath: "remarks")
        holiday.setValue(local_name, forKeyPath: "local_name")
        holiday.setValue(english_name, forKeyPath: "english_name")
        holiday.setValue(formattedDate, forKeyPath: "date")
        holiday.setValue(searchQuery, forKeyPath: "searchQuery")
        
        let newHoliday = holiday as! Holiday
        
        if (checkAlreadyExists(local_name: newHoliday.local_name!)){
            print("Duplicate\n")
        }
        else {
            holidays.append(newHoliday)
            return save()
            
        }
        return false
    }
    
    func checkAlreadyExists(local_name: String) -> Bool {
        for holiday in holidays {
            if holiday.local_name?.lowercased() == local_name.lowercased() {
                return true
            }
        }
        return false
    }
    
    // Method to save the Data in Core Data
    func save() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return false
    }
    
    func removeHoliday(index: Int){
        let holidayToRemove = getHolidayAtIndex(index: index)
        print("Removing " + holidayToRemove.local_name!)
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Holiday")
        
             let result = try? context.fetch(fetchRequest)
                let resultData = result as! [Holiday]
        
                for object in resultData {
                    if object.local_name == holidayToRemove.local_name {
                        context.delete(object)
                    }
                }
        
                do {
                    try context.save()
                    holidays.remove(at: index)
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
        
                }
    }
    
    func getHolidayAtIndex(index: Int) -> Holiday {
        return holidays[index]
    }
    
    func getNumberOfHolidays() -> Int {
        return holidays.count
    }
    
    func sortByDate(){
        holidays = holidays.sorted(by: { $0.date!.compare($1.date!) == .orderedAscending })
    }
    
    func deleteAll(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        holidays.removeAll()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Holiday")
              
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Holiday]
              
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
