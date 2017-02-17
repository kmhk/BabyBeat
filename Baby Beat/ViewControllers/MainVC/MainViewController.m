//
//  MainViewController.m
//  Baby Beat
//
//  Created by OSX on 29/09/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

#import "MainViewController.h"
#import <Baby_Beat-Swift.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize mBtnSettings,mBtnHelp,mBtnOpen,mLblTimer,mBtnRecord,mBtnPopPlay,mLblWeekCount,mBtnChangeMode,mBtnRecordings,mViewRecording,mViewPopPlayer,mCnstHeaderHeight,mViewPlotVisualisation;



//-(void)outputAccelertionData:(CMAcceleration)acceleration
//{
//
//}
//-(void)outputRotationData:(CMRotationRate)rotation
//{
//
//}

-(void)handleDeviceMotionUpdate:(CMDeviceMotion*)deviceMotion
{
    
    //  NSLog(@"%@",deviceMotion.attitude);
    
    pitchValue = 180 / M_PI * deviceMotion.attitude.pitch;
    NSLog(@"pitch value --- >> %.2f",pitchValue);
    
    //    NSLog(@"%f",deviceMotion.attitude.yaw);
    //     NSLog(@"%f",deviceMotion.attitude.roll);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------->>>
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    //    self.motionManager.accelerometerUpdateInterval = .2;
    //    self.motionManager.gyroUpdateInterval = .2;
    self.motionManager.deviceMotionUpdateInterval = 2.0;
    self.motionManager.showsDeviceMovementDisplay = YES;
    
    
    //    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
    //                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
    //                                                 [self outputAccelertionData:accelerometerData.acceleration];
    //                                                 if(error){
    //
    //                                                     NSLog(@"%@", error);
    //                                                 }
    //                                             }];
    //
    //    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
    //                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
    //                                        [self outputRotationData:gyroData.rotationRate];
    //                                    }];
    
    //    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
    //
    //        [self handleDeviceMotionUpdate:motion];
    //
    //    }];
    
    
    
    
    //-------------------->>>
    
    
    [self showHideButtons]; //Hide Buttons Initially
    mViewRecording.hidden=true; //Hide Recording View
    
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = mViewPopPlayer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor], nil];
    
    [mViewPopPlayer.layer insertSublayer:gradient atIndex:0];
    [mViewPopPlayer setCornerRadiusView:8.0];
    [mViewPopPlayer setShadowView:3.0 opacity:0.7 size:CGSizeMake(0,5)];
    
    self.mViewPlotVisualisation.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.71 blue: 0.365 alpha: 1];
    self.mViewPlotVisualisation.color           = [UIColor colorWithRed:64/255.0 green:34/255.0 blue:62/255.0 alpha:1.0];
    
    
    self.mViewPlotVisualisation.plotType        = EZPlotTypeRolling;
    self.mViewPlotVisualisation.shouldFill      = NO;
    self.mViewPlotVisualisation.shouldMirror    = NO;
    //NSLog(@"%f",self.mViewPlotVisualisation.gain );
    self.mViewPlotVisualisation.gain = 1.5;
    [self.mViewPlotVisualisation setRollingHistoryLength:180];
    
    
    
    [self setSessionPlayAndRecord];
    
    //    //Set Custom Popup UI
    mViewPopPlayer.hidden=true;
    player = [EZAudioPlayer audioPlayerWithDelegate:self];
    
    //    self.microphone = [[EZMicrophone alloc]init];
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    self.mViewRecording.hidden = true;
    
    NSString* modelName = [[UIDevice currentDevice] modelName];// UIDevice.currentDevice().modelName
    if([modelName isEqual:@"iPhone+"])
    {
        mCnstHeaderHeight.constant=93.0;
    }
    else
    {
        mCnstHeaderHeight.constant=64.0;
    }
    
    
    if([modelName isEqual:@"iPad"])
    {
        [mBtnRecord setCornerRadiusButton:mBtnRecord.frame.size.width/2];
        [mBtnOpen setCornerRadiusButton:mBtnOpen.frame.size.width/2];
        [mBtnHelp setCornerRadiusButton:mBtnHelp.frame.size.width/2];
        [mBtnRecordings setCornerRadiusButton:mBtnRecordings.frame.size.width/2];
        [mBtnSettings setCornerRadiusButton:mBtnSettings.frame.size.width/2];
    }
    else
    {
        [mBtnRecord setCornerRadiusButton:mBtnRecord.frame.size.width/4];
        [mBtnOpen setCornerRadiusButton:mBtnOpen.frame.size.width/4];
        [mBtnHelp setCornerRadiusButton:mBtnHelp.frame.size.width/4];
        [mBtnRecordings setCornerRadiusButton:mBtnRecordings.frame.size.width/4];
        [mBtnSettings setCornerRadiusButton:mBtnSettings.frame.size.width/4];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //    self.recorderEZ = nil;
    
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:@"main" forKey:@"currentScreen"];
    [self setBackground:_mImgVwBackground];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"mBoolSynthesized"]==true) //Tag for Classic
    {
        [mBtnChangeMode setBackgroundImage:[UIImage imageNamed:@"synthesizeBtn"] forState:normal];
    }
    else
    {
        [mBtnChangeMode setBackgroundImage:[UIImage imageNamed:@"classicBtn"] forState:normal];
    }
    
    mLblWeekCount.text=[ NSString stringWithFormat:@"%li",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"weekCount"]]; // Set Week Count to 0 initially
    
    //Set the corner radius to all
    [mViewRecording setCornerRadiusView:8.0];
    [_mViewWeekCount setCornerRadiusView:_mViewWeekCount.frame.size.height/2];
    
    //Set Shadow
    
    [self setShadowButton:mBtnOpen radius:10 opacity:0.8 size:CGSizeMake(0, 6)];
    [self setShadowButton:mBtnHelp radius:10 opacity:0.8 size:CGSizeMake(0, 6)];
    [self setShadowButton:mBtnRecordings radius:10 opacity:0.8 size:CGSizeMake(0, 6)];
    [self setShadowButton:mBtnSettings radius:10 opacity:0.8 size:CGSizeMake(0, 6)];
    
    [self setShadowView:mViewRecording radius:5.0 opacity:0.8 size:CGSizeMake(0, 5)];
    
}
//MARK: Helper methods

