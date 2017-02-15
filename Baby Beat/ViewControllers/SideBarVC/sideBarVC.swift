//
//  sideBarVC.swift
//  Baby Beat
//
//  Created by OSX on 10/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit


class sideBarVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet var mTableSideBar: UITableView!
    
    
    var mAryTitle = ["HOME","RATE US","CONTACT US"]
    var mAryImg = ["homeSideBar","rateSideBar","contactSideBar"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CC_SideBar") as! CC_SideBar
        cell.backgroundColor=UIColor.clearColor()
        cell.mLblTitle.text=mAryTitle[indexPath.row]
        cell.mImgLogo.image=UIImage(named: mAryImg[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(indexPath.row==0) //Main View Controller or Home Screen
        {
            if(NSUserDefaults.standardUserDefaults().objectForKey("currentScreen") as! String != "main")
            {
                let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                self.sideMenuViewController.setContentViewController(mainVC, animated: true)
            }
            self.sideMenuViewController.hideMenuViewController()
        }
        else if(indexPath.row==1) //Rate Us Screen
        {
            if(NSUserDefaults.standardUserDefaults().objectForKey("currentScreen") as! String != "rate")
            {
                let contactVC = self.storyboard?.instantiateViewControllerWithIdentifier("RateVC") as! RateVC
                self.sideMenuViewController.setContentViewController(contactVC, animated: true)
            }
            self.sideMenuViewController.hideMenuViewController()
        }
        else if(indexPath.row==2)//Contact View Controller
        {
            if(NSUserDefaults.standardUserDefaults().objectForKey("currentScreen") as! String != "contact")
            {
                let contactVC = self.storyboard?.instantiateViewControllerWithIdentifier("ContactVC") as! ContactVC
                self.sideMenuViewController.setContentViewController(contactVC, animated: true)
            }
            self.sideMenuViewController.hideMenuViewController()

        }
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
