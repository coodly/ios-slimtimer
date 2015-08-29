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

#import "NSDate+Formatting.h"
#import "NSDate+Calculations.h"

@implementation NSDate (Formatting)

- (NSString *)slimtimerParamsTimeString {
    return [[NSDate slimtimerOutFormatter] stringFromDate:self];
}

- (NSString *)slimtimerContentTimeString {
    return [[NSDate slimtimerInFormatter] stringFromDate:self];
}

- (NSString *)hourMinuteValues {
    return [[NSDate hourMinuteFormatter] stringFromDate:self];
}

- (NSString *)formattedDifferenceFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate gregorian] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:self options:0];

    if (components.hour > 0) {
        return  [NSString stringWithFormat:@"%ld:%02tu.%02tu", (long)components.hour, components.minute, components.second];
    } else {
        return  [NSString stringWithFormat:@"%ld.%02tu", (long)components.minute, components.second];
    }
}

- (NSString *)dateTimeValue {
    return [[NSDate dateTimeFormatter] stringFromDate:self];
}

+ (NSDate *)dateFromSlimtimerTime:(NSString *)timeString {
    return [[NSDate slimtimerInFormatter] dateFromString:timeString];
}

static NSDateFormatter *__hourMinuteFormatter;
+ (NSDateFormatter *)hourMinuteFormatter {
    if (!__hourMinuteFormatter) {
        __hourMinuteFormatter = [[NSDateFormatter alloc] init];
        [__hourMinuteFormatter setDateFormat:@"HH:mm"];
    }

    return __hourMinuteFormatter;
}

static NSDateFormatter *__slimtimerInFormatter;
+ (NSDateFormatter *)slimtimerInFormatter {
    if (!__slimtimerInFormatter) {
        __slimtimerInFormatter = [[NSDateFormatter alloc] init];
        [__slimtimerInFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    return __slimtimerInFormatter;
}

static NSDateFormatter *__slimtimerOutFormatter;
+ (NSDateFormatter *)slimtimerOutFormatter {
    if (!__slimtimerOutFormatter) {
        __slimtimerOutFormatter = [[NSDateFormatter alloc] init];
        [__slimtimerOutFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }

    return __slimtimerOutFormatter;
}

static NSDateFormatter *__dateTimeFormatter;
+ (NSDateFormatter *)dateTimeFormatter {
    if (!__dateTimeFormatter) {
        __dateTimeFormatter = [[NSDateFormatter alloc] init];
        [__dateTimeFormatter setDateStyle:NSDateFormatterMediumStyle];
        [__dateTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    }

    return __dateTimeFormatter;
}

@end
