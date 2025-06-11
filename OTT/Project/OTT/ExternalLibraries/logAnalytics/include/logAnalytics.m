//
//  logAnalytics.m
//
//  Created by Mohan Agadkar (mohanagadkar@yupptv.com) on 17/07/17.
//  Copyright © 2017 YuppTV Inc. All rights reserved.
//

#import "logAnalytics.h"
#import "LogKeyChain.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <Security/Security.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define kLogAnalyticVersion @"1.0"
#define tempPPSidValue [NSString stringWithFormat:@"%lli",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]]
#define kLogAnalyticsURLlib     @"http://%@"
#define kKeyCheckBeta           @"http://119.81.201.168:8081/sdk/validation?analytics_id=%@"
#define kKeyCheckProduction     @"https://location.api.yuppcdn.net/sdk/validation?analytics_id=%@"

#pragma mark -
#pragma mark Enums for log events

/* --------------------------------------------------------------
 **  PlayerEvent type for various log events
 ** ----------------------------------------------------------- */
// Enum values for player type
typedef NS_ENUM( NSInteger, PlayerEvent) {
    log_VIDEO_CLICKED,
    log_INITIALIZED,
    log_AD_STARTED,
    log_AD_SKIPPED,
    log_AD_COMPLETED_BY_USER,
    log_AD_COMPLETED,
    log_STARTED,
    log_PLAYBACK_ENDED_BY_USER,
    log_PLAYBACK_ENDED,
    log_SEEKING,
    log_BUFFER_START,
    log_BUFFER_END,
    log_PAUSE,
    log_RESUME,
    log_HEARTBEAT,
    log_ERROR,
    log_BitRateChange,
    log_PAUSE_ON_HOME
};

#pragma mark -
#pragma mark Observer context

/* --------------------------------------------------------------
 **  Reference of the observer context and keys while playing
 ** ----------------------------------------------------------- */
static void *laTimedMetadataObserverContext    = &laTimedMetadataObserverContext;
static void *laRateObservationContext          = &laRateObservationContext;
static void *laCurrentItemObservationContext   = &laCurrentItemObservationContext;
static void *laPlayerItemStatusObserverContext = &laPlayerItemStatusObserverContext;
static void *laPlaybackBufferEmptyObserverContext = &laPlaybackBufferEmptyObserverContext;
static void *laPlaybackLikelyToKeepUpObserverContext = &laPlaybackLikelyToKeepUpObserverContext;
static void *laPlaybackBufferFullObserverContext = &laPlaybackBufferFullObserverContext;
static void *laLoadedTimeRangesObserverContext = &laLoadedTimeRangesObserverContext;

NSString *laTracksKey                  = @"tracks";
NSString *laStatusKey                  = @"status";
NSString *laRateKey                    = @"rate";
NSString *laPlayableKey                = @"playable";
NSString *laCurrentItemKey             = @"currentItem";
NSString *laTimedMetadataKey           = @"currentItem.timedMetadata";
NSString *laPlaybackBufferEmptyKey     = @"playbackBufferEmpty";
NSString *laPlaybackLikelyToKeepUpKey  = @"playbackLikelyToKeepUp";
NSString *laPlaybackBufferFullKey      = @"playbackBufferFull";
NSString *laLoadedTimeRangesKey        = @"loadedTimeRanges";

#pragma mark -
#pragma mark default category for log analytics

/* --------------------------------------------------------------
 **  Default category method, which defines various properties
 **  of the player instance
 ** ----------------------------------------------------------- */
@interface logAnalytics () {
    
    AVPlayer *log_player;
    AVPlayerItem *log_playerItem;
    
    PlayerEvent playerLastEvent;
    
    NSDictionary* logMetaData;
    
    NSString* logAnalyticsKey;
    NSString *Log_Event_domain;
    NSString *collectorApi;
    NSString *programDuration;
    NSString *playerPosition;
    NSString *seekStartPosition;
    NSString *seekEndPosition;
    
    float lastBitRate;
    
    int heartBeatRate;
    int eventCounter;
    int currenTimeSeconds;
    
    NSTimer *heartBeatUpdateTimer;
    
    BOOL apiKeyValid;
    BOOL traceConsole;
    BOOL isPlayStarted;
    BOOL isSeeking;
    
    LogKeyChain *lKC;
}

/// A set of key-value pairs used in resource selection
@property (strong, nonatomic) AVPlayer *log_player;
@property (strong, nonatomic) AVPlayerItem *log_playerItem;

@property (assign) PlayerEvent playerLastEvent;

@property (strong, nonatomic) NSDictionary* logMetaData;

@property (strong, nonatomic) NSString* logAnalyticsKey;
@property (strong, nonatomic) NSString* Log_Event_domain;
@property (strong, nonatomic) NSString* collectorApi;
@property (strong, nonatomic) NSString* programDuration;
@property (strong, nonatomic) NSString* playerPosition;
@property (strong, nonatomic) NSString* seekStartPosition;
@property (strong, nonatomic) NSString* seekEndPosition;

@end

#pragma mark -
#pragma mark Singleton variable

/* --------------------------------------------------------------
 **  Singleton instance for the entire application
 ** ----------------------------------------------------------- */
static logAnalytics *sharedInstance = nil;

@implementation logAnalytics

@synthesize log_player, log_playerItem;
@synthesize playerLastEvent;
@synthesize logMetaData;
@synthesize logAnalyticsKey, Log_Event_domain, collectorApi, programDuration, playerPosition, seekStartPosition, seekEndPosition;;

#pragma mark -
#pragma mark Singleton instance

/* --------------------------------------------------------------
 **  Singleton instance for the entire application
 ** ----------------------------------------------------------- */
+ (logAnalytics *)shared {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    }
    return sharedInstance;
}
- (int) timeStamp {
    return (int)[[NSDate date] timeIntervalSince1970];
}
- (void)checkVersion {
    NSLog(@"Log Analytics framework version %@", kLogAnalyticVersion);
}

- (void)getDevId {
    NSLog(@"Log Analytics id: %@ device id %@", self.logAnalyticsKey, [lKC getToken]);
}

