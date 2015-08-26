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

#import "ObjectModel.h"

@class TimeEntryObject;
@class TimeEntry;
@class Task;

@interface ObjectModel (TimeEntries)

- (void)insertOrUpdateTimeEntry:(TimeEntryObject *)entryObject;
- (NSFetchedResultsController *)fetchedControllerForEntriesOnDate:(NSDate *)date;
- (TimeEntry *)runningEntryForTask:(Task *)task;
- (void)markEntryForDeletion:(TimeEntry *)entry;
- (TimeEntry *)anyRunningEntry;
- (void)createEntryForTask:(Task *)task;
- (void)mapEntry:(TimeEntry *)entry withTask:(Task *)task;
- (void)stopRunningEntries;
- (NSArray *)remoteIdsForEntriesStartedFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (void)markEntriesDeletedRemotely:(NSArray *)remoteIds;
- (NSUInteger)numberOfRunningEntries;
- (void)markEntryComplete:(TimeEntry *)entry;
- (void)markEntryComplete:(TimeEntry *)entry pushChange:(BOOL)pushChange;

@end
