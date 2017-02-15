//
//  ContactVC.swift
//  Baby Beat
//
//  Created by OSX on 31/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import MessageUI

class ContactVC: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate
{
    //MARK: IBOutlets
    @IBOutlet var mTfEmail: UITextField!
    @IBOutlet var mImgVwBackground: UIImageView!
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var mTVMessageBody: UITextView!
    
    
    //MARK: Variable Declarations
    
    
    //MARK: View Controller Delegates
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Change Placeholder Color
        let emailPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        mTfEmail.attributedPlaceholder=emailPlaceholder
        mTVMessageBody.delegate=self
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
        NSUserDefaults.standardUserDefaults().setObject("contact", forKey: "currentScreen")
//        currentScreen="contact"
        mImgVwBackground.setBackground()
    }
    
    //MARK: IBActions
    @IBAction func mBtnSideBarAction(sender: UIButton) //Side Bar Menu Actions
    {
        self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func mBtnFbAction(sender: AnyObject) //Facebook Button Action
    {
        UIApplication.tryURL([
            "fb://profile/Apps-Maven-264301700413617", // App
            "http://www.facebook.com/Apps-Maven-264301700413617" // Website if app fails
            ])
    }
    
    @IBAction func mBtnSendMailAction(sender: AnyObject) //Email Send Button Action
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else
        {
           // self.showSendMailErrorAlert()
        }
    }
    
    
    //Email Composer Methods
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["manish.appsmaven@gmail.com"])
        mailComposerVC.setSubject("Baby Beat Queries")
        mailComposerVC.setMessageBody(mTVMessageBody.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        let alert=UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: {action in}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Textview Delegates
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if(mTVMessageBody.text=="Please enter your queries here...")
        {
            mTVMessageBody.text=""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if(mTVMessageBody.text=="")
        {
            mTVMessageBody.text="Please enter your queries here..."
        }
    }
    
}