#pragma mark -
#pragma mark init with customer key and settings if any

#pragma mark get vendor details
- (void)getKeyValidatedFromServer:(NSString *)validationUrl {
    NSURL *vendor_url = [NSURL URLWithString:validationUrl];
    //    if (traceConsole) NSLog(@"getKeyValidateFromServer: %@",vendor_url);
    
    NSMutableURLRequest *vendor_request = [NSMutableURLRequest requestWithURL:vendor_url];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:vendor_request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError)
            {
                //                if (traceConsole) NSLog(@"log :: connectionError %@",[connectionError localizedDescription]);
            }
            else
            {
                NSError* error;
                id configData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error) {
                    //                    if (traceConsole) NSLog(@"log :: could not reach server");
                }
                else{
                    //                    if (traceConsole) NSLog(@"log :: configData %@",configData);
                    if ([configData objectForKey:@"collector_api"] && [configData valueForKey:@"collector_api"] != nil && ![[configData valueForKey:@"collector_api"] isEqualToString:@""]) {
                        heartBeatRate = 20;
                        Log_Event_domain = [NSString stringWithFormat:kLogAnalyticsURLlib, [configData valueForKey:@"collector_api"]];
                        if ([configData objectForKey:@"hb_rate"]) {
                            heartBeatRate = [[configData valueForKey:@"hb_rate"] intValue];
                        }
                        apiKeyValid = true;
                        if (traceConsole) NSLog(@"log :: Api key is valid.");
                        [self checkVersion];
                    } else {
                        if ([configData objectForKey:@"is_key_valid"] && [[configData objectForKey:@"is_key_valid"] boolValue] == false) {
                            if (traceConsole) NSLog(@"log :: Api key invalid..");
                        } else {
                            if (traceConsole) NSLog(@"log :: Api key invalid...");
                        }
                    }
                }
            }
        });
    }]resume];
}

- (void)initWithAnalyticsKey:(NSString *)customerKey isLive:(BOOL)isLive andSettings:(NSDictionary *)settings {
    apiKeyValid = false;
    if ([settings objectForKey:@"showLogs"] && [[settings valueForKey:@"showLogs"] boolValue] == true) {
        [self toggleConsole: true];
    } else {
        [self toggleConsole: false];
    }
    if (customerKey != nil && customerKey.length > 0) {
        self.logAnalyticsKey = customerKey;
        if (traceConsole) NSLog(@"log :: Api key: %@.", self.logAnalyticsKey);
        if (isLive == false) {
            [self getKeyValidatedFromServer:[NSString stringWithFormat:kKeyCheckBeta, self.logAnalyticsKey]];
        } else {
            [self getKeyValidatedFromServer:[NSString stringWithFormat:kKeyCheckProduction, self.logAnalyticsKey]];
        }
    } else {
        if (traceConsole) NSLog(@"log :: Api key invalid.");
    }
}

- (void)toggleConsole:(BOOL)on {
    traceConsole = on;
}

#pragma mark -
#pragma mark init Session With MetaData

/* --------------------------------------------------------------
 **  Function to initiate session and metadata
 **  This function is called when video click is initiated
 **  logMetaDict is NSDictionary for various properties
 **  returns if api key is not valid
 ** ----------------------------------------------------------- */
- (void)initSessionWithMetaData:(NSDictionary *)logMetaDict {
    if (apiKeyValid == false) {
        return;
    }
    if (traceConsole) NSLog(@"log :: init session");
    
    [self initDefaultVaules];
    if (traceConsole) NSLog(@"log :: logMetaData: %@", logMetaDict);
    self.logMetaData = [[NSDictionary alloc] initWithDictionary:logMetaDict];
    
    if (traceConsole) NSLog(@"log :-: VIDEO_CLICKED");
    self.playerLastEvent = log_VIDEO_CLICKED;
    [self initLogEvent:self.playerLastEvent];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self->traceConsole) NSLog(@"log :-: INITIALIZED");
        self.playerLastEvent = log_INITIALIZED;
        [self initLogEvent:self.playerLastEvent];
    });

}

- (void)updateMetaData:(NSDictionary *)logMetaDict {
    if (apiKeyValid == false) {
        return;
    }
    if (traceConsole) NSLog(@"log :: Previous logMetaData: %@", self.logMetaData);
    NSMutableDictionary *logMetaData_tmp = [NSMutableDictionary dictionaryWithDictionary: self.logMetaData];
    [logMetaData_tmp addEntriesFromDictionary:logMetaDict];
    self.logMetaData = [[NSDictionary alloc] initWithDictionary:logMetaData_tmp];
    if (traceConsole) NSLog(@"log :: New logMetaData: %@", self.logMetaData);
}

#pragma mark attach player and current item
/* --------------------------------------------------------------
 **  Function to attach player instance with log analytics
 **  this function takes two arguments
 **  basePlayer is AVPlayer instance
 **  currentPlayingItem is AVPlayerItem
 **  Firt video click event is initiated here
 ** ----------------------------------------------------------- */
//- (void)attachPlayer:(AVPlayer*) basePlayer theCurrentPlayingItem:(AVPlayerItem*) currentPlayingItem {
- (void)attachPlayer:(AVPlayer*) basePlayer {
    if (apiKeyValid == false) {
        return;
    }
//    self.log_player = nil;
//    self.log_playerItem = nil;
    
    self.log_player = basePlayer;
    self.log_playerItem = basePlayer.currentItem;
    
    [self addLogObservers];
}

#pragma mark init with Default value
- (void)initDefaultVaules{
    lastBitRate = 0;
    programDuration = @"-1";
    playerPosition = @"-1";
    seekStartPosition = @"-1";
    seekEndPosition = @"-1";
    isPlayStarted = false;
    isSeeking = false;
    lKC = [LogKeyChain alloc];
    [self endHeartBeat];
    heartBeatUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:heartBeatRate target:self selector:@selector(sendHeartBeat:) userInfo:nil repeats:YES];
}

