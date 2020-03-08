//
//  ANXNotificationCenterSettingsVO.h
//  ANXNotifications
//
//  Created by Max Rozdobudko on 06.03.2020.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXNotificationCenterSettingsVO : NSObject

- (id)initWithAuthorizationStatus:(NSString*)authorizationStatus;

- (FREObject)toFREObject;

@end

NS_ASSUME_NONNULL_END
