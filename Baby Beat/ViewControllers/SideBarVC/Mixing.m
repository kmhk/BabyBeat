//
//  Mixing.m
//  Baby Beat
//
//  Created by OSX on 05/10/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

#import "Mixing.h"
#import "PCMMixer.h"

@implementation Mixing
@synthesize avAudio;

+ (NSArray*)cafsFromTemporarydirectory {
    //  Find all mp3's in bundle
    NSString* tmpDir = NSTemporaryDirectory();
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:tmpDir error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.caf'"];
    NSArray *mp3s = [dirContents filteredArrayUsingPredicate:fltr];
    
    //  Convert mp3's to their full paths
    NSMutableArray *cafs = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [cafs addObject:[tmpDir stringByAppendingPathComponent:file]];
    }];
    return cafs;
}

+(NSArray*)getMP3files:(NSString*) mode  fileName:(NSString*)file continueMixing:(BOOL)contMixing
{
    //files to mix
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSMutableArray *mp3s = [[NSMutableArray alloc]init];
    if([mode isEqualToString:@"classic"])
    {
        [mp3s addObject:@"classic.mp3"];
    }
    else
    {
        [mp3s addObject:@"synthesized.mp3"];
    }
    if(!contMixing)
    {
        [mp3s addObject:@"zznoise-only.mp3"];
    }
    
    NSMutableArray *fullmp3s = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullmp3s addObject:[bundleRoot stringByAppendingPathComponent:file]];
    }];

    //get recorded file
    if(!contMixing)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        docPath = [docPath stringByAppendingPathComponent:file];
        //    NSURL *url = [NSURL fileURLWithPath:docPath];
        
        [fullmp3s addObject:docPath];
    }
    else
    {
        NSArray* cafs = [self cafsFromTemporarydirectory];
        NSLog(@"dff");
        
        [fullmp3s addObject:[cafs objectAtIndex:1]];
//            cafs = Mixing.getCAFs(mp3s)
        //            BJIConverter.convertFiles(mp3s, toFiles: cafs)
        //        }
        //        else
        //        {
        //            cafs.removeAtIndex(0)
        //            cafs = Mixing.getCAFs(cafs)
        //        }

    }

    return fullmp3s;
}
+ (NSArray*)getCAFs:(NSArray*)mp3s {
    //  Find 'Documents' directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //  Create AIFFs from mp3's
    NSMutableArray *cafs = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [cafs addObject:[docPath stringByAppendingPathComponent:[[file lastPathComponent] stringByReplacingOccurrencesOfString:@".mp3" withString:@".caf"]]];
    }];
    
    NSString *last = cafs.lastObject;
    
    NSArray *arr = [last componentsSeparatedByString:@"|"];
    
    last = [arr[0] stringByAppendingString:@".caf"];
    [cafs removeLastObject];
    [cafs addObject:last];
    
    return cafs;
}
+ (void)playMix:(NSString*)mixURL withStatus:(OSStatus)status {
    if (status == OSSTATUS_MIX_WOULD_CLIP) {
       // [viewController.view setBackgroundColor:[UIColor redColor]];
    } else {
       // [viewController.view setBackgroundColor:[UIColor greenColor]];
        NSString* tmpDir = NSTemporaryDirectory();
        tmpDir = [tmpDir stringByAppendingString:@"aaaMix.caf"];
        
        NSURL *url = [NSURL fileURLWithPath:tmpDir];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"wrote mix file of size %lu : %@", (unsigned long)[urlData length], mixURL);
        
        AVAudioPlayer *avAudioObj = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
      //  [avAudioObj autorelease];
        //self.avAudio = avAudioObj;
        
        [avAudioObj prepareToPlay];
        [avAudioObj play];
    }
}
+(OSStatus)mixFiles:(NSArray*)files atTimes:(NSArray*)times  mixURL:(NSString*)mixURL
{
    OSStatus status = [PCMMixer mixFiles:files atTimes:times toMixfile:mixURL];
    return status;
}



@end
