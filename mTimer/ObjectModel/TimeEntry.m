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

#import "TimeEntry.h"
#import "NSDate+Formatting.h"
#import "NSDate+Calculations.h"
#import "Task.h"
#import "Tag.h"
#import "SyncStatus.h"

@interface TimeEntry ()

@end


@implementation TimeEntry

- (NSString *)formattedStartEndTime {
    return [NSString stringWithFormat:@"%@-%@", [self.startTime hourMinuteValues], (self.endTime ? [self.endTime hourMinuteValues] : @"...")];
}

- (NSString *)formattedRunTime {
    return [self.endTime formattedDifferenceFromDate:self.startTime];
}

- (void)markUpdated {
    [self setTouchedAt:[NSDate date]];
    [self.task markUpdated];
}

- (NSString *)formattedStartTime {
    return [self formattedDate:self.startTime];
}

- (NSString *)formattedEndTime {
    return [self formattedDate:self.endTime];
}

- (NSString *)formattedDate:(NSDate *)date {
    if (!date) {
        return @"...";
    }

    if ([date isToday]) {
        return [date hourMinuteValues];
    }

    return [date dateTimeValue];
}

- (NSString *)joinedTags {
    return [Tag joinedTags:[self.tags allObjects] joinedBy:@", "];
}

- (NSString *)joinedTagsMinusDefaultTags {
    NSMutableSet *tags = [NSMutableSet setWithSet:self.tags];
    [tags minusSet:self.task.defaultTags];
    return [Tag joinedTags:[tags allObjects] joinedBy:@","];
}

- (NSNumber *)durationInSeconds {
    NSDate *endTime = self.endTime ? self.endTime : [NSDate date];
    NSTimeInterval duration = [endTime timeIntervalSinceDate:self.startTime];
    return [NSNumber numberWithInteger:(NSInteger) duration];
}

- (void)markSyncRequired {
    [self.mySyncStatus setSyncNeededValue:YES];
}

- (NSDate *)possibleEndTime {
    NSDate *possibleEnd = self.endTime;
    if (!possibleEnd) {
        possibleEnd = [NSDate date];
    }

    return possibleEnd;
}

- (SyncStatus *)mySyncStatus {
    if (!self.syncStatus) {
        [self setSyncStatus:[SyncStatus insertInManagedObjectContext:self.managedObjectContext]];
    }

    return self.syncStatus;
}

@end
