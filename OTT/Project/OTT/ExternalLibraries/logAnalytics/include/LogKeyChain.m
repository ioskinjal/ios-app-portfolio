//
//  LogKeyChain.m
//  YuppTV
//
//  Created by Uday-Macmini3 on 12/23/14.
//  Copyright (c) 2015 YuppTV. All rights reserved.
//

#import "LogKeyChain.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

@interface LogKeyChain (PrivateMethods)
- (SecKeychainItemRef) getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
@end
#endif

@implementation LogKeyChain

- (NSString *)getToken{
    NSString *deviceToken;
#if !TARGET_IPHONE_SIMULATOR
    
    if ((deviceToken = [self getPasswordForUsername:@"token" andServiceName:@"yuppLogAnalytics" error:nil]) != nil)
    {
        //NSLog(@"token 1: %@",deviceToken);
        return deviceToken;
    }
    else
    {
        UIDevice *device1 = [UIDevice currentDevice];
        deviceToken = [[device1 identifierForVendor]UUIDString];
        
        //NSLog(@"token 2:%@",deviceToken);
        [self storeUsername:@"token" andPassword:deviceToken forServiceName:@"yuppLogAnalytics" updateExisting:NO error:nil];
    }
    
    
#endif
#if TARGET_IPHONE_SIMULATOR
    deviceToken=@"SIMULATORLA";
#endif
    return deviceToken;
    
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

- (NSString *)getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error
{
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
	
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
	
	if (*error || !item) {
		return nil;
	}
	
	// from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
    
    list.count = 4;
    list.attr = attributes;
    
    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		return nil;
    }
    
	NSString *passwordString = nil;
	
	if (password != NULL) {
		char passwordBuffer[1024];
		
		if (length > 1023) {
			length = 1023;
		}
		strncpy(passwordBuffer, password, length);
		
		passwordBuffer[length] = '\0';
		passwordString = [NSString stringWithCString:passwordBuffer];
	}
	
	SecKeychainItemFreeContent(&list, password);
    
    CFRelease(item);
    
    return passwordString;
}

- (void)storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error {
	if (!username || !password || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return;
	}
	
	OSStatus status = noErr;
	
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
	
	if (*error && [*error code] != noErr) {
		return;
	}
	
	*error = nil;
	
	if (item) {
		status = SecKeychainItemModifyAttributesAndData(item,
                                                        NULL,
                                                        strlen([password UTF8String]),
                                                        [password UTF8String]);
		
		CFRelease(item);
	}
	else {
		status = SecKeychainAddGenericPassword(NULL,
                                               strlen([serviceName UTF8String]),
                                               [serviceName UTF8String],
                                               strlen([username UTF8String]),
                                               [username UTF8String],
                                               strlen([password UTF8String]),
                                               [password UTF8String],
                                               NULL);
	}
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

- (void)deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
		return;
	}
	
	*error = nil;
	
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
	
	if (*error && [*error code] != noErr) {
		return;
	}
	
	OSStatus status;
	
	if (item) {
		status = SecKeychainItemDelete(item);
		
		CFRelease(item);
	}
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

- (SecKeychainItemRef)getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
	
	*error = nil;
    
	SecKeychainItemRef item;
	
	OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                     strlen([serviceName UTF8String]),
                                                     [serviceName UTF8String],
                                                     strlen([username UTF8String]),
                                                     [username UTF8String],
                                                     NULL,
                                                     NULL,
                                                     &item);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
		
		return nil;
	}
	
	return item;
}

#else

- (NSString *)getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return nil;
	}
	
	if (error != nil) {
		*error = nil;
	}
    
	// Set up a query dictionary with the base query attributes: item type (generic), username, and service
	
	NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
	NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, nil];
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
	
	// First do a query for attributes, in case we already have a Keychain item with no password data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the password as a generic attribute instead of password data).
	
	NSDictionary *attributeResult = NULL;
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
	OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (void *) &attributeResult);
	
	//[attributeResult release];
	//[attributeQuery release];
	
	if (status != noErr) {
		// No existing item found--simply return nil for the password
		if (error != nil && status != errSecItemNotFound) {
			//Only return an error if a real exception happened--not simply for "not found."
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
		
		return nil;
	}
	
	// We have an existing item, now query for the password data associated with it.
	
	NSData *resultData = nil;
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
    
	status = SecItemCopyMatching((CFDictionaryRef) passwordQuery, (void *) &resultData);
	
	//[resultData autorelease];
	//[passwordQuery release];
	
	if (status != noErr) {
		if (status == errSecItemNotFound) {
			// We found attributes for the item previously, but no password now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeUsername:andPassword:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// password will be added.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
			}
		}
		else {
			// Something else went wrong. Simply return the normal Keychain API error code.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
			}
		}
		
		return nil;
	}
    
	NSString *password = nil;
    
	if (resultData) {
		password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}
	else {
		// There is an existing item, but we weren't able to get password data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
		}
	}
    
    return password;
}

- (BOOL)storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error
{
	if (!username || !password || !serviceName)
    {
		if (error != nil)
        {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	// See if we already have a password entered for these credentials.
	NSError *getError = nil;
	NSString *existingPassword = [self getPasswordForUsername: username andServiceName: serviceName error:&getError];
    
	if ([getError code] == -1999)
    {
		// There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
        
		getError = nil;
		
		[self deleteItemForUsername: username andServiceName: serviceName error: &getError];
        
		if ([getError code] != noErr)
        {
			if (error != nil)
            {
				*error = getError;
			}
			return NO;
		}
	}
	else if ([getError code] != noErr)
    {
		if (error != nil)
        {
			*error = getError;
		}
		return NO;
	}
	
	if (error != nil)
    {
		*error = nil;
	}
	
	OSStatus status = noErr;
    
	if (existingPassword)
    {
		// We have an existing, properly entered item with a password.
		// Update the existing item.
		
		if (![existingPassword isEqualToString:password] && updateExisting)
        {
			//Only update if we're allowed to update existing.  If not, simply do nothing.
			
			NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) kSecClass,
                              kSecAttrService,
                              kSecAttrLabel,
                              kSecAttrAccount,
                              nil];
			
			NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword,
                                 serviceName,
                                 serviceName,
                                 username,
                                nil];
			
			NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
			
			status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (NSString *) kSecValueData]);
		}
	}
	else
    {
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
		
		NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) kSecClass,
                          kSecAttrService,
                          kSecAttrLabel,
                          kSecAttrAccount,
                          kSecValueData,
                          nil];
		
		NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword,
                             serviceName,
                             serviceName,
                             username,
                             [password dataUsingEncoding: NSUTF8StringEncoding],
                            nil];
		
        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        
		status = SecItemAdd((CFDictionaryRef) query, NULL);
	}
	
	if (status != noErr)
    {
		// Something went wrong with adding the new item. Return the Keychain error code.
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
        
        return NO;
	}
    
    return YES;
}

- (BOOL)deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error
{
	if (!username || !serviceName)
    {
		if (error != nil)
        {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	if (error != nil)
    {
		*error = nil;
	}
    
    NSArray *keys = [[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];
    
    NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
	
	OSStatus status = SecItemDelete((CFDictionaryRef) query);
	
	if (status != noErr)
    {
        if (error != nil) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }
        
        return NO;
	}
    
    return YES;
}

#endif

@end
