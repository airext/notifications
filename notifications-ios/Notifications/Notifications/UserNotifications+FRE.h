//
//  UNNotificationContent+FRE.h
//  ANXNotifications
//
//  Created by Max Rozdobudko on 06.03.2020.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UNMutableNotificationContent

@interface UNMutableNotificationContent (FRE)

- (instancetype)initWithFREObject:(FREObject)object;

@end

#pragma mark - UNNotificationTrigger

@interface UNNotificationTrigger (FRE)

+ (instancetype)triggerWithFREObject:(FREObject)object;

@end

#pragma mark UNTimeIntervalNotificationTrigger

@interface UNCalendarNotificationTrigger (FRE)

//+ (instancetype)triggerWithFREObject:(FREObject)object;

@end

#pragma mark UNTimeIntervalNotificationTrigger

@interface UNTimeIntervalNotificationTrigger (FRE)

+ (instancetype)triggerWithFREObject:(FREObject)object;

@end

#pragma mark - UNNotificationSound

@interface UNNotificationSound (FRE)

+ (instancetype)soundWithFREObject:(FREObject)object;

@end

#pragma mark - NSDateComponents

@interface NSDateComponents (FRE)

+ (instancetype)dateComponentsWithFREObject:(FREObject)object;

@end

NS_ASSUME_NONNULL_END
