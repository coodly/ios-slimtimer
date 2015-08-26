/*
* Copyright 2015 Coodly LLC
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "NSDate+Calculations.h"

@implementation NSDate (Calculations)

- (NSDate *)nextDay {
    return [self dateByAddingDays:1];
}

- (NSDate *)previousDay {
    return [self dateByAddingDays:-1];
}

- (NSDate *)startOfDay {
    NSDateComponents *components = [[NSDate gregorian] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSDate gregorian] dateFromComponents:components];
}

- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:daysToAdd];
    return [self dateByAddingComponents:dateComponents];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)components {
    return [[NSDate gregorian] dateByAddingComponents:components toDate:self options:0];
}

- (BOOL)isToday {
    NSCalendarUnit dayComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *myComponents = [[NSDate gregorian] components:dayComponents fromDate:self];
    NSDateComponents *nowComponents = [[NSDate gregorian] components:dayComponents fromDate:[NSDate date]];

    return myComponents.year == nowComponents.year && myComponents.month == nowComponents.month && myComponents.day == nowComponents.day;
}

- (BOOL)isDateInPast {
    return [[NSDate date] laterDate:self] != self;
}

- (BOOL)lessThanHourAgo {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];
    return interval < 60 * 60;
}

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
    if (!__gregorian) {
        __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return __gregorian;
}

- (NSDate *)dateFromGMT {
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [self timeIntervalSinceReferenceDate] + timeZoneOffset;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
}

@end
