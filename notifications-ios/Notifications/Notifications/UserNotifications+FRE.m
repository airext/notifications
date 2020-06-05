//
//  UNNotificationContent+FRE.m
//  ANXNotifications
//
//  Created by Max Rozdobudko on 06.03.2020.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import "UserNotifications+FRE.h"
#import "ANXNotificationsConversionRoutines.h"

#pragma mark - UNMutableNotificationContent

@implementation UNMutableNotificationContent (FRE)

- (instancetype)initWithFREObject:(FREObject)object {
    if (self = [super init]) {
        self.title = [ANXNotificationsConversionRoutines readNSStringFrom:object field:@"title" withDefaultValue:@""];
        self.body  = [ANXNotificationsConversionRoutines readNSStringFrom:object field:@"body" withDefaultValue:@""];
        FREObject userInfoObject;
        FRECallObjectMethod(object, (const uint8_t *) "userInfoAsJSON", 0, NULL, &userInfoObject, NULL);
        self.userInfo = @{@"params": [ANXNotificationsConversionRoutines convertFREObjectToNSString:userInfoObject]};
        FREObject sound      = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"sound"];
        if (sound) {
            self.sound = [UNNotificationSound soundWithFREObject:sound];
        }
    }
    return self;
}

@end
#pragma mark - UNNotificationTrigger

@implementation UNNotificationTrigger (FRE)

+ (instancetype)triggerWithFREObject:(FREObject)object {
    NSInteger type = [ANXNotificationsConversionRoutines readNSIntegerFrom:object field:@"type" withDefaultValue:0];
    switch (type) {
        case 1:
            return [UNCalendarNotificationTrigger triggerWithFREObject:object];
        default:
            return [UNTimeIntervalNotificationTrigger triggerWithFREObject:object];
    }
}

@end

#pragma mark UNCalendarNotificationTrigger

@implementation UNCalendarNotificationTrigger (FRE)

+ (instancetype)triggerWithFREObject:(FREObject)object {
    return [self triggerWithDateMatchingComponents:[NSDateComponents dateComponentsWithFREObject:[ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"dateComponents"]]
                                           repeats:[ANXNotificationsConversionRoutines readBooleanFrom:object field:@"repeats" withDefaultValue:NO]];
}

@end

#pragma mark UNTimeIntervalNotificationTrigger

@implementation UNTimeIntervalNotificationTrigger (FRE)

+ (instancetype)triggerWithFREObject:(FREObject)object {
    return [self triggerWithTimeInterval:[ANXNotificationsConversionRoutines readDoubleFrom:object field:@"timeInterval" withDefaultValue:0.0]
                                 repeats:[ANXNotificationsConversionRoutines readBooleanFrom:object field:@"repeats" withDefaultValue:NO]];
}

@end

#pragma mark - UNNotificationSound

@implementation UNNotificationSound (FRE)

+ (instancetype)soundWithFREObject:(FREObject)object {
    NSString* soundName = [ANXNotificationsConversionRoutines readNSStringFrom:object field:@"named" withDefaultValue:nil];
    if (soundName) {
        return [UNNotificationSound soundNamed:soundName];
    } else {
        return UNNotificationSound.defaultSound;
    }
}

@end

#pragma mark - NSDateComponents

@implementation NSDateComponents (FRE)

+ (instancetype)dateComponentsWithFREObject:(FREObject)object {
    NSDateComponents* components = [[NSDateComponents alloc] init];

    FREObject year = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"year"];
    if (year != NULL) {
        components.year = [ANXNotificationsConversionRoutines readNSIntegerFrom:year field:@"value" withDefaultValue:0];
    }

    FREObject month = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"month"];
    if (month != NULL) {
        components.month = [ANXNotificationsConversionRoutines readNSIntegerFrom:month field:@"value" withDefaultValue:0];
    }

    FREObject weekday = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"weekday"];
    if (weekday != NULL) {
        components.weekday = [ANXNotificationsConversionRoutines readNSIntegerFrom:weekday field:@"value" withDefaultValue:0];
    }

    FREObject weekdayOrdinal = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"weekdayOrdinal"];
    if (weekdayOrdinal != NULL) {
        components.weekdayOrdinal = [ANXNotificationsConversionRoutines readNSIntegerFrom:weekdayOrdinal field:@"value" withDefaultValue:0];
    }

    FREObject day = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"day"];
    if (day != NULL) {
        components.day = [ANXNotificationsConversionRoutines readNSIntegerFrom:day field:@"value" withDefaultValue:0];
    }

    FREObject hour = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"hour"];
    if (hour != NULL) {
        components.hour = [ANXNotificationsConversionRoutines readNSIntegerFrom:hour field:@"value" withDefaultValue:0];
    }

    FREObject minute = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"minute"];
    if (minute != NULL) {
        components.minute = [ANXNotificationsConversionRoutines readNSIntegerFrom:minute field:@"value" withDefaultValue:0];
    }

    FREObject second = [ANXNotificationsConversionRoutines readFREObjectFrom:object field:@"second"];
    if (second != NULL) {
        components.second = [ANXNotificationsConversionRoutines readNSIntegerFrom:second field:@"value" withDefaultValue:0];
    }

    return components;
}

@end