- (void)setCornerRadiusView:(UIView*)sender radius:(float)radius
{
    sender.layer.cornerRadius = radius;
    sender.layer.masksToBounds = true;
}
- (void)setShadowButton:(UIButton*)sender radius:(float)radius opacity:(float)opacity size:(CGSize)size
{
    sender.layer.masksToBounds=false;
    sender.layer.shadowColor=[[UIColor blackColor] CGColor ];
    sender.layer.shadowOpacity=opacity;
    sender.layer.shadowRadius=radius;
    sender.layer.shadowOffset=size;
}
- (void)setShadowView:(UIView*)sender radius:(float)radius opacity:(float)opacity size:(CGSize)size
{
    sender.layer.masksToBounds=false;
    sender.layer.shadowColor=[[UIColor blackColor] CGColor ];
    sender.layer.shadowOpacity=opacity;
    sender.layer.shadowRadius=radius;
    sender.layer.shadowOffset=size;
}
-(void) setBackground:(UIImageView*) sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if( [userdefaults valueForKey:@"background"]==nil || [[userdefaults valueForKey:@"background"] isEqual:@"turqoise"])
    {
        sender.image= [UIImage imageNamed:@"greenBackground"];
    }
    else if([[userdefaults valueForKey:@"background"] isEqual:@"blue"])
    {
        sender.image= [UIImage imageNamed:@"blueBackground"];
    }
    else if([[userdefaults valueForKey:@"background"] isEqual:@"pink"])
    {
        sender.image= [UIImage imageNamed:@"pinkBackground"];
    }
    else
    {
        sender.image= [UIImage imageNamed:@"greenBackground"];
    }
}


//MARK: IBActions
//MARK: Record Button

- (IBAction)mBtnRecordAction:(id)sender
{
    mBtnRecordings.hidden=true;
    mBtnHelp.hidden=true;
    mBtnSettings.hidden=true;
    
    
    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Recording Name" message:@"Add name to your recording" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start",nil];
    
    Alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    nameTF = [Alert textFieldAtIndex:0];
    nameTF.placeholder = @"Name";
    [Alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Recording Name"])
    {
        if(buttonIndex == 1)
        {
            mViewRecording.hidden=false;  //Unhide the Recording View
            if(self.recorderEZ == nil)      //Start Recording first time
            {
                
                mBtnOpen.hidden = true;
                
                mStrName = nameTF.text;
                [self setupRecorder];
                [self setSessionPlayAndRecord];
                [self.mViewPlotVisualisation clear];
				[startRecordingBtn setTitle:@"STOP" forState:UIControlStateNormal];
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                              target: self
                                                            selector:@selector(updateTime)
                                                            userInfo: nil repeats:YES];
                //            self.timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainVC.updateTime), userInfo: nil, repeats: true)
                //            return
            }
            
            NSLog(@"User Input: %@",nameTF.text);
        }
    }
}

