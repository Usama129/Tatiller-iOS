//
//  MainVC.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTable: UITableView!
    
    let mDataSource = DataSource()
    
    var deleteHolidayIndexPath: IndexPath?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mDataSource.getNumberOfHolidays()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
              
        // Get the Holiday for this index
        let holiday = mDataSource.getHolidayAtIndex(index: indexPath.row)
              
        cell.textLabel?.text = holiday.local_name
        
        let dateFormatter = DateFormatter()
               
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        // print(dateFormatter.string(from: date)) // December 31
        
        if let holidayDate = holiday.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: holidayDate)
        }
        else {
            cell.detailTextLabel?.text = ""
        }
              
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "view", sender: mDataSource.getHolidayAtIndex(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteHolidayIndexPath = indexPath
            let holidayToDelete = mDataSource.getHolidayAtIndex(index: indexPath.row)
            confirmDelete(holiday: holidayToDelete.local_name!)
            }
    }
    
    func confirmDelete(holiday: String) {
        let alert = UIAlertController(title: "Delete Holiday", message: "Are you sure you want to delete \(holiday)?", preferredStyle: .actionSheet)
     
        var DeleteAction: UIAlertAction
        
        if holiday == "all holidays" {
            DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteAllHolidays)
        }
        else {
            DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteHoliday)
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteHoliday)
    
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
    
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteHoliday(alertAction: UIAlertAction!) -> Void {
            if let indexPath = deleteHolidayIndexPath {
                mDataSource.removeHoliday(index: indexPath.row)
                // Note that indexPath is wrapped in an array:  [indexPath]
                myTable.deleteRows(at: [indexPath], with: .automatic)
                deleteHolidayIndexPath = nil
                myTable.reloadData()
            }
        }
    
    func handleDeleteAllHolidays(alertAction: UIAlertAction!) -> Void {
        mDataSource.deleteAll()
        myTable.reloadData()
    }
    
    func cancelDeleteHoliday(alertAction: UIAlertAction!) {
        deleteHolidayIndexPath = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mDataSource.sortByDate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        myTable.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:))))
     
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer? = nil) {
        confirmDelete(holiday: "all holidays")
    }
    
    func addHoliday(local_name: String, english_name: String, date: String, remarks: String, searchQuery: String) -> Bool {
        let check = mDataSource.appendHoliday(remarks: remarks, local_name: local_name, english_name: english_name, date: date, searchQuery: searchQuery)
        myTable.reloadData()
        return check
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            if let destination = segue.destination as? AddHolidayVC {
                destination.mainVC = self
            }
        }
        else if segue.identifier == "view" {
            if let destination = segue.destination as? ViewHolidayVC {
                destination.thisHoliday = sender as? Holiday
                destination.navController = self.navigationController!
            }
        }
    }
}

