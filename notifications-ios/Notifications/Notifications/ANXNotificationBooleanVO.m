//
//  ANXNotificationBooleanVO.m
//  Notifications
//
//  Created by Max Rozdobudko on 3/26/20.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import "ANXNotificationBooleanVO.h"
#import "ANXNotificationsConversionRoutines.h"

@implementation ANXNotificationBooleanVO {
    BOOL _value;
}

+ (instancetype)withValue:(BOOL)value {
    return [[ANXNotificationBooleanVO alloc] initWithValue:value];
}

- (id)initWithValue:(BOOL)value {
    if ([super init]) {
       _value = value;
   }
   return self;
}

- (FREObject)toFREObject {
    return [ANXNotificationsConversionRoutines convertBoolToFREObject:_value];
}

@end