#pragma mark end heart beat
- (void)endHeartBeat {
    if (heartBeatUpdateTimer) {
        [heartBeatUpdateTimer invalidate];
        heartBeatUpdateTimer = nil;
    }
}

#pragma mark send heart beat
- (void)sendHeartBeat:(NSTimer*)timer {
    if (apiKeyValid == false || self.playerLastEvent == log_AD_COMPLETED_BY_USER || self.playerLastEvent == log_PLAYBACK_ENDED || self.playerLastEvent == log_PLAYBACK_ENDED_BY_USER) {
        [self endHeartBeat];
        return;
    }
    if (traceConsole) NSLog(@"log :-: HEARTBEAT");
    //    self.playerLastEvent = log_HEARTBEAT;
    [self initLogEvent:log_HEARTBEAT];
}

#pragma mark create Log Observers
- (void)addLogObservers {
    //    if (traceConsole) NSLog(@"log :: observeValueForKeyPath 2 addObs");
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.log_playerItem addObserver:self
                          forKeyPath:laStatusKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:laPlayerItemStatusObserverContext];
    [self.log_playerItem addObserver:self
                          forKeyPath:laPlaybackBufferEmptyKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:laPlaybackBufferEmptyObserverContext];
    [self.log_playerItem addObserver:self
                          forKeyPath:laPlaybackLikelyToKeepUpKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:laPlaybackLikelyToKeepUpObserverContext];
    [self.log_playerItem addObserver:self
                          forKeyPath:laPlaybackBufferFullKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:laPlaybackBufferFullObserverContext];
    [self.log_playerItem addObserver:self
                          forKeyPath:laLoadedTimeRangesKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:laLoadedTimeRangesObserverContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(logPlayerItemDidReachEnd:)
    //                                                 name:AVPlayerItemDidPlayToEndTimeNotification
    //                                               object:self.log_playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logPlayerHasStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:self.log_playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAVPlayerAccess:)
                                                 name:AVPlayerItemNewAccessLogEntryNotification
                                               object:self.log_playerItem];
    
    /* Observe the AVPlayer "currentItem" property to find out when any
     AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
     occur.*/
    [self.log_player addObserver:self
                      forKeyPath:laCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:laCurrentItemObservationContext];
    
    /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
    [self.log_player addObserver:self
                      forKeyPath:laTimedMetadataKey
                         options:0
                         context:laTimedMetadataObserverContext];
    
    /* Observe the AVPlayer "rate" property to update the scrubber control. */
    [self.log_player addObserver:self
                      forKeyPath:laRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:laRateObservationContext];
}

#pragma mark close session
- (void)closeSession:(BOOL) playReachedEnd {
    if (apiKeyValid == false) {
        return;
    }
    //    if (traceConsole) NSLog(@"log :: closeSession :: 1, playerLastEvent :: %ld, playReachedEnd :: %d", (long)self.playerLastEvent, playReachedEnd);
    if (apiKeyValid == false || self.playerLastEvent == log_AD_COMPLETED_BY_USER || self.playerLastEvent == log_PLAYBACK_ENDED || self.playerLastEvent == log_PLAYBACK_ENDED_BY_USER || self.playerLastEvent == log_ERROR) {
        return;
    }
    //    if (traceConsole) NSLog(@"log :: closeSession :: 2");
    if ((self.playerLastEvent != log_PLAYBACK_ENDED && self.playerLastEvent != log_ERROR) || (self.playerLastEvent == log_VIDEO_CLICKED)) {
        if (self.playerLastEvent == log_AD_STARTED || self.playerLastEvent == log_AD_SKIPPED) {
            if (traceConsole) NSLog(@"log :-: AD_COMPLETED_BY_USER");
            self.playerLastEvent = log_AD_COMPLETED_BY_USER;
            [self initLogEvent:self.playerLastEvent];
            if (([self log_player] && self.log_playerItem)) {
                if (traceConsole) NSLog(@"log :-: PLAYBACK_ENDED.");
                self.playerLastEvent = log_PLAYBACK_ENDED;
                [self initLogEvent:self.playerLastEvent];
            }
        } else if (self.playerLastEvent != log_AD_COMPLETED_BY_USER && self.playerLastEvent != log_PLAYBACK_ENDED_BY_USER && ([self log_player] && self.log_playerItem)){
            if (playReachedEnd) {
                if (traceConsole) NSLog(@"log :-: PLAYBACK_ENDED..");
                self.playerLastEvent = log_PLAYBACK_ENDED;
            } else {
                if (traceConsole) NSLog(@"log :-: PLAYBACK_ENDED_BY_USER.");
                self.playerLastEvent = log_PLAYBACK_ENDED_BY_USER;
            }
            [self initLogEvent:self.playerLastEvent];
        } else {
            if (traceConsole) NSLog(@"log :-: PLAYBACK_ENDED_BY_USER..");
            self.playerLastEvent = log_PLAYBACK_ENDED_BY_USER;
            
            [self initLogEvent:self.playerLastEvent];
        }
    }
    [self removeObserversAndPlayer];
}
#pragma mark remove Observers and Player
- (void)removeObserversAndPlayer{
    
    //    if (traceConsole) NSLog(@"log :: closeSession :: 3");
    //        if (traceConsole) NSLog(@"log :: observeValueForKeyPath 2 closeSession");
    if ([self log_player] && self.log_playerItem) {
        //                if (traceConsole) NSLog(@"log :: observeValueForKeyPath 2 closeSession");
        
        @try {
            [self.log_player removeObserver:self forKeyPath:laCurrentItemKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_player removeObserver:self forKeyPath:laTimedMetadataKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_player removeObserver:self forKeyPath:laRateKey];
        }
        @catch (NSException * __unused exception) {}
        
        @try {
            [self.log_playerItem removeObserver:self forKeyPath:laStatusKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_playerItem removeObserver:self forKeyPath:laPlaybackBufferEmptyKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_playerItem removeObserver:self forKeyPath:laPlaybackLikelyToKeepUpKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_playerItem removeObserver:self forKeyPath:laPlaybackBufferFullKey];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [self.log_playerItem removeObserver:self forKeyPath:laLoadedTimeRangesKey];
        }
        @catch (NSException * __unused exception) {}
        
        //        [[NSNotificationCenter defaultCenter] removeObserver:self
        //                                                        name:AVPlayerItemDidPlayToEndTimeNotification
        //                                                      object:self.log_playerItem];
        
        @try {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:AVPlayerItemPlaybackStalledNotification
                                                          object:self.log_playerItem];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:AVPlayerItemNewAccessLogEntryNotification
                                                          object:self.log_playerItem];
        }
        @catch (NSException * __unused exception) {}
        
    }
    self.log_player = nil;
    self.logMetaData = nil;
    [self endHeartBeat];
}
#pragma mark trigger send Error
- (void)sendError:(NSString*)errorMessage{
    if (apiKeyValid == false) {
        return;
    }
    if (traceConsole) NSLog(@"log :-: ERROR, message: %@", errorMessage);
    
    NSMutableDictionary *logMetaData_tmp = [NSMutableDictionary dictionaryWithDictionary: self.logMetaData];
    [logMetaData_tmp setValue:errorMessage forKey:@"eventMessage"];
    self.logMetaData = [[NSDictionary alloc] initWithDictionary:logMetaData_tmp];
    
    self.playerLastEvent = log_ERROR;
    [self initLogEvent:self.playerLastEvent];
    
    logMetaData_tmp = [NSMutableDictionary dictionaryWithDictionary: self.logMetaData];
    [logMetaData_tmp setValue:@"-1" forKey:@"eventMessage"];
    self.logMetaData = [[NSDictionary alloc] initWithDictionary:logMetaData_tmp];
}
#pragma mark trigger log events
- (void)triggerLogEvent:(eventTrigger)et position:(int)currentPosition {
    if (apiKeyValid == false) {
        return;
    }
    //    if (traceConsole) NSLog(@"log :-: triggerLogEvent: %ld ", (long)et);
    if (et == trigger_seek_start) {
        if (traceConsole) NSLog(@"log :-: SEEK_STARTED");
        isSeeking = true;
        seekStartPosition = [NSString stringWithFormat:@"%d", (currentPosition * 1000)];
    } else if (et == trigger_seek_end) {
        if (traceConsole) NSLog(@"log :-: SEEK_ENDED");
        isSeeking = false;
        seekEndPosition = [NSString stringWithFormat:@"%d", (currentPosition * 1000)];
        self.playerLastEvent = log_SEEKING;
    } else if (et == trigger_ad_start) {
        if (traceConsole) NSLog(@"log :-: AD_STARTED");
        self.playerLastEvent = log_AD_STARTED;
    } else if (et == trigger_ad_skipped) {
        if (traceConsole) NSLog(@"log :-: AD_SKIPPED");
        self.playerLastEvent = log_AD_SKIPPED;
    } else if (et == trigger_ad_completed_by_user) {
        if (traceConsole) NSLog(@"log :-: AD_COMPLETED_BY_USER");
        self.playerLastEvent = log_AD_COMPLETED_BY_USER;
    } else if (et == trigger_ad_completed) {
        if (traceConsole) NSLog(@"log :-: AD_COMPLETED");
        self.playerLastEvent = log_AD_COMPLETED;
    }
    [self initLogEvent:self.playerLastEvent];
}

