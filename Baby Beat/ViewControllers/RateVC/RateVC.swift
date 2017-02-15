//
//  RateVCViewController.swift
//  Baby Beat
//
//  Created by Manish on 14/04/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit

class RateVC: UIViewController
{

    @IBOutlet weak var mViewPop: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    //    mViewPop.setGradient(UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0), color2: UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0), loc1: 0.1, loc2: 0.5)
        mViewPop.setShadowView(3.0, opacity: 0.7, size: CGSizeMake(0,5))
        mViewPop.setCornerRadiusView(8.0)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
//        currentScreen="rate"
         NSUserDefaults.standardUserDefaults().setObject("rate", forKey: "currentScreen")
    }
    
    @IBAction func mBtnSideBarAction(sender: AnyObject)
    {
        self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func mBtnRateAction(sender: UIButton)
    {
    }
    
    
    @IBAction func mBtnStarsAction(sender: UIButton)
    {
        for var i=1; i<=5; i += 1
        {
            ((self.view.viewWithTag(i)) as! UIButton).setImage(UIImage(named: "ia_star"), forState: .Normal)
        }
        
        for var i=1; i<=sender.tag; i += 1
        {
            ((self.view.viewWithTag(i)) as! UIButton).setImage(UIImage(named: "a_star"), forState: .Normal)
        }
    }
    
}
