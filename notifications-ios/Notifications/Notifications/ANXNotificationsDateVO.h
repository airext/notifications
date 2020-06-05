//
//  ANXNotificationsDateVO.h
//  Notifications
//
//  Created by Max Rozdobudko on 5/29/20.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXNotificationsDateVO : NSObject

+ (instancetype)withValue:(NSDate*)value;

- (id)initWithValue:(NSDate*)value;

- (FREObject)toFREObject;

@end

NS_ASSUME_NONNULL_END
