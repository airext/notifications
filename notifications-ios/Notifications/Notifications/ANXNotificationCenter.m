//
//  ANXNotificationCenter.m
//  DeviceInfo
//
//  Created by Max Rozdobudko on 12/7/17.
//  Copyright © 2017 Max Rozdobudko. All rights reserved.
//

#import "ANXNotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "ANXNotifications.h"
#import "ANXNotificationsConversionRoutines.h"
#import "ANXNotificationCenterSettingsVO.h"

NSString* ANXNotificationCenterErrorDomain = @"ANXNotificationCenterErrorDomain";

@implementation ANXNotificationCenter

# pragma mark Shared instance

static ANXNotificationCenter* _sharedInstance = nil;

+ (ANXNotificationCenter*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    }
    return self;
}

# pragma mark Availability & Permissions

+ (BOOL)isSupported {
    return YES;
}

+ (BOOL)isEnabled {
    return YES;
}

+ (BOOL)canOpenSettings {
    return NO;
}

+ (void)openSettings {
    
}

+ (void)getNotificationSettingsWithCompletion:(GetNotificationSettingsCompletion)completion {
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSString* authorizationStatus = @"unknown";
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            authorizationStatus = @"granted";
        } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
            authorizationStatus = @"denied";
        }
        if (completion) {
            completion(authorizationStatus);
        }
    }];
}

static RequestAuthorizationCompletion _authorizationCompletionHandler;

+ (void)requestAuthorizationWithOPtions:(NSInteger)options withCompletion:(RequestAuthorizationCompletion)completion {
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:completion];
}

# pragma mark Background / Foreground

static BOOL _isInForeground;

+ (BOOL)isInForeground {
    return _isInForeground;
}
+ (void)inForeground {
    _isInForeground = YES;
    if (ANXNotificationCenter.sharedInstance.params) {
        [ANXNotifications.sharedInstance dispatch:@"DeviceInfo.NotificationCenter.Notification.ReceivedInBackground" withLevel:ANXNotificationCenter.sharedInstance.params];
        ANXNotificationCenter.sharedInstance.params = nil;
    }
}
+ (void)inBackground {
    _isInForeground = NO;
}

# pragma mark Properties

@synthesize params;

# pragma mark Schedule Notification

- (void)addNotificationRequestWithIdentifier:(NSString*)identifier trigger:(UNNotificationTrigger*)trigger content:(UNNotificationContent*)content withCompletion:(AddNotificationRequestCompletion)completion {
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusAuthorized : {
                UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
                [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:completion];
                break;
            }
            case UNAuthorizationStatusDenied : {
                NSLog(@"ANX UNAuthorizationStatusDenied");
                if (completion) {
                    completion([NSError errorWithDomain:ANXNotificationCenterErrorDomain code:1001 userInfo:@{NSLocalizedDescriptionKey:@"Access denied"}]);
                }
                break;
            }
            case UNAuthorizationStatusNotDetermined : {
                NSLog(@"ANX UNAuthorizationStatusNotDetermined");
                if (completion) {
                    completion([NSError errorWithDomain:ANXNotificationCenterErrorDomain code:1002 userInfo:@{NSLocalizedDescriptionKey:@"Unauthorized access"}]);
                }
                break;
            }
            case UNAuthorizationStatusProvisional: {
                NSLog(@"ANX UNAuthorizationStatusProvisional");
                if (completion) {
                    completion([NSError errorWithDomain:ANXNotificationCenterErrorDomain code:1003 userInfo:@{NSLocalizedDescriptionKey:@"Not authorized access"}]);
                }
                break;
            }
        }
    }];
}

- (void)removePendingNotificationRequestWithIdentifiers:(NSArray*)identifiers {
    NSLog(@"ANXNotificationCenter removePendingNotificationRequestWithIdentifiers: %@", identifiers);
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:identifiers];
        }
    }];
}

- (void)removeAllPendingRequests {
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            [UNUserNotificationCenter.currentNotificationCenter removeAllPendingNotificationRequests];
        }
    }];
}

@end

#pragma mark <UNUserNotificationCenterDelegate>

@implementation ANXNotificationCenter (Delegate)

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)) {
    
    NSLog(@"ANXNotificationCenter userNotificationCenter:willPresentNotification:withCompletionHandler");
    
    if (completionHandler) {
        completionHandler(UNNotificationPresentationOptionNone);
    }
    
    NSString* params = notification.request.content.userInfo[@"params"];
    
    [ANXNotifications.sharedInstance dispatch:@"Notifications.Notification.ReceivedInForeground" withLevel:params];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    NSLog(@"ANXNotificationCenter userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler");
    
    UNNotification* notification = response.notification;
    
    NSString* params = notification.request.content.userInfo[@"params"];
    
    if (ANXNotificationCenter.isInForeground) {
        [ANXNotifications.sharedInstance dispatch:@"Notifications.Notification.ReceivedInBackground" withLevel:params];
    } else {
        ANXNotificationCenter.sharedInstance.params = params;
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

@end