#pragma mark Player Notifications
- (NSString*)getBitRate {
    NSString* currentBitRate = @"-1";
    if (lastBitRate) {
        currentBitRate = [NSString stringWithFormat:@"%d", (int)(lastBitRate / 1024 + 1)];
    }
    //    if (traceConsole) NSLog(@"log :: --analytics BitRateChange currentBitRate:- %@", currentBitRate);
    return currentBitRate;
}

#pragma mark Player Notifications for bit rate
- (void)handleAVPlayerAccess:(NSNotification *)notif {
    AVPlayerItemAccessLog *accessLog = [((AVPlayerItem *)notif.object) accessLog];
    AVPlayerItemAccessLogEvent *lastEvent1 = accessLog.events.lastObject;
    float lastEventNumber = lastEvent1.indicatedBitrate;
    if (lastEventNumber != lastBitRate) {
        //Here is where you can increment a variable to keep track of the number of times you switch your bit rate.
        //        if (traceConsole) NSLog(@"log :: --analytics BitRateChange: %f to: %f", lastBitRate, lastEventNumber);
        lastBitRate = lastEventNumber;
        // [self getDictionary:BitRateChange];
    }
}

#pragma mark Player Notifications for PlayerItemDidReachEnd
/* Called when the player item has played to its end time. */
- (void)logPlayerItemDidReachEnd:(NSNotification*) aNotification {
    if (traceConsole) NSLog(@"log :-: PLAYBACK_ENDED");
    self.playerLastEvent = log_PLAYBACK_ENDED;
    [self initLogEvent:self.playerLastEvent];
    [self closeSession:true];
}

#pragma mark Player Notifications if player has stalled for some reason
- (void)logPlayerHasStalled:(NSNotification*) aNotification {
    if (traceConsole) NSLog(@"log :-: BUFFER_END 1");
    isSeeking = false;
    self.playerLastEvent = log_BUFFER_END;
    [self initLogEvent:self.playerLastEvent];
}

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

