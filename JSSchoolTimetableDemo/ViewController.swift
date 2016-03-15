//
//  ViewController.swift
//  JSSchoolTimetableDemo
//
//  Created by jhon.sun on 16/2/23.
//  Copyright © 2016年 jhon.sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var timeList: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self;
        myTableView.dataSource = self;
        
        let contentList = CourseInfo.MR_findAll()
        print(contentList)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timeList  = CourseTableInfo.MR_findAll()!
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTimeTableAction(sender: AnyObject) {
        self.performSegueWithIdentifier("addOrEditTimeTableSegueIdentifier", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lookCourseTableSegueIdentifier" {
            let editCourseTableVC = segue.destinationViewController as! JSEditSchoolTimeViewController
            editCourseTableVC.isCanSelect = false
            editCourseTableVC.courseTable = sender as? CourseTableInfo
        } else if segue.identifier == "addOrEditTimeTableSegueIdentifier" {
            let editCourseTableNameVC = segue.destinationViewController as! JSEditClassTabelNameViewController
            editCourseTableNameVC.courseTable = sender as? CourseTableInfo
        }
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        cell!.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        let tableInfo = timeList[indexPath.row] as! CourseTableInfo
        cell!.textLabel!.text = tableInfo.courseTableName
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("lookCourseTableSegueIdentifier", sender: timeList[indexPath.row])
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let deleteCourseTable = timeList[indexPath.row] as! CourseTableInfo
            MagicalRecord.saveWithBlock({ (defaultContext) -> Void in
                deleteCourseTable.MR_deleteEntityInContext(defaultContext)
                do {
                    try defaultContext.obtainPermanentIDsForObjects([deleteCourseTable])
                }catch let error as NSError {
                    print("删除出错，错误原因\(error.localizedDescription)")
                }
                }, completion: { (isSuccess, error) -> Void in
                    self.timeList.removeAtIndex(indexPath.row)
                    tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("addOrEditTimeTableSegueIdentifier", sender: timeList[indexPath.row])
    }
}

