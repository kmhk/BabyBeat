//
//  Mixing.h
//  Baby Beat
//
//  Created by OSX on 05/10/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#define OSSTATUS_MIX_WOULD_CLIP 8888

@interface Mixing : NSObject
{
    AVAudioPlayer* avAudio;
}
@property (nonatomic, retain) AVAudioPlayer *avAudio;
+ (NSArray*)cafsFromTemporarydirectory;
+ (NSArray*)getMP3files:(NSString*) mode  fileName:(NSString*)file continueMixing:(BOOL)contMixing;
+(OSStatus)mixFiles:(NSArray*)files atTimes:(NSArray*)times  mixURL:(NSString*)mixURL;
+ (NSArray*)getCAFs:(NSArray*)mp3s ;
+ (void)playMix:(NSString*)mixURL withStatus:(OSStatus)status ;
@end
