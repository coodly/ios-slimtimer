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

#import "ObjectModel+Dates.h"
#import "NSDate+Calculations.h"
#import "Day.h"
#import "Year.h"
#import "Month.h"
#import "ObjectModel+Users.h"

@implementation ObjectModel (Dates)

- (BOOL)hasMarkerForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate gregorian] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];

    NSPredicate *dayPredicate = [NSPredicate predicateWithFormat:@"value = %d", components.day];
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"month.value = %d", components.month];
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"month.year.value = %d", components.year];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"month.year.user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[dayPredicate, monthPredicate, yearPredicate, userPredicate]];

    return [self countInstancesOfEntity:[Day entityName] withPredicate:predicate] != 0;
}

- (void)addMarkerForDate:(NSDate *)date {
    [self performBlock:^{
        NSDateComponents *components = [[NSDate gregorian] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];

        Year *year = [self yearWithValue:components.year];
        Month *month = [self monthWithValue:components.month year:year];
        Day *day = [self dayWithValue:components.day month:month];

        [self saveContext];
    }];
}

- (Day *)dayWithValue:(NSInteger)dayValue month:(Month *)month {
    NSPredicate *dayPredicate = [NSPredicate predicateWithFormat:@"value = %d", dayValue];
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"month = %@", month];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[dayPredicate, monthPredicate]];
    Day *day = [self fetchEntityNamed:[Day entityName] withPredicate:predicate];
    if (!day) {
        day = [Day insertInManagedObjectContext:self.managedObjectContext];
        [day setValueValue:dayValue];
        [day setMonth:month];
    }

    return day;
}

- (Month *)monthWithValue:(NSInteger)monthValue year:(Year *)year {
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"value = %d", monthValue];
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"year = %@", year];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[monthPredicate, yearPredicate]];
    Month *month = [self fetchEntityNamed:[Month entityName] withPredicate:predicate];
    if (!month) {
        month = [Month insertInManagedObjectContext:self.managedObjectContext];
        [month setValueValue:monthValue];
        [month setYear:year];
    }

    return month;
}

- (Year *)yearWithValue:(NSInteger)yearValue {
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"value = %d", yearValue];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[yearPredicate, userPredicate]];
    Year *existing = [self fetchEntityNamed:[Year entityName] withPredicate:predicate];
    if (!existing) {
        existing = [Year insertInManagedObjectContext:self.managedObjectContext];
        [existing setValueValue:yearValue];
        [existing setUser:[self loggedInUser]];
    }
    
    return existing;
}

@end
