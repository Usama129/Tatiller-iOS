//
//  ViewHolidayVC.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class ViewHolidayVC: UIViewController {
    
    var thisHoliday: Holiday?
    
    var navController: UINavigationController?
    
    @IBOutlet weak var englishName: UILabel!
    @IBOutlet weak var remarks: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = thisHoliday?.local_name
        englishName.text = thisHoliday?.english_name
        remarks.text = thisHoliday?.remarks
    }
    
    @IBAction func searchOnline(_ sender: Any) {
   
        let vc = storyboard!.instantiateViewController(withIdentifier: "imagesVC") as! ImagesVC //your view controller
        
        imageDataSource.populateFromUnsplash(query: thisHoliday!.searchQuery!) { (response) in
            
            vc.imageURLs = response
            vc.title = self.thisHoliday?.local_name
            self.navController!.pushViewController(vc, animated: true)
        }
       
    }
    
}
