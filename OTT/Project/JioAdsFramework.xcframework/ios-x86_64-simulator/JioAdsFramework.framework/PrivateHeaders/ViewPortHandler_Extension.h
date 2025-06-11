//
//  viewPort.h
//  JioAdsFramework
//
//  Created by Amit Bongulwar on 17/09/20.
//  Copyright © 2020 jioAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ViewPortHandler_ExtensionDelegate <NSObject>
@required
- (void)onTransion:(id)object;
@end

@interface ViewPortHandler_Extension : NSObject
//-(void)printClass;
//-(void)loadObservers;
//-(BOOL)checkForProcess:(UIView *)view;

@property(weak,nonatomic) id<ViewPortHandler_ExtensionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
