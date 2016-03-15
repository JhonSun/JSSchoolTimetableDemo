//
//  JSCourseContentCollectionViewCell.swift
//  JSSchoolTimetableDemo
//
//  Created by jhon.sun on 16/3/7.
//  Copyright © 2016年 jhon.sun. All rights reserved.
//

import UIKit

class JSCourseContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTeacherLabel: UILabel!
    @IBOutlet weak var courseAddressLabel: UILabel!
    
    var courseInfo: CourseInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showDetail(course: CourseInfo) {
        courseInfo = course
        courseNameLabel.text = courseInfo?.courseName
        courseTeacherLabel.text = courseInfo?.courseTeacher
        courseAddressLabel.text = courseInfo?.courseAddress
    }
}
