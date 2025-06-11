//
//  JSInterface.h
//  JioAdsFramework
//
//  Created by Amit Bongulwar on 29/04/21.
//  Copyright © 2021 jioAds. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSInterfaceProtocol <NSObject>
- (void)supportedTargetValue : (NSString *) name;
- (void)exressionReturn : (BOOL) isSelected;

-(void)launchBrowser:(NSString *)url;
-(NSString *)getReplacedMacrosClickUrl:(NSString *)url;
-(NSString *)getMetaDetails;
@end

@interface JSInterface : NSObject
- (id)initWithDelegate:(id)Tclass;
@property id <JSInterfaceProtocol> delegate;
- (void)onSupportedTargeting: (NSString *) args;
-(void)launchBrowser:(NSString *)url;
-(NSString *)getReplacedMacrosClickUrl:(NSString *)url;
-(NSString *)getMetaDetails;
@end

NS_ASSUME_NONNULL_END