- (void)assetFailedToPrepareForPlayback:(NSError *)error {
    if (traceConsole) NSLog(@"log :: desc: %@", [error localizedDescription]);
    if (traceConsole) NSLog(@"log :: reason: %@", [error localizedFailureReason]);
    if (traceConsole) NSLog(@"log :-: ERROR");
    self.playerLastEvent = log_ERROR;
    [self initLogEvent:self.playerLastEvent];
    [self removeObserversAndPlayer];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    //    if (traceConsole) NSLog(@"log :: observeValueForKeyPath");
    /* AVPlayerItem "status" property value observer. */
    if (context == laPlayerItemStatusObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laPlayerItemStatusObserverContext ");
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        //        if (traceConsole) NSLog(@"log :: status %ld", (long)status);
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                //                if (traceConsole) NSLog(@"log :: AVPlayerStatusUnknown ");
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                if (self.playerLastEvent == log_BUFFER_START) {
                    if (traceConsole) NSLog(@"log :-: BUFFER_END");
                    self.playerLastEvent = log_BUFFER_END;
                    [self initLogEvent:self.playerLastEvent];
                    isSeeking = false;
                    if (isPlayStarted == false) {
                        isPlayStarted = true;
                        if (traceConsole) NSLog(@"log :-: STARTED.");
                        self.playerLastEvent = log_STARTED;
                        [self initLogEvent:self.playerLastEvent];
                    }
                }
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:thePlayerItem.error];
            }
                break;
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == laRateObservationContext)
    {
        //        if (traceConsole) NSLog(@"log :: laRateObservationContext ");
        //                if (traceConsole) NSLog(@"log :: rate 2, %d, %d, %d %.5f", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull, self.log_player.rate);
        if (self.playerLastEvent == log_INITIALIZED || self.playerLastEvent == log_ERROR) {
            if (log_player.rate == 1 && isPlayStarted == false) {
                isPlayStarted = true;
                if (traceConsole) NSLog(@"log :-: STARTED..");
                self.playerLastEvent = log_STARTED;
                [self initLogEvent:self.playerLastEvent];
            }
            //                        if (traceConsole) NSLog(@"log :: returning");
            return;
        }
        //                if (traceConsole) NSLog(@"log :: laRateObservationContext , %d, %d, %d, %.5f", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull, log_player.rate);
        if (self.log_player.rate == 0 && self.playerLastEvent != log_PAUSE && self.playerLastEvent != log_BUFFER_START) {
            if (traceConsole) NSLog(@"log :-: PAUSE");
            self.playerLastEvent = log_PAUSE;
            [self initLogEvent:self.playerLastEvent];
            currenTimeSeconds = [self timeStamp];
        } else if (self.log_player.rate != 0 && (self.playerLastEvent == log_PAUSE || self.playerLastEvent == log_AD_SKIPPED || self.playerLastEvent == log_AD_COMPLETED || self.playerLastEvent == log_AD_COMPLETED_BY_USER) && currenTimeSeconds != [self timeStamp]) {
            //                        if (traceConsole) NSLog(@"log :: RESUME 2, %f", self.log_player.rate);
            NSString *tempAdtype = [self checkAndReturn:[self.logMetaData valueForKey:@"adType"]];
            if ([tempAdtype isEqual: @"0"] && (self.playerLastEvent == log_AD_SKIPPED || self.playerLastEvent == log_AD_COMPLETED || self.playerLastEvent == log_AD_COMPLETED_BY_USER)) {
                return;
            }
            if (isSeeking == false) {
                if (traceConsole) NSLog(@"log :-: RESUME");
                self.playerLastEvent = log_RESUME;
                [self initLogEvent:self.playerLastEvent];
            }
        }
    }
    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
    else if (context == laCurrentItemObservationContext)
    {
        //        if (traceConsole) NSLog(@"log :: laCurrentItemObservationContext ");
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* New player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
        }
        else /* Replacement of player currentItem has occurred */
        {
        }
    }
    /* Observe the AVPlayer "currentItem.timedMetadata" property to parse the media stream
     timed metadata. */
    else if (context == laTimedMetadataObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laTimedMetadataObserverContext ");
    }
    else if (context == laPlaybackBufferEmptyObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laPlaybackBufferEmptyObserverContext , %d, %d, %d, %.5f", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull, log_player.rate);
        if (self.log_playerItem.isPlaybackBufferEmpty) {
            if (self.playerLastEvent == log_BUFFER_START || self.playerLastEvent == log_INITIALIZED) {
                //                if (traceConsole) NSLog(@"log :: returning");
                return;
            }
            if (self.log_playerItem.isPlaybackLikelyToKeepUp == false && self.log_player.rate == 0) {
                //                if (traceConsole) NSLog(@"log :-: BUFFER_START 2, %d, %d, %d %.5f", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull, log_player.rate);
                if (traceConsole) NSLog(@"log :-: BUFFER_START");
                self.playerLastEvent = log_BUFFER_START;
                [self initLogEvent:self.playerLastEvent];
            }
        }
    }
    else if (context == laPlaybackBufferFullObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laPlaybackBufferFullObserverContext ");
    }
    else if (context == laPlaybackLikelyToKeepUpObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laPlaybackLikelyToKeepUpObserverContext , %d, %d, %d, %.5f", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull, log_player.rate);
        if (self.log_playerItem.isPlaybackLikelyToKeepUp == FALSE && self.log_playerItem.isPlaybackBufferEmpty == TRUE) {
            if (self.playerLastEvent == log_BUFFER_START) {
                //                if (traceConsole) NSLog(@"log :: returning");
                return;
            }
            if (traceConsole) NSLog(@"log :-: BUFFER_START");
            self.playerLastEvent = log_BUFFER_START;
            [self initLogEvent:self.playerLastEvent];
        }
        else if (self.log_playerItem.isPlaybackLikelyToKeepUp == TRUE) {
            if (self.playerLastEvent == log_BUFFER_START || self.playerLastEvent == log_SEEKING) {
                self.playerLastEvent = log_BUFFER_END;
                [self initLogEvent:self.playerLastEvent];
            }
        }
    }
    else if (context == laLoadedTimeRangesObserverContext)
    {
        //        if (traceConsole) NSLog(@"log :: laLoadedTimeRangesObserverContext ");
        //        if (self.playerLastEvent == BUFFER_START) {
        //            if (traceConsole) NSLog(@"log :-: BUFFER_END 2, %d, %d, %d", self.log_playerItem.isPlaybackLikelyToKeepUp, self.log_playerItem.isPlaybackBufferEmpty, self.log_playerItem.isPlaybackBufferFull);
        //            self.playerLastEvent = log_BUFFER_END;
        //        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
    
    return;
}

