//
//  CourseInfo+CoreDataProperties.swift
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

extension CourseInfo {

    @NSManaged var courseAddress: String?
    @NSManaged var courseDay: NSNumber?
    @NSManaged var courseName: String?
    @NSManaged var coursePeriod: NSNumber?
    @NSManaged var courseTeacher: String?
    @NSManaged var course_table: CourseTableInfo?

}
