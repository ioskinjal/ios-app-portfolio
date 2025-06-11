//
//  logAnalytics.h
//
//  Created by Mohan Agadkar (mohanagadkar@yupptv.com) on 17/07/17.
//  Copyright © 2017 YuppTV Inc. All rights reserved.
//  logAnalytics version 1.0
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

// Enum values for player type
typedef NS_ENUM( NSInteger, eventTrigger) {
    trigger_seek_start,
    trigger_seek_end,
    trigger_ad_start,
    trigger_ad_skipped,
    trigger_ad_completed_by_user,
    trigger_ad_completed
};

@class AVPlayer;
@class AVPlayerItem;

@interface logAnalytics : NSObject

/// @brief Initialize LogAnalytics with settings parameters
///
/// \param customerKey a key assigned by LogAnalytic Team to uniquely identify a
///   customer
/// \param settings a dictionary with string keys and object values
- (void)initWithAnalyticsKey:(NSString *)customerKey isLive:(BOOL)isLive andSettings:(NSDictionary *)settings;

/// @brief Initialize LogAnalytics with meta data
///
/// \param logMetaDict a dictionary with string keys and object values
- (void)initSessionWithMetaData:(NSDictionary *)logMetaDict;

/// @brief update LogAnalytics meta data
///
/// \param logMetaDict a dictionary with string keys and object values
/// this is useful, while sending ad events, seekevent, error event with keys like preroll, midroll, postroll, error messages
/// only new or updated key values will get effected. Other key values pairs sent using initSessionWithMetaData still remains same
- (void)updateMetaData:(NSDictionary *)logMetaDict;

/// @brief attach the player instance
///
/// \param basePlayer an AVPlayer instance to get various states of the player
- (void)attachPlayer:(AVPlayer*) basePlayer;// theCurrentPlayingItem:(AVPlayerItem*) currentPlayingItem;

/// @brief close session
///
/// call close session at approprite time
/// like, when user navigates back from player page, when app is minimized, tap on another video
- (void)closeSession:(BOOL) playReachedEnd;

/// @brief trigger seek and ad events
///
/// call triggerLogEvent function for events like various ad states
/// refer to evetnTrigger type
- (void)triggerLogEvent:(eventTrigger)et position:(NSInteger)currentPosition;

/// @brief Send error
///
/// call sendError function for sending errors while playing content
- (void)sendError:(NSString*)errorMessage;

/// @brief check version of log analtics
- (void)checkVersion;

/// @brief get unique device Id for log analtics
- (void)getDevId;

/* --------------------------------------------------------------
 **  Singleton instance for the entire application
 ** ----------------------------------------------------------- */
+ (logAnalytics *)shared;

@end
