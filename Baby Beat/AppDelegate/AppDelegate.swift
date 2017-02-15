//
//  AppDelegate.swift
//  Baby Beat
//
//  Created by OSX on 10/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import RESideMenu
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import CoreMotion




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        
   
        
        // Override point for customization after application launch.

        IQKeyboardManager.sharedManager().enable = true //Enable IqKeyboard Manager
        
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        
        Fabric.with([Crashlytics.self])
        
        //Set Week Count for the app
        if(userdefaults.valueForKey("firstDate") != nil)
        {
            let previousDate = userdefaults.valueForKey("firstDate") as! NSDate
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "dd-MMM-YYYY"
//            dateFormatter.timeZone=NSTimeZone(name: "gmt")
//            let previousDate = dateFormatter.dateFromString(dateStr1)
            let currentDate = NSDate()
            
            let week = NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: previousDate, toDate: currentDate, options: []).weekOfYear
            
            userdefaults.setInteger(week, forKey: "weekCount")
        }
        else
        {
            let date = NSDate()
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "dd-MMM-YYYY"
//            dateFormatter.timeZone=NSTimeZone(name: "gmt")
//            let dateStr = dateFormatter.stringFromDate(date)
            userdefaults.setObject(date, forKey: "firstDate")
            userdefaults.setInteger(0, forKey: "weekCount")
            
        }
        let storyboard=UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let mainVC=storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let resideMenu = RESideMenu(contentViewController: mainVC, leftMenuViewController: sideBarVC(), rightMenuViewController: nil)
        self.window?.rootViewController=resideMenu
        
        let notification = UILocalNotification()
        notification.fireDate = getSpecificDate(7)
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.repeatInterval=NSCalendarUnit.WeekOfYear
        notification.alertBody = "Check Bubba's Beat"
        notification.alertAction = "Baby Beat Information"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        
        return true
    }
    
    func getSpecificDate(day: NSInteger) -> NSDate
    {
        let weekDateRange = NSCalendar.currentCalendar().maximumRangeOfUnit(.Weekday)
        let daysInWeek = weekDateRange.length-weekDateRange.location+1
        let dateComponents=NSCalendar.currentCalendar().components(.Weekday, fromDate: NSDate())
        let currentWeekDay=dateComponents.weekday
        let differenceDays = (day-currentWeekDay+daysInWeek)%daysInWeek
        let daysComponents=NSDateComponents()
        daysComponents.day=differenceDays
        let resultDate=NSCalendar.currentCalendar().dateByAddingComponents(daysComponents, toDate: NSDate(), options: NSCalendarOptions.WrapComponents)
        return resultDate!
    }

    
    
//    -(NSDate *) getDateOfSpecificDay:(NSInteger ) day /// here day will be 1 or 2.. or 7
//    {
//    NSInteger desiredWeekday = day
//    NSRange weekDateRange = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSWeekdayCalendarUnit];
//    NSInteger daysInWeek = weekDateRange.length - weekDateRange.location + 1;
//    
//    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
//    NSInteger currentWeekday = dateComponents.weekday;
//    NSInteger differenceDays = (desiredWeekday - currentWeekday + daysInWeek) % daysInWeek;
//    NSDateComponents *daysComponents = [[NSDateComponents alloc] init];
//    daysComponents.day = differenceDays;
//    NSDate *resultDate = [[NSCalendar currentCalendar] dateByAddingComponents:daysComponents toDate:[NSDate date] options:0];
//    return resultDate;
//    }
//    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