- (IBAction)mBtnStopAction:(id)sender //Stop Recording Button
{
	[startRecordingBtn setTitle:@"RECORD" forState:UIControlStateNormal];
	
    mBtnOpen.hidden = false;
    
    
    [self.microphone stopFetchingAudio];
    [self.mViewPlotVisualisation clear];
    [self.timer invalidate]; //Invalidate the timer
    timerCount=0;
    mLblTimer.text=@"00:00:00";
    mViewRecording.hidden=true ;//Hide the recording view
    [self.recorderEZ closeAudioFile]; //Stop Recorder
    
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    NSError *error;
    //    [session setActive:NO error:&error];
    //    if (error)
    //    {
    //        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    //    }
}


//MARK: Update Timer of Recording
-(void) updateTime
{
    mLblTimer.text= [self timeFormatted:++timerCount];
}

//MARK: Seconds to HMS Conversion
-(NSString*) timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

//MARK: Show and Hide Buttons

- (void)showHideButtons
{
    if(mBtnSettings.hidden) // Show Buttons
    {
        mBtnRecordings.hidden=false;
        mBtnHelp.hidden=false;
        mBtnSettings.hidden=false;
    }
    else //Hide Buttons
    {
        mBtnRecordings.hidden=true;
        mBtnHelp.hidden=true;
        mBtnSettings.hidden=true;
    }
    
}

//MARK: Play and Record Methods

- (void)setSessionPlayback
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    // Override the output to the speaker. Do this after creating the EZAudioPlayer
    // to make sure the EZAudioDevice does not reset this.
    //
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    //    if (error)
    //    {
    //        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    //    }
    
}

//MARK: Check for headphones

- (void)checkHeadphones
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    if(route.outputs.count > 0)
    {
        for (AVAudioSessionPortDescription* desc in [route outputs]) {
            if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Information!!" message:@"Please remove your headphones to start recording!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                NSLog(@"headphones are plugged in");
                
                break;
            }
            else
            {
                NSLog(@"headphones are unplugged");
            }
        }
        
    }
    else
    {
        NSLog(@"checking headphones requires a connection to a device");
    }
    
}
//MARK: Create a session to play and record

-(void) setSessionPlayAndRecord //
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    // Override the output to the speaker. Do this after creating the EZAudioPlayer
    // to make sure the EZAudioDevice does not reset this.
    //
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
}
-(void) setupRecorder //Setup Recorder
{
    int count;
    count= [[NSUserDefaults standardUserDefaults] integerForKey:@"count"];
    count=count+1;
    NSString* currentFileName;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"mBoolSynthesized"]==true)
    {
        currentFileName = [NSString stringWithFormat:@"%@|syn+%@.m4a",mStrName,mLblWeekCount.text];
    }
    else{
        currentFileName = [NSString stringWithFormat:@"%@|classic+%@.m4a",mStrName,mLblWeekCount.text];
    }
    NSLog(@"%@",currentFileName);
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"count"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:documentsDirectory];
    
    soundFileURL = [url URLByAppendingPathComponent:currentFileName];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@",soundFileURL]]){
        
        NSLog(@"soundfile exists");
    }
    
    //    self.microphone = nil;
    
    [self.microphone startFetchingAudio];
    
    //    self.recorderEZ = nil;
    self.recorderEZ = [EZRecorder recorderWithURL:soundFileURL
                                     clientFormat:[self.microphone audioStreamBasicDescription]
                                         fileType:EZRecorderFileTypeM4A
                                         delegate:self];
    //    self.recorderEZ.delegate = self;
    
    player = nil;
    player = [EZAudioPlayer audioPlayerWithDelegate:self];
    
    
}


- (IBAction) mBtnOpenButtonsAction:(id)sender //To Show and Hide The Tab Bar Buttons
{
    [self showHideButtons];
}