#pragma mark get program duration
- (void)setProgramDuration {
    CMTime playerDuration = [self playerItemDuration];
    if (!CMTIME_IS_INVALID(playerDuration)) {
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            PlayerEvent eventType = self.playerLastEvent;
            if (eventType == log_VIDEO_CLICKED || eventType == log_INITIALIZED) {
                programDuration = @"-1";
            } else if ((int)duration){
                programDuration = [NSString stringWithFormat:@"%d", (int)duration * 1000];
            }
        }
    }
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration {
    NSArray *seekableTimeRanges = [self.log_playerItem seekableTimeRanges];
    if ([seekableTimeRanges count] > 0)
    {
        NSValue *range = [seekableTimeRanges objectAtIndex:0];
        CMTimeRange timeRange = [range CMTimeRangeValue];
        //        double duration = CMTimeGetSeconds(timeRange.duration);
        double time = CMTimeGetSeconds([self.log_playerItem currentTime]);
        playerPosition = [NSString stringWithFormat:@"%lld", (long long)((time-CMTimeGetSeconds(timeRange.start)) * 1000)];
        if (self.playerLastEvent == log_PAUSE) {
            seekStartPosition = playerPosition;
        }
        if (self.playerLastEvent == log_SEEKING) {
            //            seekEndPosition = playerPosition;
            if (traceConsole) NSLog(@"log :: seekStartPosition: %d, seekEndPositio@: %d", [seekStartPosition intValue]/1000, [seekEndPosition intValue]/1000);
        }
        //                if (traceConsole) NSLog(@"log :: time: %f, duration: %f, playerPosition: %d", time, duration, [playerPosition intValue]/1000);
        return timeRange.duration;
    }
    return(kCMTimeInvalid);
}

#pragma mark -
#pragma mark log events setters and getters
- (void)initLogEvent:(PlayerEvent)eventType {
    NSString *occurenceTime = [NSString stringWithFormat:@"%lli",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
    
    NSString *tmp_seekStartPosition = @"-1";
    NSString *tmp_seekEndPosition = @"-1";
    NSString *tmp_token = [lKC getToken];
    
    if (traceConsole) NSLog(@"Log Token: %@", tmp_token);
    //    if (traceConsole) NSLog(@"log :: Api key: %@.", self.logAnalyticsKey);
    
    [self setProgramDuration];
    
    NSMutableDictionary *cData=[[NSMutableDictionary alloc]initWithDictionary:self.logMetaData];
    NSMutableDictionary *eventDict=[[NSMutableDictionary alloc]init];
    [eventDict setValue:[self getEventType:eventType] forKey:@"et"];
    
    if (eventType == log_VIDEO_CLICKED) {
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"channelName"]] forKey:@"cn"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"programName"]] forKey:@"pn"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"genre"]] forKey:@"g"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"glang"]] forKey:@"l"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"deviceId"]] forKey:@"di"];
        [eventDict setValue:[self getDeviceOS] forKey:@"dos"];
        [eventDict setValue:@"avplayer" forKey:@"pln"];
        [eventDict setValue:@"1.0" forKey:@"plv"];
        [eventDict setValue:[self getAppVersion] forKey:@"appv"];
        [eventDict setValue:[self newtworkType] forKey:@"cnt"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"gip"]] forKey:@"ip"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"navigatingFrom"]] forKey:@"nf"];
        [eventDict setValue:[self getCarrierName] forKey:@"np"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"isSubscribed"]] forKey:@"is"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"isp"]] forKey:@"isp"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"gcon"]] forKey:@"con"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"gren"]] forKey:@"st"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"gcity"]] forKey:@"c"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"autoPlay"]] forKey:@"ap"];
        [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"videoList"]] forKey:@"vl"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"playerUrl"]] forKey:@"su"];
        [eventDict setValue:[self checkAndReturn:[self getCdnForConviva:[cData valueForKey:@"playerUrl"]]] forKey:@"cdn"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"attribute1"]] forKey:@"a1"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"attribute2"]] forKey:@"a2"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"attribute3"]] forKey:@"a3"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"seasonNumber"]] forKey:@"sn"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"episodeNumber"]] forKey:@"en"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"subCategory"]] forKey:@"sc"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"partnerId"]] forKey:@"ptri"];
        [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"partnerName"]] forKey:@"ptrn"];
    } else if (eventType == log_SEEKING) {
        tmp_seekStartPosition = seekStartPosition;
        tmp_seekEndPosition = seekEndPosition;
    }
    if ((eventType == log_AD_STARTED || eventType == log_AD_SKIPPED || eventType == log_AD_COMPLETED || eventType == log_AD_COMPLETED_BY_USER) && [cData objectForKey:@"adType"]) {
    } else {
        [cData setValue:@"-1" forKey:@"adType"];
    }
    [eventDict setValue:[self checkAndReturn:tmp_token] forKey:@"bi"];
    [eventDict setValue:@"mobileapp" forKey:@"dt"];
    [eventDict setValue:[self getDeviceClient] forKey:@"dc"];
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"actualDeviceClient"]] forKey:@"adc"];
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"vendorId"]] forKey:@"vi"];
    [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"userId"]] forKey:@"ui"];
    [eventDict setValue:[self getContentType:[cData objectForKey:@"contentType"]] forKey:@"ct"];
    [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"channelId"]] forKey:@"ci"];
    [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"programId"]] forKey:@"pi"];
    [eventDict setValue:[self checkAndReturn:[cData objectForKey:@"appName"]] forKey:@"pdn"];
    
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"meta_id"]] forKey:@"meta_id"];
    [eventDict setValue:[self checkAndReturn:self.logAnalyticsKey] forKey:@"analytics_id"];
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"authKey"]] forKey:@"sk"];
    [eventDict setValue:[self checkAndReturn:[self getPPsidVal]] forKey:@"psk"];
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"eventMessage"]] forKey:@"em"];
    [eventDict setValue:occurenceTime forKey:@"ts"];
    [eventDict setValue:[self checkAndReturn:playerPosition] forKey:@"pp"];
    [eventDict setValue:[self checkAndReturn:tmp_seekStartPosition] forKey:@"sp"];
    [eventDict setValue:[self checkAndReturn:tmp_seekEndPosition] forKey:@"ep"];
    [eventDict setValue:[self checkAndReturn:[self getBitRate]] forKey:@"br"];
    [eventDict setValue:@"v2" forKey:@"av"];
    [eventDict setValue:[self checkAndReturn:programDuration] forKey:@"tvl"];
    [eventDict setValue:[self checkAndReturn:[cData valueForKey:@"adType"]] forKey:@"at"];
    [eventDict setValue:[self checkAndReturn:[self getPlayerState:eventType]] forKey:@"ps"];
    [eventDict setValue:[self checkAndReturn:[self getEventCounter]] forKey:@"ec"];
    
    //    if (traceConsole) NSLog(@"log :: --analy ticsDict:received: %@", [self getEventName:eventType]);
    
    [self sendLogEvent:eventDict];
}

