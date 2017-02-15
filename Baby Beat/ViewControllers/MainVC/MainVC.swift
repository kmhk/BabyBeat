//
//  MainVC.swift
//  Baby Beat
//
//  Created by OSX on 16/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class MainVC: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate, EZMicrophoneDelegate,AVAudioPlayerDelegate ,EZAudioFileDelegate ,EZAudioPlayerDelegate,EZRecorderDelegate
{
    
    //MARK: IBOutlets
    
    @IBOutlet var mCnstHeaderHeight: NSLayoutConstraint!
    @IBOutlet var mImgVwBackground: UIImageView!
    
    @IBOutlet weak var mViewWeekCount: UIView!
    @IBOutlet weak var mViewRecording: UIView!
    @IBOutlet var mViewPlotVisualisation: EZAudioPlotGL!
    
    @IBOutlet var mViewPopPlayer: UIView!
    @IBOutlet var mLblTimer: UILabel!
    @IBOutlet weak var mLblWeekCount: UILabel!
    
    @IBOutlet var mBtnPopPlay: UIButton!
    @IBOutlet weak var mBtnChangeMode: UIButton!
    @IBOutlet var mBtnOpen: UIButton!
    @IBOutlet var mBtnHelp: UIButton!
    @IBOutlet var mBtnRecordings: UIButton!
    @IBOutlet var mBtnSettings: UIButton!
    @IBOutlet weak var mBtnRecord: UIButton!
    

    //MARK: Variable Declarations
    var mStrName=String() //Name Variable for Recorder
    var mDictViewControllersByIdentifier=NSMutableDictionary() //View Controller Identifiers Array
    var player:EZAudioPlayer!
    var microphone = EZMicrophone()
    var recorderEZ: EZRecorder! //Audio Recorder
    var soundFileURL:NSURL!
    var timerCount = Int()
    var timer = NSTimer()
    var mBoolSynthesized=Bool()
    
    
    var beatPlayer: AVAudioPlayer! = nil
    var noiseAudioPlayer: AVAudioPlayer! = nil
    var frequencyValue = Float();
    var previousFrequency = Float();
    var playingAudioPlot = EZAudioPlot()
    var isPlay = Bool();
    var audioSource = String()
    
    //MARK: View Controller Delegates
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        showHideButtons() //Hide Buttons Initially
        mViewRecording.hidden=true //Hide Recording View

        
        
        //Set Session for Play
//        setSessionPlayback()
        self.setSessionPlayAndRecord()

        mViewPlotVisualisation.backgroundColor = UIColor.clearColor()
        mViewPlotVisualisation.color = UIColor(red: 235/255, green: 120/255, blue: 104/255, alpha: 1.0)
        mViewPlotVisualisation.plotType = EZPlotType.Rolling
        mViewPlotVisualisation.shouldFill=true
        mViewPlotVisualisation.shouldMirror=false
       
        
        microphone.delegate=self //Delegate for Visualisation
        
        //Set Custom Popup UI
        mViewPopPlayer.hidden=true
        mViewPopPlayer.setGradient(UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0), color2: UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0), loc1: 0.1, loc2: 0.5)
        mViewPopPlayer.setShadowView(3.0, opacity: 0.7, size: CGSizeMake(0,5))
        mViewPopPlayer.setCornerRadiusView(8.0)
        
        let modelName = UIDevice.currentDevice().modelName
        if(modelName=="iPhone+")
        {
            mCnstHeaderHeight.constant=93.0
        }
        else
        {
            mCnstHeaderHeight.constant=64.0
        }
        
        if(modelName=="iPad")
        {
            mBtnRecord.setCornerRadiusButton(mBtnRecord.frame.size.width/2)
            mBtnOpen.setCornerRadiusButton(mBtnOpen.frame.size.width/2)
            mBtnHelp.setCornerRadiusButton(mBtnHelp.frame.size.width/2)
            mBtnRecordings.setCornerRadiusButton(mBtnRecordings.frame.size.width/2)
            mBtnSettings.setCornerRadiusButton(mBtnSettings.frame.size.width/2)
        }
        else
        {
            mBtnRecord.setCornerRadiusButton(mBtnRecord.frame.size.width/4)
            mBtnOpen.setCornerRadiusButton(mBtnOpen.frame.size.width/4)
            mBtnHelp.setCornerRadiusButton(mBtnHelp.frame.size.width/4)
            mBtnRecordings.setCornerRadiusButton(mBtnRecordings.frame.size.width/4)
            mBtnSettings.setCornerRadiusButton(mBtnSettings.frame.size.width/4)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        recorderEZ = nil
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSUserDefaults.standardUserDefaults().setObject("main", forKey: "currentScreen")

         NSLog("%ld", mViewPlotVisualisation.defaultRollingHistoryLength());
        
//         currentScreen="main"
        mImgVwBackground.setBackground()
        
        mLblWeekCount.text="\(userdefaults.integerForKey("weekCount"))" // Set Week Count to 0 initially
        
        //Set the corner radius to all
        mViewWeekCount.setCornerRadiusView(mViewWeekCount.frame.size.height/2)
     
        mViewRecording.setCornerRadiusView(8.0)
        
        //Set Shadow
        mBtnOpen.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnHelp.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnRecordings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        mBtnSettings.setShadow(10, opacity: 0.8, size: CGSizeMake(0, 6))
        
        mViewRecording.setShadowView(5.0, opacity: 0.8, size: CGSizeMake(0,5))
    }
    
    //MARK: IBActions
    @IBAction func mBtnRecordAction(sender: AnyObject) //Record Button
    {
        let alert = UIAlertController(title: "Recording Name", message: "Add name to your recording", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Start", style: .Default, handler: {action in
                    self.mViewRecording.hidden=false  //Unhide the Recording View
            
                    if self.recorderEZ == nil      //Start Recording first time
                    {
                        self.setupRecorder()
                        self.setSessionPlayAndRecord()
//                        self.recordWithPermission(true)
                        self.mViewPlotVisualisation.clear()
                        self.microphone.startFetchingAudio()
                        self.timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainVC.updateTime), userInfo: nil, repeats: true)
                        return
                    }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in }))
        
        alert.addTextFieldWithConfigurationHandler({textfield in
            textfield.placeholder="Name"
            textfield.delegate=self
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func mBtnChangeModeAction(sender: UIButton)  //Change the mode b/w Classic and Synthesized
    {
        if(sender.tag==100) //Tag for Classic
        {
            mBoolSynthesized=true
            sender.setBackgroundImage(UIImage(named: "synthesizeBtn"), forState: .Normal)
            sender.tag=101
        }
        else if(sender.tag==101) //Tag for Synthesize
        {
            mBoolSynthesized=false
            sender.setBackgroundImage(UIImage(named: "classicBtn"), forState: .Normal)
            sender.tag=100
        }
    }
    
    @IBAction func mBtnOpenButtonsAction(sender: AnyObject) //To Show and Hide The Tab Bar Buttons
    {
        showHideButtons()
    }
    
    @IBAction func mBtnSideBarAction(sender: AnyObject) //Show Side Menu Button
    {
        self.sideMenuViewController.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideBarVC") as! sideBarVC
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    
    @IBAction func mBtnStopAction(sender: AnyObject) //Stop Recording Button
    {
        microphone.stopFetchingAudio()
        mViewPlotVisualisation.clear()
        timer.invalidate() //Invalidate the timer
        timerCount=0
        mLblTimer.text="00:00:00"
        mViewRecording.hidden=true //Hide the recording view
        recorderEZ.closeAudioFile() //Stop Recorder
        
        
        let session = AVAudioSession.sharedInstance() //Sesion Start
        do
        {
            try session.setActive(false)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func mBtnNaviationAction(sender: AnyObject)
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
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("helpVC") as! helpVC
            self.sideMenuViewController.setContentViewController(nxtObj, animated: true)
        }
    }
    
    
    
    @IBAction func mBtnCustomPopAcions(sender: UIButton) //Custom PopUP Action
    {
        
        let data = NSData(contentsOfURL: self.soundFileURL)
        var bufferList=getbufferListFromData(data!)
        if(mBoolSynthesized==true)
        {
        //    bufferList.mBuffers.mDataByteSize=bufferList.mBuffers.mDataByteSize
            audioSource = "synthesized.mp3"
        }
        else
        {
            audioSource = "classic.mp3"

        //    bufferList.mBuffers.mDataByteSize=bufferList.mBuffers.mDataByteSize/(5)
        }
        let myData = NSMutableData()
        let audioBuffer=bufferList.mBuffers
        let frame = UnsafeMutablePointer<Float64>(audioBuffer.mData)
        myData.appendBytes(frame, length: Int(audioBuffer.mDataByteSize))
        do
        {
            try myData.writeToURL(self.soundFileURL, options: NSDataWritingOptions.DataWritingFileProtectionNone)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        if(sender.tag==50) //Cancel Button Clicked
        {
            mViewPopPlayer.hidden=true
            recorderEZ=nil
        }
        else if(sender.tag==51)//Play Button Clicked
        {
            setSessionPlayback()

            mViewPopPlayer.hidden=true
            sender.setTitle("Done", forState: .Normal)
            do {
                
                print(self.soundFileURL)
                let audioFile = EZAudioFile(URL:self.soundFileURL)
                self.player = EZAudioPlayer(audioFile:audioFile)
                self.player.delegate = self
                self.player.prepareForInterfaceBuilder()
                self.player.play()
                self.player.volume = 1

                self.recorderEZ=nil

                frequencyValue = 0.000000
                let path = "\(NSBundle.mainBundle().resourcePath!)/\(audioSource)"
                let soundUrl = NSURL.fileURLWithPath(path)
                beatPlayer = nil
                do {
                    beatPlayer = try AVAudioPlayer(contentsOfURL: soundUrl)
                }
                catch _ {
                }
                beatPlayer.delegate = self
                beatPlayer.volume = 1.0
                beatPlayer.prepareToPlay()

                
                let path1 = "\(NSBundle.mainBundle().resourcePath!)/zznoise-only.mp3"
                let soundUrl1 = NSURL.fileURLWithPath(path1)
                noiseAudioPlayer = nil
                do {
                    noiseAudioPlayer = try AVAudioPlayer(contentsOfURL: soundUrl1)
                }
                catch  _ {
                }
                noiseAudioPlayer.numberOfLoops = -1
                noiseAudioPlayer.volume = 0.5
                noiseAudioPlayer.prepareToPlay()
                noiseAudioPlayer.play()
                isPlay = false
                
                } catch let error as NSError {
                self.player = nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
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

    //MARK: Play and Record Methods
    func setSessionPlayback() //Set Session Category
    {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayback)
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
    }
    
    func checkHeadphones() //Check for Headphones
    {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0
        {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones
                {
                    let alert = UIAlertController(title: "Information!!",
                        message: "Please remove your headphones to start recording!",
                        preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
                        print("keep was tapped")
                    }))
                    self.presentViewController(alert, animated:true, completion:nil)
                    print("headphones are plugged in")
                    break
                } else
                {
                    print("headphones are unplugged")
                }
            }
        }
        else
        {
            print("checking headphones requires a connection to a device")
        }
    }
    
//    func recordWithPermission(setup:Bool) //Set Record Permissions
//    {
//        let session:AVAudioSession = AVAudioSession.sharedInstance()
//        // ios 8 and later
//        
//        if (session.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
//            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
//                if granted {
//                    print("Permission to record granted")
//                    self.setSessionPlayAndRecord()
//                    if setup
//                    {
//                        self.setupRecorder()
//                    }
//                    self.microphone.startFetchingAudio()
//                   self.timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainVC.updateTime), userInfo: nil, repeats: true)
//                   // self.recorderEZ
//                } else {
//                    print("Permission to record not granted")
//                }
//            })
//        } else {
//            print("requestRecordPermission unrecognized")
//        }
//    }
    
    func setSessionPlayAndRecord() //Create a session to play and record
    {
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() //Setup Recorder
    {
        var count=Int()
        count=NSUserDefaults.standardUserDefaults().integerForKey("count")
        count=count+1
        var currentFileName = String()
        if(mBoolSynthesized==true)
        {
            currentFileName = "\(mStrName)-syn+\(mLblWeekCount.text!).m4a"
        }
        else{
            currentFileName = "\(mStrName)-classic+\(mLblWeekCount.text!).m4a"
        }
        print(currentFileName)
        NSUserDefaults.standardUserDefaults().setInteger(count, forKey: "count")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
//        let recordSettings:[String : AnyObject] = [
//            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
//            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
//            AVEncoderBitRateKey : 16,
//            AVNumberOfChannelsKey: 1,
//            AVSampleRateKey : 8000.0
//        ]
//        recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
//        recorder.delegate = self
//        recorder.meteringEnabled = true
//        recorder.prepareToRecord() // creates/overwrites the f
        print(self.soundFileURL)
        do {
            recorderEZ = EZRecorder(URL:self.soundFileURL,clientFormat:self.microphone.audioStreamBasicDescription(),fileType:EZRecorderFileType.M4A,
                delegate:self)
            recorderEZ.delegate = self
        // creates/overwrites the file at soundFileURL
        }
       //     catch let error as NSError
//        {
//            recorderEZ = nil
//            print(error.localizedDescription)
//        }
    }
    
    //MARK: AudioPlayer Delegates
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        isPlay = false;
    }
    
//    //MARK: AVAudio Recorder Delegates
//    
//    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
//        successfully flag: Bool)
//    {
//        
//        mBtnPopPlay.setTitle("Play", forState: .Normal)
//        mViewPopPlayer.hidden=false
//        mViewPopPlayer.transform=CGAffineTransformMakeScale(0.1, 0.1)
//        
//        UIView.animateWithDuration(0.2, animations: {
//            self.mViewPopPlayer.transform=CGAffineTransformIdentity
//        })
//    }
//    
//    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
//        error: NSError?)
//    {
//        if let e = error {
//            print("\(e.localizedDescription)")
//        }
//    }
    
    //MARK: Convert Data to Buffer
    
    func getbufferListFromData(data: NSData) -> AudioBufferList
    {
        let len = data.length
        let byteData = malloc(len)
        memcpy(byteData, data.bytes, len)
        var dataBuffer = AudioBufferList()
        dataBuffer.mNumberBuffers=1
        dataBuffer.mBuffers.mDataByteSize=UInt32(len)
        dataBuffer.mBuffers.mNumberChannels=1
        dataBuffer.mBuffers.mData = byteData
        return dataBuffer
    }
    
    
    //MARK: TextField Delegates
    func textFieldDidEndEditing(textField: UITextField)
    {
        mStrName=textField.text!
    }
    
    //MARK: EZMicrophone Delegates
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32)
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.mViewPlotVisualisation.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        self.recorderEZ.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
            
    }
    
    //MARK: Update Timer of Recording
    func updateTime()
    {
       mLblTimer.text=timeFormatted(++timerCount)
    }
    
    //MARK: Seconds to HMS Conversion
    func timeFormatted(totalSeconds: Int) -> String
    {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    //MARK: EZAudioPlayerDelegate
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!) {
        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            self.mViewPlotVisualisation.updateBuffer(buffer[0], withBufferSize: bufferSize)
//        })
        
        let buff = (buffer[0])
        var sum: Float = 0.0
        for k in 0..<bufferSize {
            sum += buff[Int(k)] * buff[Int(k)]
        }
        frequencyValue = sqrtf(sum / Float(bufferSize))

        if (frequencyValue - previousFrequency > 0.000300 && frequencyValue - previousFrequency < 0.000700) {
            if (frequencyValue > 0.000400 && frequencyValue < 0.001100) {
                if isPlay == false {
                    isPlay = true
                    beatPlayer.volume = 1
                    beatPlayer.play()
                }
            }
        }
        previousFrequency = frequencyValue
        
    }

    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        beatPlayer.stop()
        noiseAudioPlayer.stop()
        
        let alert=UIAlertController(title: "Information!", message: "You can listen to recording again in recording List", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: {action in}))
        self.presentViewController(alert, animated:true, completion: nil)

    }
    
    //MARK:  EZRecorderDelegate
    //------------------------------------------------------------------------------
    
    func recorderDidClose(recorder: EZRecorder!) {
        recorderEZ.delegate = nil
        
  
        mBtnPopPlay.setTitle("Play", forState: .Normal)
        mViewPopPlayer.hidden=false
        mViewPopPlayer.transform=CGAffineTransformMakeScale(0.1, 0.1)
        
        UIView.animateWithDuration(0.2, animations: {
            self.mViewPopPlayer.transform=CGAffineTransformIdentity
        })

    }
    func recorderUpdatedCurrentTime(recorder: EZRecorder!) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.mLblTimer.text=self.timeFormatted(++self.timerCount)
        })

    }
}