- (IBAction)mBtnSideBarAction:(id)sender //Show Side Menu Button
{
    self.sideMenuViewController.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sideBarVC"];
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)mBtnNaviationAction:(id)sender
{
    [player pause];
    [beatPlayer pause];
    [noiseAudioPlayer pause];
    
    
    if([sender tag]==2) //Settings
    {
        [self showHideButtons];
        UIViewController* nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [self.sideMenuViewController setContentViewController:nxtObj animated:true];
    }
    else if([sender tag]==3) //Recordings
    {
        [self showHideButtons];
        [self setSessionPlayAndRecord];
        
        UIViewController* nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingsVC"];
        [self.sideMenuViewController setContentViewController:nxtObj animated:true];
    }
    else if([sender tag]==4) //Help
    {
        [self showHideButtons];
        UIViewController* nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
        [self.sideMenuViewController setContentViewController:nxtObj animated:true];
    }
}

- (IBAction)mBtnCustomPopAcions:(id)sender //Custom PopUP Action
{
    
    NSData* data = [NSData dataWithContentsOfURL:soundFileURL];
    AudioBufferList* bufferList= [self getbufferListFromData:data];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"mBoolSynthesized"]==true)
    {
        audioSource = @"synthesized.mp3";
    }
    else
    {
        audioSource = @"classic.mp3";
    }
    
    NSMutableData *myData= [NSMutableData data];
    
    for( int y=0; y< bufferList->mNumberBuffers; y++ ){
        
        AudioBuffer audioBuffer = bufferList->mBuffers[y];
        Float32 *frame = (Float32*)audioBuffer.mData;
        
        [myData appendBytes:frame length:audioBuffer.mDataByteSize];
        
    }
    
    if(myData.length > 0)
    {
        NSError *error;
        
        [myData writeToURL:soundFileURL options: NSDataWritingFileProtectionNone error:&error];
        if (error)
        {
            NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
        }
    }
    
    if([sender tag]==50) //Cancel Button Clicked
    {
        mViewPopPlayer.hidden=true;
        self.recorderEZ=nil;
    }
    else if([sender tag]==51)//Play Button Clicked
    {
        //        [self setSessionPlayback];
        
        mViewPopPlayer.hidden=true;
        
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        
        EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:soundFileURL];
        [player playAudioFile:audioFile];
        player.delegate = self;
        [player prepareForInterfaceBuilder];
        [player play];
        player.shouldLoop = false;
        player.volume = 1;
        
        self.recorderEZ=nil;
        
        frequencyValue = 0.000000;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],audioSource];
        //        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],audioSource];
        
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        beatPlayer = nil;
        beatPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        beatPlayer.delegate = self;
        beatPlayer.volume = 1.0;
        [beatPlayer prepareToPlay];
        
        NSString *path1 = [NSString stringWithFormat:@"%@/zznoise-only.mp3", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl1 = [NSURL fileURLWithPath:path1];
        noiseAudioPlayer = nil;
        noiseAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl1 error:nil];
        noiseAudioPlayer.numberOfLoops = -1;
        noiseAudioPlayer.volume = 0.12;
        [noiseAudioPlayer prepareToPlay];
        [noiseAudioPlayer play];
        
        isPlay = false;
        
    }
}

-(AudioBufferList *) getbufferListFromData: (NSData *) data
{
    if (data.length > 0)
    {
        NSUInteger len = [data length];
        //I guess you can use Byte*, void* or Float32*. I am not sure if that makes any difference.
        Byte * byteData = (Byte*) malloc (len);
        memcpy (byteData, [data bytes], len);
        if (byteData)
        {
            AudioBufferList * theDataBuffer =(AudioBufferList*)malloc(sizeof(AudioBufferList) * 1);
            theDataBuffer->mNumberBuffers = 1;
            theDataBuffer->mBuffers[0].mDataByteSize = len;
            theDataBuffer->mBuffers[0].mNumberChannels = 1;
            theDataBuffer->mBuffers[0].mData = byteData;
            // Read the data into an AudioBufferList
            return theDataBuffer;
        }
    }
    return nil;
}
//MARK: Change the mode b/w Classic and Synthesized