- (void)sendLogEvent:(NSDictionary *)toParseDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toParseDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = nil;
    if (! jsonData) {
        if (traceConsole) NSLog(@"log :: --analytics Got an error: %@", error);
        
    } else {
        jsonString= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *charactersToEscape = @"\n{}!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    NSString *encodedString = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    
    NSURL *log_url = [NSURL URLWithString:Log_Event_domain];
    //    if (traceConsole) NSLog(@"log :: --analytics log_url:- %@",log_url);
    //    if (traceConsole) NSLog(@"log :: --analytics data:- %@",jsonString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:log_url];
    
    [request setTimeoutInterval:60];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //NSString *requestParams=[NSString stringWithFormat:@"data=%@",encodedString];
    
    
    NSMutableData *requestParams = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"data=%@",encodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestParams appendData:[[NSString stringWithFormat:@"&analytics_id=%@", self.logAnalyticsKey] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    if (traceConsole) NSLog(@"log :: --analytics Request Params : %@", [NSString stringWithUTF8String:[requestParams bytes]]);
    
    [request setHTTPBody:requestParams];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError)
      {
          if (connectionError) {
              if (traceConsole) NSLog(@"log :: --analytics error %@",[connectionError localizedDescription]);
          } else {
              //success
              if (traceConsole) NSLog(@"log :: --analytics result: %@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
          }
      }] resume];
}

- (NSString *)checkAndReturn:(id)tempVal {
    NSString* val = [NSString stringWithFormat:@"%@", tempVal];
    //    if (traceConsole) NSLog(@"log :: --analytics checkAndReturn %@",val);
    if (val == nil || val == (id)[NSNull null] || val == NULL || val.length == 0 || [val  isEqualToString:@""] || [val  isEqualToString:@"(null)"]) {
        return @"-1";
    } else {
        return val;
    }
}

- (void)setPPsid:(NSString *)ppsidVal {
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref setValue:ppsidVal forKey:@"ppsid_logEvent"];
    [pref synchronize];
}

- (NSString *)getPPsidVal {
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    if ([[pref valueForKey:@"ppsid_logEvent"]length]==0) {
        return @"0";
    }
    return  [NSString stringWithFormat:@"%@",[pref valueForKey:@"ppsid_logEvent"]];
}

#pragma mark get event Counter
- (NSString *)getEventCounter {
    if (self.playerLastEvent == log_VIDEO_CLICKED) {
        eventCounter = 1;
    } else {
        eventCounter++;
    }
    return [NSString stringWithFormat:@"%d", eventCounter];
}

#pragma mark get player state
- (NSString *)getPlayerState:(PlayerEvent)eventType {
    NSString *playerState = @"idle";
    if (self.playerLastEvent == log_VIDEO_CLICKED) {
        playerState = @"idle";
    } else if (self.playerLastEvent == log_STARTED || self.playerLastEvent == log_BUFFER_END || self.playerLastEvent == log_RESUME) {
        playerState = @"playing";
    } else if (self.playerLastEvent == log_BUFFER_START) {
        playerState = @"buffering";
    } else if (self.playerLastEvent == log_PAUSE) {
        playerState = @"paused";
    } else if (self.playerLastEvent == log_AD_STARTED) {
        if (eventType == log_HEARTBEAT){
            playerState = @"playing";
        }
        else{
            playerState = @"adplaying";
        }
    } else if (self.playerLastEvent == log_AD_SKIPPED || self.playerLastEvent == log_AD_COMPLETED || self.playerLastEvent == log_AD_COMPLETED_BY_USER) {
        playerState = @"playing";
    }
    return playerState;
}

#pragma mark get event type
- (NSString *)getEventType:(PlayerEvent)eventType {
    switch (eventType) {
            
        case log_VIDEO_CLICKED:
            [self setPPsid:tempPPSidValue];
            return @"1";
            break;
            
        case log_INITIALIZED:
            return @"2";
            break;
            
        case log_AD_STARTED:
            return @"3";
            break;
            
        case log_AD_SKIPPED:
            return @"4";
            break;
            
        case log_AD_COMPLETED_BY_USER:
            return @"5";
            break;
            
        case log_AD_COMPLETED:
            return @"6";
            break;
            
        case log_STARTED:
            return @"7";
            break;
            
        case log_PLAYBACK_ENDED_BY_USER:
            return @"8";
            break;
            
        case log_PLAYBACK_ENDED:
            return @"9";
            break;
            
        case log_SEEKING:
            return @"10";
            break;
            
        case log_BUFFER_START:
            return @"11";
            break;
            
        case log_BUFFER_END:
            return @"12";
            break;
            
        case log_PAUSE:
            return @"13";
            break;
            
        case log_RESUME:
            return @"14";
            break;
            
        case log_HEARTBEAT:
            return @"15";
            break;
            
        case log_ERROR:
            return @"16";
            break;
            
        case log_BitRateChange:
            return @"17";
            break;
            
        case log_PAUSE_ON_HOME:
            return @"18";
            break;
            
        default:
            return @"-1";
            break;
    }
}

