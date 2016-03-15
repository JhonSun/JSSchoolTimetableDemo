//
//  CourseTableInfo+CoreDataProperties.swift
//  
//
//  Created by jhon.sun on 16/3/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CourseTableInfo {

    @NSManaged var courseTableName: String?
    @NSManaged var createDate: NSDate?
    @NSManaged var table_course: NSOrderedSet?

}