- (IBAction)mBtnChangeModeAction:(id)sender
{
    mBtnRecordings.hidden=true;
    mBtnHelp.hidden=true;
    mBtnSettings.hidden=true;
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"mBoolSynthesized"]==false) //Tag for Classic
    {
        //        mBoolSynthesized=true;
        [sender setBackgroundImage:[UIImage imageNamed:@"synthesizeBtn"] forState:normal];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"mBoolSynthesized"];
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"mBoolSynthesized"]==true) //Tag for Synthesize
    {
        //        mBoolSynthesized=false;
        [sender setBackgroundImage:[UIImage imageNamed:@"classicBtn"] forState:normal];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"mBoolSynthesized"];
    }
}


//------------------------------------------------------------------------------
#pragma mark - EZMicrophoneDelegate
//------------------------------------------------------------------------------

- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    
    
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.mViewPlotVisualisation updateBuffer:buffer[0]
                                       withBufferSize:bufferSize];
        
    });
    
    
    
}

//------------------------------------------------------------------------------

- (void)   microphone:(EZMicrophone *)microphone
        hasBufferList:(AudioBufferList *)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    [self.recorderEZ appendDataFromBufferList:bufferList
                               withBufferSize:bufferSize];
}


//------------------------------------------------------------------------------
#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlay = false;
}
- (void) audioPlayer:(EZAudioPlayer *)audioPlayer
         playedAudio:(float **)buffer
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
         inAudioFile:(EZAudioFile *)audioFile
{
    
    float * buff = buffer[0];
    
    float sum = 0.0;
    for(int k = 0; k < bufferSize; k++)
    {
        sum += buff[k] * buff[k];
    }
    
    frequencyValue = sqrtf( sum / bufferSize);
    float decibels = [self getDecibelsFromVolume:buffer withBufferSize:bufferSize];
    
    
    // NSLog(@"Frequency value --- >>> %f",frequencyValue);
    NSLog(@"Decible main --->>>   %f",decibels);
    
    
    //    if(frequencyValue - previousFrequency > 0.000260 && frequencyValue - previousFrequency < 0.000700)
    
    if(decibels < 0.036) // iphone 5c
        if (frequencyValue  >  0.000450 && frequencyValue < 0.001000 )
        {
            
            if (isPlay == false)
            {
                isPlay = true;
                if(!beatPlayer.playing)
                {
                    [beatPlayer play];
                    beatPlayer.volume = 1;
                }
            }
        }
    previousFrequency = frequencyValue;
}
- (float)getDecibelsFromVolume:(float**)buffer withBufferSize:(UInt32)bufferSize {
    
    // Decibel Calculation.
    
    float one = 1.0;
    float meanVal = 0.0;
    float tiny = 0.1;
    float lastdbValue = 0.0;
    
    vDSP_vsq(buffer[0], 1, buffer[0], 1, bufferSize);
    
    vDSP_meanv(buffer[0], 1, &meanVal, bufferSize);
    
    vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    
    
    // Exponential moving average to dB level to only get continous sounds.
    
    float currentdb = 1.0 - (fabs(meanVal) / 100);
    
    if (lastdbValue == INFINITY || lastdbValue == -INFINITY || isnan(lastdbValue)) {
        lastdbValue = 0.0;
    }
    
    float dbValue = ((1.0 - tiny) * lastdbValue) + tiny * currentdb;
    
    lastdbValue = dbValue;
    
    return dbValue;
}
-(void) audioPlayer:(EZAudioPlayer *)audioPlayer reachedEndOfAudioFile:(EZAudioFile *)audioFile
{
    [beatPlayer stop];
    [noiseAudioPlayer stop];
    [player pause];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information!" message:@"You can listen to recording again in recording List" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}

//------------------------------------------------------------------------------
#pragma mark - EZRecorderDelegate
//------------------------------------------------------------------------------

- (void)recorderDidClose:(EZRecorder *)recorder
{
    self.recorderEZ.delegate = nil;
    
    [mBtnPopPlay setTitle:@"Play" forState:UIControlStateNormal];
    mViewPopPlayer.hidden=false;
    mViewPopPlayer.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        mViewPopPlayer.transform=CGAffineTransformIdentity;
    }];
    
}

//------------------------------------------------------------------------------

- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder
{
    //    __weak typeof (self) weakSelf = self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        weakSelf.mLblTimer.text = [self timeFormatted:++timerCount];
    //    });
}






@end
