//
//  ANXNotifications.m
//  ANXNotifications
//
//  Created by Max Rozdobudko on 6/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import "ANXNotifications.h"

@implementation ANXNotifications

#pragma mark Shared Instance

static ANXNotifications* _sharedInstance = nil;

+ (ANXNotifications*) sharedInstance{
    if (_sharedInstance == nil){
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}
#pragma mark Properties

@synthesize context;

#pragma mark API Funcitons

-(BOOL) isSupported {
    return YES;
}

#pragma mark Dispatch events

-(void) dispatch: (NSString *) code withLevel: (NSString *) level {
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) [level UTF8String]);
}

-(void) dispatchError: (NSString *)code {
    [self dispatch:code withLevel:@"error"];
}

-(void) dispatchStatus: (NSString *)code {
    [self dispatch:code withLevel:@"status"];
}

@end
