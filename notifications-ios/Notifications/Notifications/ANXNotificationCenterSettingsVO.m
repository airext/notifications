//
//  ANXNotificationCenterSettingsVO.m
//  ANXNotifications
//
//  Created by Max Rozdobudko on 06.03.2020.
//  Copyright © 2020 Max Rozdobudko. All rights reserved.
//

#import "ANXNotificationCenterSettingsVO.h"
#import "ANXNotificationsConversionRoutines.h"

@implementation ANXNotificationCenterSettingsVO {
    NSString* _authorizationStatus;
}

- (id)initWithAuthorizationStatus:(NSString*)authorizationStatus {
    if ([super init]) {
        _authorizationStatus = authorizationStatus;
    }
    return self;
}

- (FREObject)toFREObject {
    FREObject resultObject;
    if (FRENewObject((const uint8_t *)"com.github.airext.notifications.NotificationCenterSettings", 0, NULL, &resultObject, NULL) != FRE_OK) {
        return NULL;
    }
    if (FRESetObjectProperty(resultObject, (const uint8_t *)"authorizationStatus", [ANXNotificationsConversionRoutines convertNSStringToFREObject:_authorizationStatus], NULL) != FRE_OK) {
        return NULL;
    }
    return resultObject;
}

@end