#pragma mark get event name
- (NSString *)getEventName:(PlayerEvent)eventType {
    switch (eventType) {
            
        case log_VIDEO_CLICKED:
            return @"VIDEO_CLICKED";
            break;
            
        case log_INITIALIZED:
            return @"INITIALIZED";
            break;
            
        case log_AD_STARTED:
            return @"AD_STARTED";
            break;
            
        case log_AD_SKIPPED:
            return @"AD_SKIPPED";
            break;
            
        case log_AD_COMPLETED_BY_USER:
            return @"AD_COMPLETED_BY_USER";
            break;
            
        case log_AD_COMPLETED:
            return @"AD_COMPLETED";
            break;
            
        case log_STARTED:
            return @"STARTED";
            break;
            
        case log_PLAYBACK_ENDED_BY_USER:
            return @"PLAYBACK_ENDED_BY_USER";
            break;
            
        case log_PLAYBACK_ENDED:
            return @"PLAYBACK_ENDED";
            break;
            
        case log_SEEKING:
            return @"SEEKING";
            break;
            
        case log_BUFFER_START:
            return @"BUFFER_START";
            break;
            
        case log_BUFFER_END:
            return @"BUFFER_END";
            break;
            
        case log_PAUSE:
            return @"PAUSE";
            break;
            
        case log_RESUME:
            return @"RESUME";
            break;
            
        case log_HEARTBEAT:
            return @"HEARTBEAT";
            break;
            
        case log_ERROR:
            return @"ERROR";
            break;
            
        case log_BitRateChange:
            return @"BitRateChange";
            break;
            
        case log_PAUSE_ON_HOME:
            return @"PAUSE_ON_HOME";
            break;
            
        default:
            return @"-1";
            break;
    }
}

#pragma mark get category type
- (NSString*)getContentType:(NSString *)contentType {
    if ([contentType isEqualToString:@"live"]) {
        return @"live";
    } else if ([contentType isEqualToString:@"catchup"]) {
        return @"vod";
    } else if ([contentType isEqualToString:@"movie"]) {
        return @"yuppflix";
    } else if ([contentType isEqualToString:@"show"]) {
        return @"yupptvshows";
    } else if ([contentType isEqualToString:@"clip"]) {
        return @"clip";
    } else if ([contentType isEqualToString:@"bazaar"]) {
        return @"nw-video";
    } else {
        return @"-1";
    }
}

#pragma mark get network type
- (NSString *)newtworkType {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        return @"wifi";
    }
    NSString *networkType = @"";
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *networkString = [networkInfo currentRadioAccessTechnology];
    if ([networkString isEqualToString:CTRadioAccessTechnologyLTE]) {
        networkType = @"4G";
    } else if ([networkString isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        networkType = @"3G";
    } else if ([networkString isEqualToString:CTRadioAccessTechnologyEdge]) {
        networkType = @"2G";
    } else {
        networkType = @"wifi";
    }
    return networkType;
}
 - (NSString *)newtworkType1 { // Not using
   /* NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];*/
    
    NSArray *subviews = nil;
    id statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        subviews = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    } else {
        subviews = [[statusBar valueForKey:@"foregroundView"] subviews];
    }
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSString *networktype;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            networktype=@"-1";
            break;
        case 1:
            networktype=@"2G";
            break;
        case 2:
            networktype=@"3G";
            break;
        case 3:
            networktype=@"4G";
            break;
        case 4:
            networktype=@"LTE";
            break;
        case 5:
            networktype=@"Wifi";
            break;
        default:
            networktype=@"-1";
            break;
    }
    if (traceConsole) NSLog(@"log :: --analytics networktype: %@",networktype);
    return networktype;
}

#pragma mark get device version
- (NSString *)getDeviceVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark get device type
- (NSString *)getDevicetype {
    return [[UIDevice currentDevice] model];
}

#pragma mark get device type
- (NSString *)getDeviceClient {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"iphone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        return @"appletv";
    } else {
        return @"-1";
    }
}

#pragma mark get device type
- (NSString *)getDeviceOS {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"ios";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ios";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        return @"tvos";
    } else {
        return @"-1";
    }
}

#pragma mark get App version
- (NSString *)getAppVersion {
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

#pragma mark get App ("cdn","ContentDeliveryNetwork")
- (NSString*)getCdnForConviva:(NSString*)urlToPlay {
    NSString* cdnName = @"-1";
    if (urlToPlay.length) {
        NSURL* tmpUrl = [NSURL URLWithString:urlToPlay];
        if (![[self extractString:[tmpUrl host] toLookFor:@"akamai" skipForwardX:0 toStopBefore:@"akamai"] isEqualToString:@""]) {
            cdnName = @"akamai";
        } else if (![[self extractString:[tmpUrl host] toLookFor:@"lime" skipForwardX:0 toStopBefore:@"lime"] isEqualToString:@""]) {
            cdnName = @"limelight";
        } else if (![[self extractString:[tmpUrl host] toLookFor:@"bitgravity" skipForwardX:0 toStopBefore:@"bitgravity"] isEqualToString:@""]) {
            cdnName = @"bitgravity";
        }
    }
    return cdnName;
}

#pragma mark get carrier name
- (NSString*)getCarrierName {
    NSString *carrierName = @"-1";
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    // Get carrier name
    if ([carrier carrierName] && [carrier carrierName].length && [carrier isoCountryCode] && [carrier isoCountryCode].length){
        carrierName = [carrier carrierName];
    }
    return carrierName;
}


#pragma mark function to look for string
- (NSString *)extractString:(NSString *)fullString toLookFor:(NSString *)lookFor skipForwardX:(NSInteger)skipForward toStopBefore:(NSString *)stopBefore {
    NSRange firstRange = [fullString rangeOfString:lookFor];
    if (firstRange.length == 0 || [fullString rangeOfString:stopBefore].length == 0) {
        return @"";
    }
    NSRange secondRange = [[fullString substringFromIndex:firstRange.location + skipForward] rangeOfString:stopBefore];
    NSRange finalRange = NSMakeRange(firstRange.location + skipForward, secondRange.location + [stopBefore length]);
    return [fullString substringWithRange:finalRange];
}

@end
