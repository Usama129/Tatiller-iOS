//
//  AddHolidayVC.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class AddHolidayVC: UIViewController {
    
    var mainVC: MainVC?
    
    @IBOutlet weak var localName: UITextField!
    @IBOutlet weak var englishName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var remarks: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarks!.layer.borderWidth = 1
        remarks!.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        var giveError: Bool = false
        var error: String = ""
        if localName.text!.isEmpty{
            error += "Local Name must be given\n"
            giveError = true
        }
        if englishName.text!.isEmpty {
            error += "English Name must be given\n"
            giveError = true
        }
        if date.text!.isEmpty {
            error += "Date must be provided in an MMMMd format"
            giveError = true
        }
        
        if (giveError){
            showError(title: "Required fields", error: error)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        
        if let x = dateFormatter.date(from: date.text!) {
            if (mainVC?.addHoliday(local_name: localName.text!, english_name: englishName.text!, date: date.text!, remarks: remarks.text, searchQuery: englishName.text!.components(separatedBy: " ")[0]))! {
                    navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
            }
            else {
                showError(title: "Already exists!", error: "A holiday already exists with the local name you entered")
            }
        }
        else {
            showError(title: "Incorrect date format", error: "Your date format does not match the required date format. Enter a month followed by a date e.g July 4. Do not enter a year.")
        }
        
        
    }
    
    func showError(title: String, error: String){
    
        
         let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         self.present(alert, animated: true, completion: nil)

    }
}
