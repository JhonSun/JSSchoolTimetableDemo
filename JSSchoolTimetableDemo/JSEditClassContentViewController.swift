//
//  JSEditClassContentViewController.swift
//  JSSchoolTimetableDemo
//
//  Created by jhon.sun on 16/3/7.
//  Copyright © 2016年 jhon.sun. All rights reserved.
//

import UIKit

typealias saveCourseContent = (courseinfo: CourseInfo) -> Void
class JSEditClassContentViewController: UIViewController {

    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var classAddressTextField: UITextField!
    @IBOutlet weak var classTeacherTextField: UITextField!
    
    var indexPath: NSIndexPath?
    var save: saveCourseContent?
    var courseTableInfo: CourseTableInfo?
    var courseInfo: CourseInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        classNameTextField.delegate = self
        classAddressTextField.delegate = self
        classTeacherTextField.delegate = self
        
        if let courseInfoTemp = courseInfo {
            classNameTextField.text = courseInfoTemp.courseName
            classAddressTextField.text = courseInfoTemp.courseAddress
            classTeacherTextField.text = courseInfoTemp.courseTeacher
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveCourseContentAction(sender: AnyObject) {
        let courseName = self.classNameTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        let courseTeacher = self.classTeacherTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        let courseAddress = self.classAddressTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if courseName!.isEmpty {
            print("请输入课程名称")
            return
        }
        if courseAddress!.isEmpty {
            print("请输入上课地址")
            return
        }
        if courseTeacher!.isEmpty {
            print("请输入任课教师")
            return
        }
        
        let defaultContext = NSManagedObjectContext.MR_defaultContext()
        if self.courseInfo == nil {
            self.courseInfo = CourseInfo.MR_createEntityInContext(defaultContext)
        }
        self.courseInfo!.courseName = courseName
        self.courseInfo!.courseTeacher = courseTeacher
        self.courseInfo!.courseAddress = courseAddress
        self.courseInfo!.coursePeriod = self.indexPath?.section
        self.courseInfo!.courseDay = self.indexPath?.item
        self.courseTableInfo = self.courseTableInfo?.MR_inContext(defaultContext)
        self.courseInfo!.course_table = self.courseTableInfo
        defaultContext.MR_saveToPersistentStoreAndWait()
        if self.save != nil {
            self.save!(courseinfo: self.courseInfo!)
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JSEditClassContentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
