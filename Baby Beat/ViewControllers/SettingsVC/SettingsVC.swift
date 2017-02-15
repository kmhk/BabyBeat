//
//  SettingsVC.swift
//  Baby Beat
//
//  Created by OSX on 21/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITextFieldDelegate
{
    
    //MARK: IBOutlets
    
    @IBOutlet weak var mTFDueDate: UITextField!
    
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    @IBOutlet var mBtnBlue: UIButton!
    @IBOutlet var mBtnPink: UIButton!
    @IBOutlet var mBtnTurqoise: UIButton!
    @IBOutlet var mBtnOpen: UIButton!
    @IBOutlet var mBtnHelp: UIButton!
    @IBOutlet var mBtnRecordings: UIButton!
    @IBOutlet var mBtnSettings: UIButton!
    @IBOutlet var mBtnChangeColor: UIButton!
    @IBOutlet var mBtnPopCancel: UIButton!
    
    @IBOutlet var mImgVwSettingsTut: UIView!
    @IBOutlet var mImgVwBackground: UIImageView!
    
    @IBOutlet var mViewPopSubView: UIView!
    @IBOutlet var mViewPink: UIView!
    @IBOutlet var mViewBlue: UIView!
    @IBOutlet var mViewTurqoise: UIView!
    @IBOutlet var mViewPop: UIView!
    
    
    //MARK: Variable Declarations
    var tapGesture = UITapGestureRecognizer() //Tap Gesture for settings tutorial Screen
    var popGesture = UITapGestureRecognizer() //Tap Gesture for Popup Gesture
    var datePicker = UIDatePicker()//Date Picker for Due Date
    var myDate=NSDate()
    
    //MARK: View Controller Delegates
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        showHideButtons() //Initially hide Buttons
        
       
        
        mViewPop.hidden=true //Initially hide the Custom Popup
        
        //Tap Gesture to Popup
        tapGesture=UITapGestureRecognizer(target: self, action: #selector(SettingsVC.hideImgVw))
        mImgVwSettingsTut.addGestureRecognizer(tapGesture)
        popGesture=UITapGestureRecognizer(target: self, action: #selector(SettingsVC.hidePopView))
        mViewPop.addGestureRecognizer(popGesture)

        
        //Change Placeholder Color
        let dueDatePlaceholder = NSAttributedString(string: "Due Date", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        mTFDueDate.attributedPlaceholder=dueDatePlaceholder
        
        
        //Show or Hide Setting Tutorial Screen
        if(userdefaults.boolForKey("settingsFirstTime")==false)
        {
            mImgVwSettingsTut.hidden=false
            mBtnChangeColor.hidden=true
            userdefaults.setBool(true, forKey: "settingsFirstTime")
            
        }
        else
        {
            mImgVwSettingsTut.hidden=true
            mImgVwSettingsTut.removeFromSuperview()
            mBtnChangeColor.hidden=false
        }
        
        //Add Date Picker on due date
        datePicker.datePickerMode = UIDatePickerMode.Date
        mTFDueDate.inputView = datePicker
        datePicker.minimumDate=NSDate()
        datePicker.addTarget(self, action: #selector(SettingsVC.handeDatePicker), forControlEvents: .ValueChanged)
        mTFDueDate.delegate=self
        
        let modelName = UIDevice.currentDevice().modelName
        if(modelName=="iPhone+")
        {
            mCnstHeaderHeight.constant=93.0
        }
        else
        {
            mCnstHeaderHeight.constant=64.0
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
//         currentScreen="other"
        NSUserDefaults.standardUserDefaults().setObject("other", forKey: "currentScreen")

        mImgVwBackground.setBackground()
        if(userdefaults.valueForKey("dueDate") != nil)
        {
            mTFDueDate.text=userdefaults.valueForKey("dueDate") as? String
        }
        
        //Set Corner Radius
        let modelName = UIDevice.currentDevice().modelName
        if(modelName=="iPad")
        {
            mBtnOpen.setCornerRadiusButton(mBtnOpen.frame.size.width/2)
            mBtnHelp.setCornerRadiusButton(mBtnHelp.frame.size.width/2)
            mBtnRecordings.setCornerRadiusButton(mBtnRecordings.frame.size.width/2)
            mBtnSettings.setCornerRadiusButton(mBtnSettings.frame.size.width/2)
        }
        else
        {
            mBtnOpen.setCornerRadiusButton(mBtnOpen.frame.size.width/4)
            mBtnHelp.setCornerRadiusButton(mBtnHelp.frame.size.width/4)
            mBtnRecordings.setCornerRadiusButton(mBtnRecordings.frame.size.width/4)
            mBtnSettings.setCornerRadiusButton(mBtnSettings.frame.size.width/4)
        }
        
        mBtnPopCancel.setCornerRadiusButton(15.0)
        mViewPopSubView.setCornerRadiusView(15.0)
        mViewTurqoise.setCornerRadiusView(10.0)
        mViewBlue.setCornerRadiusView(10.0)
        mViewPink.setCornerRadiusView(10.0)
        mBtnTurqoise.setCornerRadiusButton(22.0)
        mBtnPink.setCornerRadiusButton(22.0)
        mBtnBlue.setCornerRadiusButton(22.0)
        
        // Set Border
        mBtnTurqoise.setBorderButton(UIColor.lightGrayColor(), width: 1.0)
        mBtnPink.setBorderButton(UIColor.lightGrayColor(), width: 1.0)
        mBtnBlue.setBorderButton(UIColor.lightGrayColor(), width: 1.0)
        
        //Set Shadow
        mBtnOpen.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnHelp.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnRecordings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnSettings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
    }
    
    
    //MARK: Tap Gesture Mehtods
    
    func hideImgVw() //Hide the Image View and remove from superview
    {
        mImgVwSettingsTut.hidden=true
        mImgVwSettingsTut.removeFromSuperview()
        mBtnChangeColor.hidden=false
    }
    
    func hidePopView() //Hide Custom Popup
    {
        mViewPop.hidden=true
    }
    
    
    //MARK: IBActions
    
    @IBAction func mBtnSideBarAction(sender: AnyObject) //Open Side Menu
    {
        self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    
    @IBAction func mBtnCustomPopButtonActions(sender: UIButton) //Custom Popup Buttons
    {
        if(sender.tag==11) //Turqoise
        {
            userdefaults.setValue("turqoise", forKey: "background")
        }
        else if(sender.tag==12) //Pink
        {
            userdefaults.setValue("pink", forKey: "background")
        }
        else if(sender.tag==13) //Blue
        {
            userdefaults.setValue("blue", forKey: "background")
        }
        mImgVwBackground.setBackground()
        mViewPop.hidden=true
    }
    
    @IBAction func mBtnNavigationAction(sender: AnyObject) //Navigation buttons
    {
        if(sender.tag==2) //Settings
        {
            showHideButtons()
        }
        else if(sender.tag==3) //Recordings
        {
            showHideButtons()
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("RecordingsVC") as! RecordingsVC
            self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
        }
        else if(sender.tag==4) //Help
        {
            showHideButtons()
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("helpVC") as! helpVC
            self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
        }
    }
    
    @IBAction func mBtnChangeColorAction(sender: AnyObject) //Change Color Action
    {
        setTick()
        if(mViewPop.hidden)
        {
            mViewPop.hidden=false
        }
        else
        {
            mViewPop.hidden=true
        }
    }
    
    @IBAction func mBtnOpenButtonsAction(sender: AnyObject) //Open and Hide Navigation Buttons
    {
        showHideButtons()
    }

    
    //MARK: Show and Hide Buttons
    func showHideButtons()
    {
        if(mBtnSettings.hidden) // Show Buttons
        {
            mBtnRecordings.hidden=false
            mBtnHelp.hidden=false
            mBtnSettings.hidden=false
        }
        else //Hide Buttons
        {
            mBtnRecordings.hidden=true
            mBtnHelp.hidden=true
            mBtnSettings.hidden=true
        }
    }
    
    //MARK: Set Tick to selected Color
    func setTick()
    {
        //Remoce Image for all
        mBtnTurqoise.setBackgroundImage(nil, forState: .Normal)
        mBtnBlue.setBackgroundImage(nil, forState: .Normal)
        mBtnPink.setBackgroundImage(nil, forState: .Normal)
        
        //Set tick according to color selected
        if(userdefaults.valueForKey("background")==nil || userdefaults.valueForKey("background") as! String=="turqoise")
        {
            mBtnTurqoise.setBackgroundImage(UIImage(named: "tick"), forState: .Normal)
        }
        else if(userdefaults.valueForKey("background") as! String=="blue")
        {
            mBtnBlue.setBackgroundImage(UIImage(named: "tick"), forState: .Normal)
        }
        else if(userdefaults.valueForKey("background") as! String=="pink")
        {
            mBtnPink.setBackgroundImage(UIImage(named: "tick"), forState: .Normal)
        }
        else
        {
            mBtnTurqoise.setBackgroundImage(UIImage(named: "tick"), forState: .Normal)
        }
    }


    //MARK: Date Picker Delegate
    func handeDatePicker() //Set Due Date
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat="dd-MMM-YYYY"
        dateFormatter.timeZone=NSTimeZone(name: "gmt")
        mTFDueDate.text="\(dateFormatter.stringFromDate(datePicker.date))"
        
        myDate=datePicker.date

    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        let dateComponents = NSDateComponents()
        dateComponents.month = -9
        let calender = NSCalendar.currentCalendar()
        let newDate = calender.dateByAddingComponents(dateComponents, toDate: myDate, options: NSCalendarOptions.MatchFirst)
        // let strDate=dateFormatter.stringFromDate(newDate!)
        print(newDate)
        
        //let previousDate = dateFormatter.dateFromString(strDate)
        let currentDate = NSDate()
        let result = newDate?.compare(currentDate)
        if(result == NSComparisonResult.OrderedDescending)
        {
            let alert=UIAlertController(title: "Error!", message: "Please select correct due date", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: {action in }))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        else
        {
            userdefaults.setObject(newDate!, forKey: "firstDate")
            let week = NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: newDate!, toDate: currentDate, options: []).weekOfYear
            userdefaults.setInteger(week, forKey: "weekCount")
            userdefaults.setValue(mTFDueDate.text!, forKey: "dueDate")
             return true
        }
       
    }
    
}
