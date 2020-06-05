//
//  ANXNotificationsConversionRoutines.h
//  ANXNotifications
//
//  Created by Max Rozdobudko on 6/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface ANXNotificationsConversionRoutines : NSObject

+ (void)setStringTo: (FREObject) object withValue: (NSString *) value forProperty: (NSString *) property;

#pragma mark Conversion methods

+ (FREObject)convertNSStringToFREObject:(NSString*) string;
+ (NSString*)convertFREObjectToNSString: (FREObject) string;

+ (FREObject)convertNSDateToFREObject:(NSDate*)date;
+ (NSDate*)convertFREObjectToNSDate: (FREObject) date;

+ (NSUInteger)convertFREObjectToNSUInteger: (FREObject) integer withDefault: (NSUInteger) defaultValue;

+ (NSInteger)convertFREObjectToNSInteger: (FREObject) integer withDefault: (NSInteger) defaultValue;
+ (FREObject)convertNSIntegerToFREObject: (NSInteger) integer;

+ (FREObject)convertLongLongToFREObject: (long long) number;

+ (double)convertFREObjectToDouble: (FREObject) number;
+ (FREObject)convertDoubleToFREObject: (double) value;

+ (BOOL)convertFREObjectToBool: (FREObject) value;
+ (FREObject)convertBoolToFREObject: (BOOL) value;

+ (NSString*)readNSStringFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSString*)defaultValue;
+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSInteger)defaultValue;
+ (double)readDoubleFrom:(FREObject)object field:(NSString*)field withDefaultValue:(double)defaultValue;
+ (BOOL)readBooleanFrom:(FREObject)object field:(NSString*)field withDefaultValue:(BOOL)defaultValue;

+ (FREObject)readFREObjectFrom:(FREObject)object field:(NSString*)field;

@end
