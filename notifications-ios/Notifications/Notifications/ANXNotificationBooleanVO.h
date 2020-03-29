//
//  ANXNotificationBooleanVO.h
//  Notifications
//
//  Created by Max Rozdobudko on 3/26/20.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRUntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXNotificationBooleanVO : NSObject

+ (instancetype)withValue:(BOOL)value;

- (id)initWithValue:(BOOL)value;

- (FREObject)toFREObject;

@end

NS_ASSUME_NONNULL_END
