//
//  ShareVC.swift
//  Baby Beat
//
//  Created by OSX on 21/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import MediaPlayer

class ShareVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK: IBOutlets
    @IBOutlet weak var mBtnBabyImage: UIButton!
    @IBOutlet weak var mLblAudioName: UILabel!
    @IBOutlet weak var mLblAudioTime: UILabel!
    @IBOutlet var mImgVwBackground: UIImageView!
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    
    //MARK: Variable Dclarations
    var mStrAudioName=String()
    var mStrWeekNumber=String()
    var mStrTime=String()
    var mUrlAudio=NSURL()
    var imagePicker=UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mLblAudioName.text=mStrAudioName
        mLblAudioTime.text="\(mStrWeekNumber) - \(mStrTime)"
        
        mBtnBabyImage.setCornerRadiusButton(mBtnBabyImage.frame.size.width/2)
        mBtnBabyImage.setBorderButton(UIColor.whiteColor(), width: 2.0)
        
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
        mImgVwBackground.setBackground()
    }
    
    @IBAction func mBtnBackAction(sender: AnyObject)
    {
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("RecordingsVC") as! RecordingsVC
        self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
    }

    @IBAction func mBtnChangeImageAction(sender: UIButton)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone)
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
            //if iPad
        else
        {
            // Change Rect to position Popover
            let popUp = UIPopoverController.init(contentViewController: alert)
            popUp.presentPopoverFromRect(CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0), inView: self.view, permittedArrowDirections: .Any, animated: true)
        }

        
    }
    @IBAction func mBtnShareAction(sender: AnyObject)
    {
        
//        NSArray *activityItems = @[fileUrl];
//        
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//        [self presentViewController:activityVC animated:YES completion:nil];
        
        let activityItems = [mUrlAudio]
        
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone)
        {
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
            //if iPad
        else
        {
            // Change Rect to position Popover
            let popUp = UIPopoverController.init(contentViewController: activityVC)
            popUp.presentPopoverFromRect(CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0), inView: self.view, permittedArrowDirections: .Any, animated: true)
        }
        
        
    }
    
    
    
    //MARK: Image Picker Methods
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.allowsEditing=true
            imagePicker.delegate=self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        imagePicker.allowsEditing=true
        imagePicker.delegate=self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Image Picker Delegates
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image=editingInfo![UIImagePickerControllerOriginalImage]
        mBtnBabyImage.setBackgroundImage(image as? UIImage, forState: .Normal)
    }

}
