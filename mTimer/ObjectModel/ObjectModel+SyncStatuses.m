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

#import "ObjectModel+SyncStatuses.h"
#import "SyncStatus.h"
#import "ObjectModel+Users.h"
#import "Constants.h"

@implementation ObjectModel (SyncStatuses)

- (SyncStatus *)anySyncStatusNeedingAction {
    NSPredicate *needsSyncPredicate = [NSPredicate predicateWithFormat:@"syncNeeded = YES"];
    NSPredicate *notFailedPredicate = [NSPredicate predicateWithFormat:@"syncFailed = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[needsSyncPredicate, notFailedPredicate]];
    return [self fetchEntityNamed:[SyncStatus entityName] withPredicate:predicate];
}

- (NSFetchedResultsController *)fetchedControllerForUserSyncStatuses {
    User *user = [self loggedInUser];
    NSPredicate *entryUserPredicate = [NSPredicate predicateWithFormat:@"statusForEntry.task.user = %@", user];
    NSPredicate *taskUserPredicate = [NSPredicate predicateWithFormat:@"statusForTask.user = %@", user];
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[entryUserPredicate, taskUserPredicate]];
    NSSortDescriptor *createdAtDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    return [self fetchedControllerForEntity:[SyncStatus entityName] predicate:predicate sortDescriptors:@[createdAtDescriptor]];
}

- (void)resetFailedSyncStatuses {
    NSPredicate *needsSyncPredicate = [NSPredicate predicateWithFormat:@"syncNeeded = YES"];
    NSPredicate *failedPredicate = [NSPredicate predicateWithFormat:@"syncFailed = YES"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[failedPredicate, needsSyncPredicate]];
    NSArray *failed = [self fetchEntitiesNamed:[SyncStatus entityName] withPredicate:predicate];
    TimerLog(@"Will reset %lu failed statuses", [failed count]);
    for (SyncStatus *status in failed) {
        [status setSyncFailedValue:NO];
    }
}

@end
