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

#import "ObjectModel+TimeEntries.h"
#import "TimeEntryObject.h"
#import "TimeEntry.h"
#import "ObjectModel+Users.h"
#import "NSDate+Calculations.h"
#import "Task.h"
#import "ObjectModel+Tags.h"
#import "ObjectModel+Tasks.h"
#import "Constants.h"
#import "SyncStatus.h"

@implementation ObjectModel (TimeEntries)

- (TimeEntry *)existingEntryWithRemoteId:(NSNumber *)remoteId {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId = %@", remoteId];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"task.user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[remoteIdPredicate, userPredicate]];
    return [self fetchEntityNamed:[TimeEntry entityName] withPredicate:predicate];
}

- (void)insertOrUpdateTimeEntry:(TimeEntryObject *)entryObject {
    NSDate *remoteUpdateTime = [entryObject.updatedAt dateFromGMT];
    TimeEntry *entry = [self existingEntryWithRemoteId:entryObject.remoteId];
    TimerLog(@"Local:%@ Remote:%@", entry.touchedAt, remoteUpdateTime);
    if (!entry) {
        entry = [TimeEntry insertInManagedObjectContext:self.managedObjectContext];
        [entry setRemoteId:entryObject.remoteId];
        [entry setTask:[self insertOrUpdateTask:entryObject.task]];
    } else if ([[entry.touchedAt laterDate:remoteUpdateTime] isEqualToDate:entry.touchedAt]) {
        TimerLog(@"Local update after remote update. Ignore coming in");
        return;
    }

    [entry setStartTime:entryObject.startTime];
    if (entryObject.inProgress) {
        [entry setEndTime:nil];
    } else {
        [entry setEndTime:entryObject.endTime];
    }
    [entry setComment:entryObject.comment];
    NSSet *tagsOnEntry = [self insertOrUpdateTags:entryObject.tags];
    NSSet *allTags = [tagsOnEntry setByAddingObjectsFromSet:[entry.task defaultTags]];
    [entry setTags:allTags];
    [entry setTouchedAt:remoteUpdateTime];
    [entry.task markUpdated];
}

- (NSFetchedResultsController *)fetchedControllerForEntriesOnDate:(NSDate *)date {
    NSPredicate *startTimeAfterPredicate = [NSPredicate predicateWithFormat:@"startTime >= %@", [date startOfDay]];
    NSPredicate *startTimeBeforePredicate = [NSPredicate predicateWithFormat:@"startTime < %@", [[date nextDay] startOfDay]];
    NSPredicate *notMarkedForDeletionPredicate = [NSPredicate predicateWithFormat:@"markedForDeletion == 0"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[startTimeAfterPredicate, startTimeBeforePredicate, notMarkedForDeletionPredicate]];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    return [self fetchedControllerForEntity:[TimeEntry entityName] predicate:predicate sortDescriptors:@[timeSort]];
}

- (TimeEntry *)runningEntryForTask:(Task *)task {
    NSPredicate *endTimeExistsPredicate = [NSPredicate predicateWithFormat:@"endTime == nil"];
    NSPredicate *notMarkedForDeletionPredicate = [NSPredicate predicateWithFormat:@"markedForDeletion == 0"];
    NSPredicate *taskPredicate = [NSPredicate predicateWithFormat:@"task = %@", task];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[endTimeExistsPredicate, notMarkedForDeletionPredicate, taskPredicate]];
    return [self fetchEntityNamed:[TimeEntry entityName] withPredicate:predicate];
}

- (void)markEntryForDeletion:(TimeEntry *)entry {
    [entry setMarkedForDeletionValue:YES];
    [entry.task markUpdated];
}

- (TimeEntry *)anyRunningEntry {
    NSPredicate *noEndTimePredicate = [NSPredicate predicateWithFormat:@"endTime == nil"];
    NSPredicate *notMarkedForDeletion = [NSPredicate predicateWithFormat:@"markedForDeletion == NO"];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"task.user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[noEndTimePredicate, notMarkedForDeletion, userPredicate]];
    return [self fetchFirstEntityNamed:[TimeEntry entityName] withPredicate:predicate sortDescriptors:nil];
}

