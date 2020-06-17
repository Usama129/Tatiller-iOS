//
//  Holiday+CoreDataProperties.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 10.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension Holiday {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Holiday> {
        return NSFetchRequest<Holiday>(entityName: "Holiday")
    }

    @NSManaged public var date: Date?
    @NSManaged public var english_name: String?
    @NSManaged public var local_name: String?
    @NSManaged public var remarks: String?
    @NSManaged public var searchQuery: String?

}
