//
//  YuppKeyChain.h
//  YuppTV
//
//  Created by Uday-Macmini3 on 12/23/14.
//  Copyright (c) 2015 YuppTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogKeyChain : NSObject

- (NSString *)getToken;

- (BOOL)storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
- (NSString *)getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

- (BOOL)deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

@end
