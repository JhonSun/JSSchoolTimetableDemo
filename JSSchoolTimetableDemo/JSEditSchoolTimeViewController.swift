//
//  JSEditSchoolTimeViewController.swift
//  JSSchoolTimetableDemo
//
//  Created by jhon.sun on 16/3/7.
//  Copyright © 2016年 jhon.sun. All rights reserved.
//

import UIKit

class JSEditSchoolTimeViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    let contentCellIdentifier = "courseContentCollectViewCellIdentifier"
    let titleCellIdentifier = "tableTitleCollectViewIdentifier"
    let dateArray = ["星期一", "星期二", "星期三", "星期四", "星期五"]
    let classPeriodArray = ["第一节", "第二节", "第三节", "第四节", "第五节", "第六节", "第七节", "第八节"]
    var oldFrame: CGRect?
    var isCanSelect = true
    var courseTable: CourseTableInfo?
    var dataArray: NSMutableOrderedSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        myCollectionView.layer.borderWidth = 1.0
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.registerNib(UINib(nibName: "JSCourseContentCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: contentCellIdentifier)
        myCollectionView.registerNib(UINib(nibName: "JSTableTitleCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: titleCellIdentifier)
        
        if !isCanSelect {
            let pinchGR = UIPinchGestureRecognizer(target: self, action: Selector("zoomInOut:"))
            myCollectionView.addGestureRecognizer(pinchGR)
            
            let panchGR = UIPanGestureRecognizer(target: self, action: Selector("move:"))
            myCollectionView.addGestureRecognizer(panchGR)
        }
        
        saveButton.hidden = !isCanSelect
        
        if let dataArrayTemp = courseTable?.table_course {
            dataArray = NSMutableOrderedSet(orderedSet: dataArrayTemp)
        } else {
            dataArray = NSMutableOrderedSet()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        oldFrame = myCollectionView.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editClassContentSegueIdentifier" {
            let editCourseContentVC = segue.destinationViewController as! JSEditClassContentViewController
            let indexPath = sender as! NSIndexPath
            editCourseContentVC.indexPath = indexPath
            var courseInfo: CourseInfo?
            let cell = myCollectionView.cellForItemAtIndexPath(indexPath) as! JSCourseContentCollectionViewCell
            courseInfo = cell.courseInfo
            editCourseContentVC.courseInfo = courseInfo
            editCourseContentVC.courseTableInfo = self.courseTable
            editCourseContentVC.save = {(courseInfo) -> Void in
                self.dataArray!.addObject(courseInfo)
//                print("保存的实体\(courseInfo.courseName)")
                self.myCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        MagicalRecord.saveWithBlock({ (defaultContext) -> Void in
            self.courseTable = self.courseTable!.MR_inContext(defaultContext)
            for courseInfo in self.dataArray! {
                let courseInfoTemp = courseInfo.MR_inContext(defaultContext)
                let index = self.dataArray!.indexOfObject(courseInfo)
                if let courseInfoTempTemp = courseInfoTemp {
                    self.dataArray!.replaceObjectAtIndex(index, withObject: courseInfoTempTemp)
                }
            }
            self.courseTable!.table_course = self.dataArray
            do {
                try defaultContext.obtainPermanentIDsForObjects([self.courseTable!])
            } catch let error as NSError {
                print("保存课程表错误，错误原因\(error.localizedDescription)")
            }
            }) { (isSuccess, error) -> Void in
                if isSuccess {
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
        }
    }
    
    func zoomInOut(pinchGR: UIPinchGestureRecognizer) {
        
        if pinchGR.state == UIGestureRecognizerState.Ended {
            if myCollectionView.frame.size.width / oldFrame!.size.width >= 1.5 && myCollectionView.frame.size.height / oldFrame!.size.height >= 1.5 {
                myCollectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
                return
            }
            if myCollectionView.frame.size.width / oldFrame!.size.width <= 1.0 && myCollectionView.frame.size.height / oldFrame!.size.height <= 1.0 {
                myCollectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                return
            }
        }
        
        if pinchGR.state == UIGestureRecognizerState.Began || pinchGR.state == UIGestureRecognizerState.Changed {
//            print("缩放值\(pinchGR.scale)")
            let transform = myCollectionView.transform
            myCollectionView.transform = CGAffineTransformScale(transform, pinchGR.scale, pinchGR.scale)
            pinchGR.scale = 1
        }
    }
    
    func move(panch: UIPanGestureRecognizer) {
        
        if panch.state == UIGestureRecognizerState.Ended {
            let originalX = myCollectionView.frame.origin.x
            let originalY = myCollectionView.frame.origin.y
            let width = myCollectionView.frame.size.width
            let height = myCollectionView.frame.size.height
            let oldWidth = oldFrame!.size.width
            let oldHeight = oldFrame!.size.height + 64
            if originalX > 0 && originalY > 64 {
                self.setMyCollectionViewFrame(0, y: 64)
            } else if originalX + width < oldWidth && originalY > 64{
                self.setMyCollectionViewFrame(oldWidth - width, y: 64)
            } else if originalX > 0 && originalY + height < oldHeight {
                self.setMyCollectionViewFrame(0, y: oldHeight - height)
            } else if originalX + width < oldWidth && originalY + height < oldHeight {
                self.setMyCollectionViewFrame(oldWidth - width, y: oldHeight - height)
            } else if originalX > 0 {
                self.setMyCollectionViewFrame(0, y: nil)
            } else if originalY > 64 {
                self.setMyCollectionViewFrame(nil, y: 64)
            } else if originalX + width < oldWidth {
                self.setMyCollectionViewFrame(oldWidth - width, y: nil)
            } else if originalY + height < oldHeight {
                self.setMyCollectionViewFrame(nil, y: oldHeight - height)
            }
        }
        
        if panch.state == UIGestureRecognizerState.Began || panch.state == UIGestureRecognizerState.Changed {
            if myCollectionView.frame.size.width == oldFrame!.size.width && myCollectionView.frame.size.height == oldFrame!.size.height {
                return
            }
            let deltaPoint = panch.translationInView(myCollectionView)
            myCollectionView.transform = CGAffineTransformTranslate(myCollectionView.transform, deltaPoint.x, deltaPoint.y)
            panch.setTranslation(CGPointZero, inView: myCollectionView)
        }
    }
    
    func setMyCollectionViewFrame(x: CGFloat? , y: CGFloat?) {
        var frame = myCollectionView.frame
        if let tempX = x {
            frame.origin.x = tempX
        }
        if let tempY = y {
            frame.origin.y = tempY
        }
        myCollectionView.frame = frame
    }
}

extension JSEditSchoolTimeViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return classPeriodArray.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 || indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(titleCellIdentifier, forIndexPath: indexPath) as! JSTableTitleCollectionViewCell
            if indexPath.section == 0 && indexPath.item == 0 {
                cell.tableTitleLabel.text = ""
            } else if indexPath.section == 0 {
                cell.tableTitleLabel.text = dateArray[indexPath.item - 1]
            } else if indexPath.item == 0 {
                cell.tableTitleLabel.text = classPeriodArray[indexPath.section - 1]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! JSCourseContentCollectionViewCell
            var courseContent: CourseInfo?
            for courseInfo in dataArray! {
                let courseInfoTemp = courseInfo as! CourseInfo
                if courseInfoTemp.coursePeriod == indexPath.section && courseInfoTemp.courseDay == indexPath.item {
                    courseContent = courseInfoTemp
                    break
                }
            }
            if let courseContentTmep = courseContent {
                cell.showDetail(courseContentTmep)
            }
            
            return cell
        }
    }
}

extension JSEditSchoolTimeViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item != 0 && indexPath.section != 0 {
            self.performSegueWithIdentifier("editClassContentSegueIdentifier", sender: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isCanSelect
    }
}

extension JSEditSchoolTimeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 && indexPath.item == 0 {
            return CGSize.init(width: 20, height: 20)
        }
        if indexPath.section == 0 {
            return CGSize.init(width: (collectionView.frame.size.width - 20) / 5, height: 20)
        }
        if indexPath.item == 0 {
            return CGSize.init(width: 20, height: (collectionView.frame.size.height - 20) / 8)
        }
        return CGSize.init(width: (collectionView.frame.size.width - 20) / 5, height: (collectionView.frame.size.height - 20) / 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

