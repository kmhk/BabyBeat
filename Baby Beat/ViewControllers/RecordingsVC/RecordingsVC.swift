//
//  RecordingsVC.swift
//  Baby Beat
//
//  Created by OSX on 18/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import RESideMenu
import CoreMotion


class RecordingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate,EZAudioFileDelegate ,EZAudioPlayerDelegate
{

    //MARK: IBoutlets
    @IBOutlet weak var mTableRecordings: UITableView! //Recording Table View
    @IBOutlet weak var mLblWeekCount: UILabel!
    @IBOutlet weak var mViewWeekCount: UIView!
    @IBOutlet var mBtnOpen: UIButton!
    @IBOutlet var mBtnHelp: UIButton!
    @IBOutlet var mBtnRecordings: UIButton!
    @IBOutlet var mBtnSettings: UIButton!
    @IBOutlet var mImgVwBackground: UIImageView!
    var shreIndexPath = NSIndexPath()
    var mixingFiles = Bool()
    var previousFrameTime = Int()
    
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    //MARK: Variable Declarations
    var player:EZAudioPlayer!
    var recordings=[NSURL]()
    var myIndex=NSIndexPath()
    var playing=Bool()
    var currentIndexPath=Int()
    
    var beatPlayer: AVAudioPlayer!
    var noiseAudioPlayer: AVAudioPlayer!
    var frequencyValue = Float();
    var previousFrequency = Float();
    var playingAudioPlot = EZAudioPlot()
    var isPlay = Bool();
    
    


    //MARK: View Controller Delegates
    override func viewDidLoad()
    {
        

        super.viewDidLoad()
        mTableRecordings.scrollEnabled = true


        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
        do
        {
            try session.setActive(true)
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }

        getRecordings() //Get All Recordings from Document Directory
        
       
        
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
        
         myIndex = NSIndexPath(forRow: -1, inSection: -1)
        
        NSUserDefaults.standardUserDefaults().setObject("other", forKey: "currentScreen")

        showHideButtons()
        mImgVwBackground.setBackground()
        
        //Set Radius to view
        mViewWeekCount.setCornerRadiusView(mViewWeekCount.frame.size.height/2)
        
        mLblWeekCount.text="\(userdefaults.integerForKey("weekCount"))" // Set Week Count to 0 initially
        
        
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
        
        //Set Shadow
        mBtnOpen.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnHelp.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnRecordings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnSettings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
    }
    
    //MARK: IBActions
    