- (void)createEntryForTask:(Task *)task {
    TimeEntry *entry = [TimeEntry insertInManagedObjectContext:self.managedObjectContext];
    [entry setStartTime:[NSDate date]];
    [entry setTouchedAt:[NSDate date]];
    [entry setTask:task];
    [entry setTags:task.defaultTags];
    [entry markSyncRequired];
}

- (void)mapEntry:(TimeEntry *)timeEntry withTask:(Task *)selectedTask {
    Task *previousTask = timeEntry.task;
    [timeEntry setTask:selectedTask];

    NSMutableSet *tags = [NSMutableSet setWithSet:timeEntry.tags];
    [tags minusSet:previousTask.defaultTags];
    [tags addObjectsFromArray:[selectedTask.defaultTags allObjects]];
    [timeEntry setTags:tags];

    [previousTask markUpdated];
    [selectedTask markUpdated];
}

- (void)stopRunningEntries {
    NSArray *running = [self runningTimeEntries];
    TimerLog(@"Have %lu running", [running count]);
    for (TimeEntry *entry in running) {
        [self markEntryComplete:entry];
    }
}

- (NSArray *)runningTimeEntries {
    NSPredicate *noEndTimePredicate = [NSPredicate predicateWithFormat:@"endTime == nil"];
    NSPredicate *notMarkedForDeletion = [NSPredicate predicateWithFormat:@"markedForDeletion == NO"];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"task.user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[noEndTimePredicate, notMarkedForDeletion, userPredicate]];
    return [self fetchEntitiesNamed:[TimeEntry entityName] withPredicate:predicate];
}

- (NSArray *)remoteIdsForEntriesStartedFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId != nil"];
    NSPredicate *startTimePredicate = [NSPredicate predicateWithFormat:@"startTime >= %@", startDate];
    NSPredicate *endTimePredicate = [NSPredicate predicateWithFormat:@"startTime < %@", endDate];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"task.user = %@", [self loggedInUser]];
    NSPredicate *notMarkedForDeletionPredicate = [NSPredicate predicateWithFormat:@"markedForDeletion == 0"];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[remoteIdPredicate, notMarkedForDeletionPredicate, startTimePredicate, endTimePredicate, userPredicate]];

    return [self fetchAttributeNamed:@"remoteId" forEntity:[TimeEntry entityName] withPredicate:predicate];
}

- (void)markEntriesDeletedRemotely:(NSArray *)remoteIds {
    TimerLog(@"Will mark %lu entries deleted remotely", [remoteIds count]);
    NSArray *entries = [self entriesWithRemoteIds:remoteIds];
    for (TimeEntry *entry in entries) {
        [entry setMarkedForDeletionValue:YES];
        [entry.syncStatus setSyncNeededValue:NO];
        [entry.task markUpdated];
    }
}

- (NSUInteger)numberOfRunningEntries {
    NSPredicate *notMarkedForDeletionPredicate = [NSPredicate predicateWithFormat:@"markedForDeletion == NO"];
    NSPredicate *endTimePredicate = [NSPredicate predicateWithFormat:@"endTime == nil"];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"task.user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notMarkedForDeletionPredicate, endTimePredicate, userPredicate]];
    return [self countInstancesOfEntity:[TimeEntry entityName] withPredicate:predicate];
}

- (void)markEntryComplete:(TimeEntry *)entry {
    [self markEntryComplete:entry pushChange:YES];
}

- (void)markEntryComplete:(TimeEntry *)entry pushChange:(BOOL)pushChange {
    [entry setEndTime:[NSDate date]];
    [entry markUpdated];
    if (pushChange) {
        [entry markSyncRequired];
    }
}

- (NSArray *)entriesWithRemoteIds:(NSArray *)remoteIds {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId IN %@", remoteIds];
    return [self fetchEntitiesNamed:[TimeEntry entityName] withPredicate:remoteIdPredicate];
}

@end
