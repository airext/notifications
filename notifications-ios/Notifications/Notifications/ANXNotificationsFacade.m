//
//  Notifications.m
//  Notifications
//
//  Created by Max Rozdobudko on 6/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import "ANXNotificationsFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXBridge.h"
#import "ANXBridgeCall.h"
#import "ANXNotifications.h"
#import "ANXNotificationsConversionRoutines.h"
#import "ANXNotificationCenter.h"
#import "ANXNotificationCenterSettingsVO.h"
#import "UserNotifications+FRE.h"

@implementation ANXNotificationsFacade

@end

#pragma mark API

FREObject ANXNotificationsIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsIsSupported");
    return [ANXNotificationsConversionRoutines convertBoolToFREObject:ANXNotifications.sharedInstance.isSupported];
}

#pragma mark NotificationCenter

FREObject ANXNotificationsInBackground(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsInBackground");
    [ANXNotificationCenter inBackground];
    return NULL;
}

FREObject ANXNotificationsInForeground(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsInForeground");
    [ANXNotificationCenter inForeground];
    return NULL;
}

FREObject ANXNotificationsIsEnabled(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsIsEnabled");
    return [ANXNotificationsConversionRoutines convertBoolToFREObject:[ANXNotificationCenter isEnabled]];
}

FREObject ANXNotificationsGetNotificationSettings(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsGetNotificationSettings");

    ANXBridgeCall* call = [ANXBridge call:context];

    [ANXNotificationCenter getNotificationSettingsWithCompletion:^(NSString *authorizationStatus) {
        [call result:[[ANXNotificationCenterSettingsVO alloc] initWithAuthorizationStatus:authorizationStatus]];
    }];

    return [call toFREObject];
}

FREObject ANXNotificationsRequestAuthorization(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsRequestAuthorization");

    ANXBridgeCall* call = [ANXBridge call:context];

    if (argc > 0) {
        NSInteger options = [ANXNotificationsConversionRoutines convertFREObjectToNSInteger:argv[0] withDefault:0];
        [ANXNotificationCenter requestAuthorizationWithOPtions:options withCompletion:^(BOOL granted, NSError *error) {
            if (granted) {
                [call result:@"granted"];
            } else {
                if (error) {
                    [call reject:error];
                } else {
                    [call result:@"denied"];
                }
            }
        }];
    }

    return [call toFREObject];
}

FREObject ANXNotificationsAddRequest(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsAddRequest");

    ANXBridgeCall* call = [ANXBridge call:context];

    if (argc > 0) {
        FREObject request = argv[0];
        FREObject content = [ANXNotificationsConversionRoutines readFREObjectFrom:request field:@"content"];
        FREObject trigger = [ANXNotificationsConversionRoutines readFREObjectFrom:request field:@"trigger"];

        NSInteger identifier = [ANXNotificationsConversionRoutines readNSIntegerFrom:request field:@"identifier" withDefaultValue:0];

        void (^completion)(NSError *error) = ^(NSError *error) {
            if (error) {
                [call reject:error];
            } else {
                [call result:nil];
            }
        };

        [ANXNotificationCenter.sharedInstance addNotificationRequestWithIdentifier:[NSString stringWithFormat:@"%li", (long)identifier]
                                                                           trigger:[UNNotificationTrigger triggerWithFREObject:trigger]
                                                                           content:[[UNMutableNotificationContent alloc] initWithFREObject:content]
                                                                    withCompletion:completion];
    }

    return [call toFREObject];
}

FREObject ANXNotificationsRemovePendingNotificationRequests(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsRemovePendingNotificationRequests");
    if (argc > 0) {
        NSMutableArray* identifiers = [NSMutableArray array];
        uint32_t identifierCount;
        FREGetArrayLength(argv[0], &identifierCount);
        for (uint32_t index = 0; index < identifierCount; index++) {
            FREObject identifierObject;
            FREGetArrayElementAt(argv[0], index, &identifierObject);
            NSString* identifier = [NSString stringWithFormat:@"%li", (long)[ANXNotificationsConversionRoutines convertFREObjectToNSInteger:identifierObject withDefault:0]];
            [identifiers addObject:identifier];
        }
        [ANXNotificationCenter.sharedInstance removePendingNotificationRequestWithIdentifiers:identifiers];
    }
    return NULL;
}

FREObject ANXNotificationsRemoveAllPendingNotificationRequests(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsRemoveAllPendingNotificationRequests");
    [ANXNotificationCenter.sharedInstance removeAllPendingRequests];
    return NULL;
}

FREObject ANXNotificationsCanOpenSettings(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsCanOpenSettings");
    return NULL;
}

FREObject ANXNotificationsOpenSettings(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsOpenSettings");
    return NULL;
}

FREObject ANXNotificationsCreateNotificationChannel(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNotificationsCreateNotificationChannel");
    NSLog(@"Warning: Creation Notification Center is not supported on iOS");
    return NULL;
}

#pragma mark ContextInitialize/ContextFinalizer

void ANXNotificationsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXNotificationsContextInitializer");

    static FRENamedFunction functions[] = {
        { (const uint8_t*)"isSupported", NULL, &ANXNotificationsIsSupported },
        { (const uint8_t*)"isEnabled", NULL, &ANXNotificationsIsEnabled },

        { (const uint8_t*)"inBackground", NULL, &ANXNotificationsInBackground },
        { (const uint8_t*)"inForeground", NULL, &ANXNotificationsInForeground },

        { (const uint8_t*)"getNotificationSettings", NULL, &ANXNotificationsGetNotificationSettings },
        { (const uint8_t*)"requestAuthorization", NULL, &ANXNotificationsRequestAuthorization },

        { (const uint8_t*)"addRequest", NULL, &ANXNotificationsAddRequest },
        { (const uint8_t*)"removePendingNotificationRequests", NULL, &ANXNotificationsRemovePendingNotificationRequests },
        { (const uint8_t*)"removeAllPendingNotificationRequests", NULL, &ANXNotificationsRemoveAllPendingNotificationRequests },

        { (const uint8_t*)"canOpenSettings", NULL, &ANXNotificationsCanOpenSettings },
        { (const uint8_t*)"openSettings", NULL, &ANXNotificationsOpenSettings },

        { (const uint8_t*)"createNotificationChannel", NULL, &ANXNotificationsCreateNotificationChannel },
    };

    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);

    // setup bridge

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));
    memcpy(func, functions, sizeof(functions));

    [ANXBridge setup:numFunctionsToSet functions:&func];

    *functionsToSet = func;

    // Store reference to the context

    ANXNotifications.sharedInstance.context = ctx;

    NSLog(@"ANXNotificationsContextInitializer finished");
}

void ANXNotificationsContextFinalizer(FREContext ctx){
    NSLog(@"ANXNotificationsContextFinalizer");
    ANXNotifications.sharedInstance.context = nil;
}

#pragma mark Initializer/Finalizer

void ANXNotificationsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet){
    NSLog(@"ANXNotificationsInitializer");

    *extDataToSet = NULL;

    *ctxInitializerToSet = &ANXNotificationsContextInitializer;
    *ctxFinalizerToSet = &ANXNotificationsContextFinalizer;
}

void ANXNotificationsFinalizer(void* extData){
    NSLog(@"ANXNotificationsFinalizer");
}
