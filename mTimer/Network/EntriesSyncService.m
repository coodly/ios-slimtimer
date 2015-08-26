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

#import "EntriesSyncService.h"
#import "ObjectModel.h"
#import "ObjectModel+Credentials.h"
#import "Constants.h"
#import "SyncStatus.h"
#import "ObjectModel+SyncStatuses.h"
#import "PushEntryRequest.h"
#import "_TimeEntry.h"
#import "TimeEntry.h"
#import "DeleteEntryRequest.h"
#import "TimeReport.h"
#import "TimeReportRequest.h"
#import "PushTaskRequest.h"
#import "Task.h"
#import "JCSFoundationConstants.h"

@interface EntriesSyncService () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) NSFetchedResultsController *allSyncStatuses;
@property (nonatomic, strong) SyncStatus *handled;
@property (nonatomic, strong) SlimtimerRequest *executedRequest;

@end

@implementation EntriesSyncService

- (id)initWithObjectModel:(ObjectModel *)model {
    self = [super init];
    if (self) {
        [self setObjectModel:model];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn:) name:kTimerLoggedInNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut:) name:kTimerLoggedOutNotification object:nil];
    }
    return self;
}

- (void)checkStatusesToPush {
    TimerLog(@"checkStatusesToPush");
    if (![self.objectModel loggedIn]) {
        TimerLog(@"Not logged in. Abort.");
        return;
    }

    [self.objectModel resetFailedSyncStatuses];
    [self.objectModel saveContext];

    [self handleNextSyncStatus:^{
        [self setupForMonitoring];
    }];
}

- (void)loggedIn:(NSNotification *)notification {
    TimerLog(@"Logged in");
    [self checkStatusesToPush];
}

- (void)loggedOut:(NSNotification *)notification {
    TimerLog(@"Logged out");
    [self.allSyncStatuses setDelegate:nil];
    [self setAllSyncStatuses:nil];
}

- (void)handleNextSyncStatus:(JCSActionBlock)completion {
    [self.objectModel performBlock:^{
        if (self.handled) {
            TimerLog(@"Sync in progress. Ignore");
            completion();
            return;
        }

        SyncStatus *status = [self.objectModel anySyncStatusNeedingAction];
        if (!status) {
            TimerLog(@"No statuses found. Abort");
            completion();
            return;
        }

        [self setHandled:status];

        SlimtimerRequest *request = nil;

        if (status.statusForEntry) {
            TimeEntry *entry = status.statusForEntry;
            if (entry.markedForDeletionValue) {
                TimerLog(@"Marked for deletion");
                request = [[DeleteEntryRequest alloc] initWithEntryID:entry.objectID];
            } else {
                TimerLog(@"Update");
                request = [[PushEntryRequest alloc] initWithEntryID:entry.objectID];
            }
        } else if (status.statusForReport) {
            TimeReport *report = status.statusForReport;
            request = [[TimeReportRequest alloc] initWithReportID:report.objectID];
        } else if (status.statusForTask) {
            Task *task = status.statusForTask;
            request = [[PushTaskRequest alloc] initWithTaskID:task.objectID];
        } else {
            JCSAssert(NO);
        }

        [self setExecutedRequest:request];
        [request setObjectModel:self.objectModel];
        [request setResponseHandler:^(BOOL success, NSError *error) {
            [self.objectModel performBlock:^{
                if (error) {
                    TimerLog(@"Sync error:%@", error);
                }

                if (success) {
                    [status setSyncNeededValue:NO];
                } else {
                    [status setSyncFailedValue:YES];
                }

                [self setHandled:nil];

                [self.objectModel saveContext:^{
                    [self handleNextSyncStatus:completion];
                }];
            }];
        }];
        [request execute];
    }];
}

- (void)setupForMonitoring {
    if (self.allSyncStatuses) {
        return;
    }

    NSFetchedResultsController *controller = [self.objectModel fetchedControllerForUserSyncStatuses];
    [self setAllSyncStatuses:controller];
    [controller setDelegate:self];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self handleNextSyncStatus:^{
        TimerLog(@"All handled");
    }];
}

@end
