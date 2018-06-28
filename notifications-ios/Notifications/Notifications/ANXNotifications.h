//
//  ANXNotifications.h
//  ANXNotifications
//
//  Created by Max Rozdobudko on 6/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

int isOperatingSystemAtLeast(int major, int minor, int patch) {
    NSOperatingSystemVersion version;
    version.majorVersion = major;
    version.minorVersion = minor;
    version.patchVersion = patch;
    return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
}

@interface ANXNotifications : NSObject

#pragma mark Shared Instance

+ (ANXNotifications*) sharedInstance;

#pragma mark Properties

@property FREContext context;

#pragma mark API Funcitons

-(BOOL) isSupported;

#pragma mark Dispatch events

-(void) dispatch: (NSString *) code withLevel: (NSString *) level;

-(void) dispatchError: (NSString *)code;

-(void) dispatchStatus: (NSString *)code;

@end
