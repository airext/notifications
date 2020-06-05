//
//  ANXNotificationCenter.h
//  Notifications
//
//  Created by Max Rozdobudko on 12/7/17.
//  Copyright © 2017 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

extern NSErrorDomain ANXNotificationCenterErrorDomain;

typedef void(^GetNotificationSettingsCompletion)(NSString *authorizationStatus);
typedef void(^RequestAuthorizationCompletion)(BOOL granted, NSError* error);
typedef void(^AddNotificationRequestCompletion)(NSError* error);
typedef void(^HasPendingNotificationRequestCompletion)(BOOL result);
typedef void(^NextTriggerDateForPendingNotificationRequestCompletion)(NSDate* result);

@interface ANXNotificationCenter : NSObject

# pragma mark Shared instance

+ (ANXNotificationCenter*)sharedInstance;

# pragma mark Availability & Permissions

+ (BOOL)isSupported;

+ (BOOL)isEnabled;

+ (BOOL)canOpenSettings;
+ (void)openSettings;

+ (void)getNotificationSettingsWithCompletion:(GetNotificationSettingsCompletion)completion;
+ (void)requestAuthorizationWithOptions:(NSInteger)options withCompletion:(RequestAuthorizationCompletion)completion;

# pragma mark Background / Foreground

+ (BOOL)isInForeground;
+ (void)inForeground;
+ (void)inBackground;

# pragma mark Properties

@property NSString* params;

# pragma mark Schedule Notification

- (void)addNotificationRequestWithIdentifier:(NSString*)identifier trigger:(UNNotificationTrigger*)trigger content:(UNNotificationContent*)content withCompletion:(AddNotificationRequestCompletion)completion;
- (void)hasPendingNotificationRequestWithIdentifier:(NSString*)identifier withCompletion:(HasPendingNotificationRequestCompletion)completion;
- (void)nextTriggerDateForPendingNotificationRequestWithIdentifier:(NSString*)identifier withCompletion:(NextTriggerDateForPendingNotificationRequestCompletion)completion;
- (void)removePendingNotificationRequestWithIdentifiers:(NSArray*)identifiers;
- (void)removeAllPendingRequests;

@end

# pragma mark ANXNotificationCenterDelegate

@interface ANXNotificationCenterDelegate : NSObject <UNUserNotificationCenterDelegate>

@end
