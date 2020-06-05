//
//  ANXNotificationsDateVO.m
//  Notifications
//
//  Created by Max Rozdobudko on 5/29/20.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import "ANXNotificationsDateVO.h"
#import "ANXNotificationsConversionRoutines.h"

@implementation ANXNotificationsDateVO {
    NSDate* _value;
}

+ (instancetype)withValue:(NSDate*)value {
    return [[ANXNotificationsDateVO alloc] initWithValue:value];
}

- (id)initWithValue:(NSDate*)value {
    if ([super init]) {
       _value = value;
   }
   return self;
}

- (FREObject)toFREObject {
    return [ANXNotificationsConversionRoutines convertNSDateToFREObject:_value];
}


@end
