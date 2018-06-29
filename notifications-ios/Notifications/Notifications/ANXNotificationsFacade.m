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
        NSString* title      = [ANXNotificationsConversionRoutines readNSStringFrom:content field:@"title" withDefaultValue:@""];
        NSString* body       = [ANXNotificationsConversionRoutines readNSStringFrom:content field:@"body" withDefaultValue:@""];
        FREObject sound      = [ANXNotificationsConversionRoutines readFREObjectFrom:content field:@"sound"];

        NSLog(@"ANX sound:%@", sound != nil ? @"some sound" : @"nil");

        NSString* soundName  = nil;
        if (sound) {
            soundName = [ANXNotificationsConversionRoutines readNSStringFrom:sound field:@"named" withDefaultValue:nil];
        }

        NSLog(@"ANX soundName:%@", soundName);

        NSTimeInterval timeInterval = [ANXNotificationsConversionRoutines readDoubleFrom:trigger field:@"timeInterval" withDefaultValue:0.0];

        FREObject userInfoObject;
        FRECallObjectMethod(content, (const uint8_t *) "userInfoAsJSON", 0, NULL, &userInfoObject, NULL);
        NSString* userInfo   = [ANXNotificationsConversionRoutines convertFREObjectToNSString:userInfoObject];

        NSString* identifierAsString = [NSString stringWithFormat:@"%li", (long)identifier];

        [ANXNotificationCenter.sharedInstance addNotificationRequestWithIdentifier:identifierAsString
                                                                         timestamp:timeInterval
                                                                             title:title
                                                                              body:body
                                                                        soundNamed:soundName
                                                                          userInfo:userInfo
                                                                    withCompletion:^(NSError *error) {
                                                                        if (error) {
                                                                            [call reject:error];
                                                                        } else {
                                                                            [call result:nil];
                                                                        }
                                                                    }];
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

            [identifiers addObject:[NSString stringWithFormat:@"(long)%li", (long)[ANXNotificationsConversionRoutines convertFREObjectToNSInteger:identifierObject withDefault:0]]];
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

    *numFunctionsToSet = 13;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXNotificationsIsSupported;


    func[1].name = (const uint8_t*) "isSupported";
    func[1].functionData = NULL;
    func[1].function = &ANXNotificationsIsSupported;

    func[2].name = (const uint8_t*) "inBackground";
    func[2].functionData = NULL;
    func[2].function = &ANXNotificationsInBackground;

    func[3].name = (const uint8_t*) "inForeground";
    func[3].functionData = NULL;
    func[3].function = &ANXNotificationsInForeground;

    func[4].name = (const uint8_t*) "isEnabled";
    func[4].functionData = NULL;
    func[4].function = &ANXNotificationsIsEnabled;

    func[5].name = (const uint8_t*) "getNotificationSettings";
    func[5].functionData = NULL;
    func[5].function = &ANXNotificationsGetNotificationSettings;

    func[6].name = (const uint8_t*) "requestAuthorization";
    func[6].functionData = NULL;
    func[6].function = &ANXNotificationsRequestAuthorization;

    func[7].name = (const uint8_t*) "addRequest";
    func[7].functionData = NULL;
    func[7].function = &ANXNotificationsAddRequest;

    func[8].name = (const uint8_t*) "removePendingNotificationRequests";
    func[8].functionData = NULL;
    func[8].function = &ANXNotificationsRemovePendingNotificationRequests;

    func[9].name = (const uint8_t*) "removeAllPendingNotificationRequests";
    func[9].functionData = NULL;
    func[9].function = &ANXNotificationsRemoveAllPendingNotificationRequests;

    func[10].name = (const uint8_t*) "canOpenSettings";
    func[10].functionData = NULL;
    func[10].function = &ANXNotificationsCanOpenSettings;

    func[11].name = (const uint8_t*) "openSettings";
    func[11].functionData = NULL;
    func[11].function = &ANXNotificationsOpenSettings;

    func[12].name = (const uint8_t*) "createNotificationChannel";
    func[12].functionData = NULL;
    func[12].function = &ANXNotificationsCreateNotificationChannel;

    // setup bridge

    [ANXBridge setup:numFunctionsToSet functions:&func];

    *functionsToSet = func;

    // Store reference to the context

    ANXNotifications.sharedInstance.context = ctx;
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
