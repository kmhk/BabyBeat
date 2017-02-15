//
//  MainViewController.h
//  Baby Beat
//
//  Created by OSX on 29/09/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"
#import <RESideMenu/RESideMenu.h>
#import <CoreMotion/CoreMotion.h>


@interface MainViewController : UIViewController<EZAudioPlayerDelegate, EZMicrophoneDelegate, EZRecorderDelegate,AVAudioPlayerDelegate>
{
    
    
    AVAudioPlayer * beatPlayer ;
    AVAudioPlayer * noiseAudioPlayer ;
    
    float frequencyValue;
    float previousFrequency;
    
    BOOL isPlay ;
    BOOL mBoolSynthesized ;
    
    float tempFrequencyValue1;
    float tempFrequencyValue2;
    float tempFrequencyValue3;
    NSString *audioSource;
    int i;
    
    int timerCount;
    NSURL *soundFileURL;
    
    EZAudioPlayer *player;
    NSMutableDictionary *mDictViewControllersByIdentifier;//View Controller Identifiers Array
    NSString *mStrName; //Name Variable for Recorder
    UITextField* nameTF;
    
    float pitchValue;
    
    
    IBOutlet UIButton *startRecordingBtn;
    
    IBOutlet UILabel *minDeciblLbl;
    IBOutlet UILabel *maxDeciblLbl;
    IBOutlet UILabel *deciblValueLbl;
    IBOutlet UILabel *frequenyValueLbl;
    
    int callFunctionCount;
    
    float minComapreDecibalValue;
    float maxComapreDecibalValue;

    float mindecibleValue;
    float maxdecibleValue;
    float minCompareFrequency ;
    float maxCompareFrequency ;


    BOOL isDecibalFloat;
    BOOL isRecordStart;
    BOOL isRecordingPlaying;
    
    NSString * modelName;

    
    NSMutableArray * decibalArray;
    
}




//------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------


@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mCnstHeaderHeight;
@property (nonatomic, weak) IBOutlet UIImageView *mImgVwBackground;

@property (strong, nonatomic) IBOutlet UIView *mViewWeekCount;
@property (strong, nonatomic) IBOutlet UIView *mViewRecording;
@property (strong, nonatomic) IBOutlet EZAudioPlotGL *mViewPlotVisualisation;

@property (strong, nonatomic) IBOutlet EZAudioPlot *mGraphView;

@property (strong, nonatomic) IBOutlet UIView *mViewPopPlayer;
@property (strong, nonatomic) IBOutlet UILabel *mLblTimer;
@property (strong, nonatomic) IBOutlet UILabel *mLblWeekCount;


@property (strong, nonatomic) IBOutlet UIButton *mBtnPopPlay;
@property (weak, nonatomic) IBOutlet UIButton *mBtnChangeMode;
@property (strong, nonatomic) IBOutlet UIButton *mBtnOpen;
@property (strong, nonatomic) IBOutlet UIButton *mBtnHelp;
@property (strong, nonatomic) IBOutlet UIButton *mBtnRecordings;
@property (strong, nonatomic) IBOutlet UIButton *mBtnSettings;
@property (strong, nonatomic) IBOutlet UIButton *mBtnRecord;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) EZMicrophone *microphone;
@property (strong, nonatomic) EZRecorder *recorderEZ;
@property (strong, nonatomic) NSTimer *timer;


@property (strong, nonatomic) CMMotionManager *motionManager;


//@property (nonatomic) sqlite3 *contactDB;



//------------------------------------------------------------------------------
#pragma mark - Actions
//------------------------------------------------------------------------------

- (IBAction)mBtnChangeModeAction:(id)sender;
- (IBAction)setSessionPlayback:(id)sender;
- (IBAction)mBtnOpenButtonsAction:(id)sender;
- (IBAction)mBtnSideBarAction:(id)sender; 
- (IBAction)mBtnStopAction:(id)sender;
- (IBAction)mBtnNaviationAction:(id)sender;
- (IBAction)mBtnCustomPopAcions:(id)sender; //Custom PopUP Action

- (float)getDecibelsFromVolume:(float**)buffer withBufferSize:(UInt32)bufferSize;


@end
