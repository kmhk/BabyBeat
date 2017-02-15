//
//  helpVC.swift
//  Baby Beat
//
//  Created by OSX on 31/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import CustomUIActionSheet


class helpVC: UIViewController, UIActionSheetDelegate, AVAudioPlayerDelegate
{
    //MARK: IBOutlets
    @IBOutlet var mViewPopUp: UIView!
    @IBOutlet var mBtnPopCancel: UIButton!
    @IBOutlet var mBtnPopMom: UIButton!
    @IBOutlet var mBtnPopChild: UIButton!
    @IBOutlet var mViewPopSubView: UIView!
    @IBOutlet var mImgVwBackground: UIImageView!
    
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    @IBOutlet var mBtnOpen: UIButton!
    @IBOutlet var mBtnHelp: UIButton!
    @IBOutlet var mBtnRecordings: UIButton!
    @IBOutlet var mBtnSettings: UIButton!
    @IBOutlet var mBtnSampleSound: UIButton!
    
    @IBOutlet var mBtnSampleTut: UIButton!
    
    
    //MARK: Variable Declarations
    var tapGesture=UITapGestureRecognizer()
    var player=AVAudioPlayer()
    var myPlayer=String()
    
    //MARK: View Controller Delegates
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        showHideButtons() //Initially Hide Buttons
        
       
        
       mViewPopUp.hidden=true //Initially Hide Popup View
        
        //Tap Gesture to Popup
        tapGesture=UITapGestureRecognizer(target: self, action: #selector(helpVC.hidePopView))
        mViewPopUp.addGestureRecognizer(tapGesture)
        
       // mViewPopSubView.setGradient(UIColor(red: 228/255, green: 227/255, blue: 227/255, alpha: 1.0), color2: UIColor.whiteColor(), loc1: 0.0, loc2: 1.0) // Give Gradient color to custom popup
        
        if(userdefaults.boolForKey("helpFirstTime")==false)
        {
            mBtnSampleTut.hidden=false
            mBtnSampleSound.hidden=true
            userdefaults.setBool(true, forKey: "helpFirstTime")
        }
        else
        {
            mBtnSampleTut.hidden=true
            mBtnSampleTut.removeFromSuperview()
            mBtnSampleSound.hidden=false
        }
        
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
//        currentScreen="other"
        NSUserDefaults.standardUserDefaults().setObject("other", forKey: "currentScreen")

        mImgVwBackground.setBackground()
        
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
        mBtnPopMom.setCornerRadiusButton(10.0)
        mBtnPopChild.setCornerRadiusButton(10.0)
        mViewPopSubView.setCornerRadiusView(15.0)
        
        
        
        
        //Set Shadow
        mBtnOpen.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnHelp.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnRecordings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnSettings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
    }
    
    func hidePopView() //Hide Pop Up View
    {
        player=AVAudioPlayer()
        mViewPopUp.hidden=true
        myPlayer=""
        mBtnPopMom.layer.borderColor=UIColor.clearColor().CGColor
        mBtnPopMom.layer.borderWidth=2.0
        mBtnPopChild.layer.borderColor=UIColor.clearColor().CGColor
        mBtnPopChild.layer.borderWidth=2.0
    }
    
    //MARK: IBActions
    
    @IBAction func mBtnSampleTutAction(sender: AnyObject) //Hide Tutorial Screen
    {
        mBtnSampleTut.hidden=true
        mBtnSampleTut.removeFromSuperview()
        mBtnSampleSound.hidden=false
    }
    @IBAction func mBtnSampleSoundAction(sender: AnyObject) // Sample Sound Action
    {
        
        if(mViewPopUp.hidden)
        {
            let alert=UIAlertController(title: "Information!", message: "Increase your volume to max to hear sound samples", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: {action in}))
            self.presentViewController(alert, animated: true, completion: nil)
            mViewPopUp.hidden=false
        }
        else
        {
            mViewPopUp.hidden=true
        }
    }
    
    
    
    @IBAction func mBtnOpenButtonsAction(sender: AnyObject) //To Show and Hide The Tab Bar Buttons
    {
        showHideButtons()
    }
    
    @IBAction func mBtnSideBarAction(sender: AnyObject) //Open Side Menu
    {
        self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func mBtnNavigationAction(sender: AnyObject) //Navigation buttons
    {
        if(sender.tag==2) //Settings
        {
            showHideButtons()
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsVC") as! SettingsVC
            self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
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
        }
    }
    
    @IBAction func mBtnPopAction(sender: UIButton) // Custom Pop Up Button Actions
    {
        if(sender.tag==11) //Play Mom Sound
        {
            let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mom", ofType: "mp3")!)
            if(myPlayer=="" || myPlayer=="baby")
            {
                do {
                    self.player = try AVAudioPlayer(contentsOfURL: url)
                    player.delegate=self
                    player.prepareToPlay()
                    player.volume = 1.0
                    player.play()
                    mBtnPopMom.layer.borderColor=UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.8).CGColor
                    mBtnPopMom.layer.borderWidth=2.0
                    mBtnPopChild.layer.borderColor=UIColor.clearColor().CGColor
                    mBtnPopChild.layer.borderWidth=2.0
                    myPlayer="mom"
                } catch let error as NSError {
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }
            }
            else
            {
                player=AVAudioPlayer()
                myPlayer=""
                mBtnPopMom.layer.borderColor=UIColor.clearColor().CGColor
                mBtnPopMom.layer.borderWidth=2.0
                mBtnPopChild.layer.borderColor=UIColor.clearColor().CGColor
                mBtnPopChild.layer.borderWidth=2.0

            }
                        //mViewPopUp.hidden=true
        }
        else if(sender.tag==12) //Play Baby Sound
        {
            if(myPlayer=="" || myPlayer=="mom")
            {
                let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("baby", ofType: "mp3")!)
                do {
                    self.player = try AVAudioPlayer(contentsOfURL: url)
                    player.delegate=self
                    player.prepareToPlay()
                    player.volume = 1.0
                    player.play()
                    myPlayer="baby"
                    mBtnPopChild.layer.borderColor=UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.8).CGColor
                    mBtnPopChild.layer.borderWidth=2.0
                    mBtnPopMom.layer.borderColor=UIColor.clearColor().CGColor
                    mBtnPopMom.layer.borderWidth=2.0
                } catch let error as NSError {
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }
                
            }
            else
            {
                player=AVAudioPlayer()
                myPlayer=""
                mBtnPopMom.layer.borderColor=UIColor.clearColor().CGColor
                mBtnPopMom.layer.borderWidth=2.0
                mBtnPopChild.layer.borderColor=UIColor.clearColor().CGColor
                mBtnPopChild.layer.borderWidth=2.0
            }
        }
        else if(sender.tag==13) // Cancel Action
        {
            player=AVAudioPlayer()
            mViewPopUp.hidden=true
            myPlayer=""
            mBtnPopMom.layer.borderColor=UIColor.clearColor().CGColor
            mBtnPopMom.layer.borderWidth=2.0
            mBtnPopChild.layer.borderColor=UIColor.clearColor().CGColor
            mBtnPopChild.layer.borderWidth=2.0
        }

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
    
    
}
