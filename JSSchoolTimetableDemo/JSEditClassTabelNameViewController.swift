//
//  JSEditClassTabelNameViewController.swift
//  JSSchoolTimetableDemo
//
//  Created by jhon.sun on 16/3/8.
//  Copyright © 2016年 jhon.sun. All rights reserved.
//

import UIKit

class JSEditClassTabelNameViewController: UIViewController {

    @IBOutlet weak var tableNameTextField: UITextField!
    var courseTable: CourseTableInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableNameTextField.delegate = self
        
        if let courseTableTemp = courseTable {
            tableNameTextField.text = courseTableTemp.courseTableName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClassTableAction(sender: AnyObject) {
        let tableName = self.tableNameTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if tableName!.isEmpty {
            print("请输入课程表名");
            return
        }
        
        let defaultContext = NSManagedObjectContext.MR_defaultContext()
        if self.courseTable == nil {
            self.courseTable = CourseTableInfo.MR_createEntityInContext(defaultContext)
        } else {
            self.courseTable = self.courseTable!.MR_inContext(defaultContext)
        }
        self.courseTable!.courseTableName = self.tableNameTextField!.text
        self.courseTable!.createDate = NSDate()
        defaultContext.MR_saveToPersistentStoreAndWait()
        self.performSegueWithIdentifier("editClassTableSegueIdentifier", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editClassTableSegueIdentifier" {
            let editCourseTableContentVC = segue.destinationViewController as! JSEditSchoolTimeViewController
            editCourseTableContentVC.courseTable = self.courseTable!
        }
    }

}

extension JSEditClassTabelNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