    @IBAction func mBtnSideBarAction(sender: AnyObject) //Open Side Menu
    {
         self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func mBtnOpenAction(sender: AnyObject)
    {
        showHideButtons()
    }
    
    
    @IBAction func mBtnNavigationAction(sender: AnyObject)
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
        }
        else if(sender.tag==4) //Help
        {
            showHideButtons()
            
            
//            let cafs = Mixing.cafsFromTemporarydirectory() as NSArray;
//            
//            let path1 = cafs.objectAtIndex(0);
//            let soundUrl1 = NSURL.fileURLWithPath(path1 as! String)
//            noiseAudioPlayer = nil
//            do {
//                noiseAudioPlayer = try AVAudioPlayer(contentsOfURL: soundUrl1)
//            }
//            catch  _ {
//            }
//            noiseAudioPlayer.volume = 1.0
//            noiseAudioPlayer.play()
//

            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("helpVC") as! helpVC
            self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
        }
    }

    //MARK: Table View Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print(paths[0])

        print(recordings.count)
        return recordings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CC_Recordings") as! CC_Recordings
        
        cell.mViewDetails.hidden = false
        let fileName = recordings[indexPath.row].lastPathComponent
        let audioName  = fileName?.componentsSeparatedByString("+")
        let weekCount = audioName![1].componentsSeparatedByString(".")
        cell.mLblName.text = (audioName![0].componentsSeparatedByString("|"))[0]
        cell.backgroundColor=UIColor.clearColor()
        cell.mLblWeekNumber.text="Week \(weekCount[0])"
        cell.mBtnPlay.tag=indexPath.row
        cell.mBtnPlay.addTarget(self, action: #selector(RecordingsVC.playRecording(_:)), forControlEvents: .TouchUpInside)
        let asset = AVAsset(URL: recordings[indexPath.row])
        
        let time = asset.duration
        cell.mLblTimeCount.text=timeFormatted(Int(time.seconds ))
        
        
        cell.mViewPlotVisualisation.backgroundColor = UIColor.clearColor()
      //  cell.mViewPlotVisualisation.backgroundColor = UIColor(red: 235/255, green: 120/255, blue: 104/255, alpha: 1.0)
       // cell.mViewPlotVisualisation.color = UIColor(red: 64/255.0, green: 34.0/255, blue: 62.0/255, alpha: 1.0)


        cell.mViewGraph.hidden = true
        cell.mViewOverGraph.hidden = true
        cell.mImgOverlay.setOverlay()
        
        cell.mViewPlotVisualisation.plotType = EZPlotType.Rolling;
        

        cell.mViewPlotVisualisation.shouldFill = false;
        cell.mViewPlotVisualisation.shouldMirror = false;
        cell.mViewPlotVisualisation.shouldCenterYAxis = false;
      
        
        cell.mViewPlotVisualisation.gain = 15000;
        cell.mViewPlotVisualisation.clear()
        cell.mViewPlotVisualisation .setRollingHistoryLength(5000)

        cell.mBtnShare.tag=indexPath.row
        cell.mBtnShare.addTarget(self, action: #selector(RecordingsVC.shareBtnAction(_:)), forControlEvents: .TouchUpInside)

        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CC_Recordings") as! CC_Recordings
        let height = cell.mImgPlayBack.frame.size.height
        let modelName = UIDevice.currentDevice().modelName
        if(modelName=="iPad")
        {
            cell.mCnstPLayViewHeight.constant=(height)*CGFloat(2)
            return cell.mViewPlay.frame.size.height+30
        }
        else
        {
           // cell.mCnstPLayViewHeight.constant=(height/4)
            let height = cell.mViewPlay.frame.size.height
            return height/2+40
        }
        
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if (self.player == nil)
        {
            return true
        }
        else
        {
            if self.player.isPlaying
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
           // NSFileManager *fileManager = [NSFileManager defaultManager];
            let fileManager = NSFileManager.defaultManager()
            do
            {
                
                try fileManager.removeItemAtURL(recordings[indexPath.row])
                recordings.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.reloadData()
            }
            catch
            {
                
            }
            
        }
    }
    
    //MARK: Table View Button Actions
    
    func playRecording(sender: UIButton) //Play Button Action
        
    {
        
        
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        myIndex=indexPath
        
        let cell = mTableRecordings.cellForRowAtIndexPath(indexPath) as! CC_Recordings
        dispatch_async(dispatch_get_main_queue(),
        {
            cell.mViewGraph.hidden = false
            cell.mViewOverGraph.hidden = false
            cell.mViewDetails.hidden = true
        })
        
        
        if(currentIndexPath != sender.tag && playing)
        {
            mTableRecordings.scrollEnabled = true

            
            let indexPath1 = NSIndexPath(forRow: currentIndexPath, inSection: 0)
            if(mTableRecordings.cellForRowAtIndexPath(indexPath1) != nil)
            {
                let cell1 = mTableRecordings.cellForRowAtIndexPath(indexPath1) as! CC_Recordings
                cell1.mBtnPlay.setImage(UIImage(named: "playBtn"), forState: .Normal)
                
                cell1.mViewGraph.hidden = true
                cell1.mViewOverGraph.hidden = true
                cell1.mViewDetails.hidden = false
            }
            
            beatPlayer.stop()
            noiseAudioPlayer.stop()
            player.pause()
            playing=false
        }
        
        
        if(playing)
        {
            mTableRecordings.scrollEnabled = true
            player.pause()
            playing=false
            beatPlayer.stop()
            noiseAudioPlayer.stop()

            let cell = mTableRecordings.cellForRowAtIndexPath(myIndex) as! CC_Recordings
            dispatch_async(dispatch_get_main_queue(), {
                cell.mViewPlotVisualisation.clear()
                cell.mViewGraph.hidden = true
                cell.mViewOverGraph.hidden = true
                cell.mViewDetails.hidden = false
                cell.mBtnPlay.setImage(UIImage(named: "playBtn"), forState: .Normal)
            })

//            cell.mBtnPlay.setImage(UIImage(named: "playBtn"), forState: .Normal)
        }
        else
        {
            mTableRecordings.scrollEnabled = false

            playing=true
            currentIndexPath=sender.tag
            cell.mBtnPlay.setImage(UIImage(named: "stopBtn"), forState: .Normal)
            play(recordings[sender.tag],index: sender.tag)
        }
        
    }
    
    func shareBtnAction(sender:UIButton) //Navigate to Share Screen
    {
        shreIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
//        mixingFiles = true
        
//        let fileName = recordings[shreIndexPath.row].lastPathComponent
//        let audioName  = fileName?.componentsSeparatedByString("+")
//        let name = (audioName![0].componentsSeparatedByString("|"))[0].stringByAppendingString(".mp4")
//        let mode = (audioName![0].componentsSeparatedByString("|"))[1]
//        
//        previousFrameTime = 0
//        let audioFile = EZAudioFile(URL:recordings[shreIndexPath.row])
//        self.player =  EZAudioPlayer(audioFile:audioFile)
//        self.player.delegate = self
//        self.player.play()
//        self.player.volume = 0.2
//
//        frequencyValue = 0.000000

        
//        let cell = mTableRecordings.cellForRowAtIndexPath(indexPath) as! CC_Recordings
//        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ShareVC") as! ShareVC
//        nxtObj.mStrAudioName=cell.mLblName.text!
//        nxtObj.mStrWeekNumber=cell.mLblWeekNumber.text!
//        nxtObj.mStrTime=cell.mLblTimeCount.text!
//        nxtObj.mUrlAudio=recordings[sender.tag]
//        self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
    }
    
    //MARK: Seconds to HMS Conversion
    func timeFormatted(totalSeconds: Int) -> String
    {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    //MARK: Get All Recordings
    
    func getRecordings()
    {
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            self.recordings = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("m4a")
                
            })
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong listing recordings")
        }
    }
    //MARK: Play Audio Method
    
    func play(url:NSURL, index:Int)
    {
        print("playing \(url)")
        
        let file = recordings[index].lastPathComponent
        var fileName  = file?.componentsSeparatedByString("+")
        let mode = (fileName![0].componentsSeparatedByString("|"))[1]
    
        let cell = self.mTableRecordings.cellForRowAtIndexPath(self.myIndex) as! CC_Recordings
        cell.mViewPlotVisualisation.clear()
        
        do {
//            self.player = try AVAudioPlayer(contentsOfURL: url)
//            player.delegate=self
//            player.prepareToPlay()
//            player.volume = 1.0
            
            let audioFile = EZAudioFile(URL:url)
            self.player =  EZAudioPlayer(audioFile:audioFile)
            self.player.delegate = self
            self.player.play()
            self.player.volume = 1.0
        
            
            frequencyValue = 0.000000
            var path = String()
            if(mode == "classic")
            {
                path = "\(NSBundle.mainBundle().resourcePath!)/classic.mp3"
            }
            else{
                path = "\(NSBundle.mainBundle().resourcePath!)/synthesized.mp3"
            }
            let soundUrl = NSURL.fileURLWithPath(path)
            beatPlayer = nil
            do {
                beatPlayer = try AVAudioPlayer(contentsOfURL: soundUrl)
            }
            catch _ {
            }
            beatPlayer.delegate = self
            beatPlayer.volume = 1.0
            
            let path1 = "\(NSBundle.mainBundle().resourcePath!)/zznoise-only.mp3"
            let soundUrl1 = NSURL.fileURLWithPath(path1)
            noiseAudioPlayer = nil
            do {
                noiseAudioPlayer = try AVAudioPlayer(contentsOfURL: soundUrl1)
            }
            catch  _ {
            }
            noiseAudioPlayer.numberOfLoops = -1
            noiseAudioPlayer.volume = 0.12
            noiseAudioPlayer.play()
            isPlay = false
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
    //Audio Player Delegates
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
//    {
////        playing=false
////        let cell = mTableRecordings.cellForRowAtIndexPath(myIndex) as! CC_Recordings
//        dispatch_async(dispatch_get_main_queue(), {
//
////            cell.mViewPlotVisualisation.hidden = true
////            cell.mBtnPlay.setImage(UIImage(named: "playBtn"), forState: .Normal)
//        })
//     }
    
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
    
    
    //MARK: EZAudioPlayerDelegate
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!)
    {
        
         let cell = self.mTableRecordings.cellForRowAtIndexPath(self.myIndex) as! CC_Recordings
        
        dispatch_async(dispatch_get_main_queue(), {
//            if(!self.mixingFiles)
//            {
                var f: Float = 0.000311
                cell.mViewPlotVisualisation.updateBuffer(&f, withBufferSize: bufferSize)
                
//            }
        })
        
        let buff = (buffer[0])
        var sum: Float = 0.0
        for k in 0..<bufferSize {
            sum += buff[Int(k)] * buff[Int(k)]
        }
        
        frequencyValue = sqrtf(sum / Float(bufferSize))
        let decibels = MainViewController().getDecibelsFromVolume(buffer, withBufferSize: bufferSize)
        
        print("Frequency value --->>> \(frequencyValue)")
        print("Decible recording --->>> \(decibels)")

        if(decibels < 0.034000)
       {
            if (frequencyValue > 0.000250 && frequencyValue < 0.001000)
            {
//                if(mixingFiles)
//                {
//                    let fileName = recordings[shreIndexPath.row].lastPathComponent
//                    let audioName  = fileName?.componentsSeparatedByString("+")
//                    let name = (audioName![0].componentsSeparatedByString("|"))[0].stringByAppendingString(".mp4")
//                    let mode = (audioName![0].componentsSeparatedByString("|"))[1]
//                    
//                    if(Int(player.currentTime) > previousFrameTime)
//                    {
//                        print(previousFrameTime)
//
//                        previousFrameTime = Int(player.currentTime)
//                        print(previousFrameTime)
//
//                        mix(mode, name: fileName!,time:Int(player.currentTime) *  10)
//                    }
//                }
//                    
//                else if isPlay == false && !mixingFiles{
////                    isPlay = true
////                    beatPlayer.play()
////                    beatPlayer.volume = 0
                
                    cell.mViewPlotVisualisation.updateBuffer(buffer[0], withBufferSize: bufferSize)
//                  }
            }
        }
        else  if (frequencyValue > 0.000450 && frequencyValue < 0.001000)
        {
//            if(mixingFiles)
//            {
//                let fileName = recordings[shreIndexPath.row].lastPathComponent
//                let audioName  = fileName?.componentsSeparatedByString("+")
//                let name = (audioName![0].componentsSeparatedByString("|"))[0].stringByAppendingString(".mp4")
//                let mode = (audioName![0].componentsSeparatedByString("|"))[1]
//                
//                if(Int(player.currentTime) > previousFrameTime)
//                {
//                    print(previousFrameTime)
//                    
//                    previousFrameTime = Int(player.currentTime)
//                    print(previousFrameTime)
//                    
//                    mix(mode, name: fileName!,time:Int(player.currentTime) *  10)
//                }
//            }
//                
//            else if isPlay == false && !mixingFiles{
////                isPlay = true
////                beatPlayer.play()
////                beatPlayer.volume = 0
            
                cell.mViewPlotVisualisation.updateBuffer(buffer[0], withBufferSize: bufferSize)
//            }
        }
    
   //     previousFrequency = frequencyValue
        
    }
    
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        if(!mixingFiles)
        {
            
            mTableRecordings.scrollEnabled = true

            beatPlayer.stop()
            noiseAudioPlayer.stop()
            
            playing=false
            let cell = mTableRecordings.cellForRowAtIndexPath(myIndex) as! CC_Recordings
            dispatch_async(dispatch_get_main_queue(), {
                cell.mViewPlotVisualisation.clear()
                cell.mViewGraph.hidden = true
                cell.mViewOverGraph.hidden = true

                cell.mViewDetails.hidden = false
                cell.mBtnPlay.setImage(UIImage(named: "playBtn"), forState: .Normal)
            })
        }
        else
        {
            mixingFiles = false
            player.pause()
            print("Mixing Completed")
          //  mixingFiles = false;
        }
        
    }

    //MARK: Mixing functions
    
    func  mix(mode:String , name:String ,time:Int) {
        
        var cafs = [AnyObject]()
        var mp3s = [AnyObject]()
        cafs = Mixing.cafsFromTemporarydirectory()
        if cafs.count < 1 {
            mp3s = Mixing.getMP3files(mode, fileName: name, continueMixing: false)
        }
        else
        {
            mp3s = Mixing.getMP3files(mode, fileName: name, continueMixing: true)
        }
        cafs = Mixing.getCAFs(mp3s)
        BJIConverter.convertFiles(mp3s, toFiles: cafs)
        
        //  Convert all mp3's to cafs
        let files = cafs
        let times = self.getTimes(time)
        let mixURL = self.getMixURL()
        let status = PCMMixer.mixFiles(files, atTimes: times, toMixfile: mixURL)
        Mixing.playMix(mixURL, withStatus: status)

//        BJIConverter.convertFile(mixURL, toFile: mixURL.stringByReplacingOccurrencesOfString(".caf", withString: ".aiff"))

        print("mix")
    }
    
    
    
   
//    func getFiles() -> [AnyObject] {
//        let inFile = NSBundle.mainBundle().pathForResource("toms.caf", ofType: nil)!
//        return [inFile, inFile, inFile, inFile]
//    }
    
    func getTimes(time:Int) -> [AnyObject] {
        //  First item must be at time 0. All other sounds must be relative to this first sound.
        let cafs = Mixing.cafsFromTemporarydirectory()
        if cafs.count < 1 {
            return [Int(0), Int(0), Int(time)]
        }
        return [Int(0), Int(time)]
    }
    
    func getMixURL() -> String {
        let tmpDir = NSTemporaryDirectory();
       // var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return NSURL(fileURLWithPath: tmpDir).URLByAppendingPathComponent("aaaMix.caf").absoluteString
    }

}
