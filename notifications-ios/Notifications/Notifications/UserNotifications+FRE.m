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
        default:
            return [UNTimeIntervalNotificationTrigger triggerWithFREObject:object];
    }
}

@end

#pragma mark UNTimeIntervalNotificationTrigger

@implementation UNCalendarNotificationTrigger (FRE)


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
