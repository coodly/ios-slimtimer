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
//

#import "PushEntryRequest.h"
#import "SlimtimerRequest+Private.h"
#import "ObjectModel+Credentials.h"
#import "TimeEntry.h"
#import "NSDate+Formatting.h"
#import "_Task.h"
#import "Task.h"
#import "ListTimeEntriesResponse.h"
#import "NSString+JCSValidations.h"
#import "PushEntryResponse.h"
#import "TimeEntryObject.h"
#import "ObjectModel+TimeEntries.h"

NSString *const kCreateTaskPathBase = @"/users/%@/time_entries";
NSString *const kUpdateTaskPathBase = @"/users/%@/time_entries/%@";

@interface PushEntryRequest ()

@property (nonatomic, strong) NSManagedObjectID *entryID;

@end

@implementation PushEntryRequest

- (id)initWithEntryID:(NSManagedObjectID *)entryID {
    self = [super initWithResponseSerializer:[PushEntryResponse serializer]];
    if (self) {
        [self setEntryID:entryID];
    }
    return self;
}

- (void)execute {
    __weak PushEntryRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(NO, error);
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        PushEntryResponse *pushResponse = (PushEntryResponse *) response;
        [weakSelf.workerModel performBlock:^{
            TimeEntry *entry = (TimeEntry *) [weakSelf.workerModel.managedObjectContext objectWithID:weakSelf.entryID];
            [entry setRemoteId:pushResponse.entryObject.remoteId];
            [weakSelf.workerModel insertOrUpdateTimeEntry:pushResponse.entryObject];
            [weakSelf.workerModel saveContext:^{
                weakSelf.responseHandler(YES, nil);
            }];
        }];
    }];

    [self.objectModel performBlock:^{
        TimeEntry *entry = (TimeEntry *) [self.objectModel.managedObjectContext objectWithID:self.entryID];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"start-time"] = [entry.startTime slimtimerContentTimeString];
        if (entry.endTime) {
            params[@"end-time"] = [entry.endTime slimtimerContentTimeString];
            params[@"in-progress"] = @"false";
        } else {
            params[@"in-progress"] = @"true";
        }
        params[@"duration-in-seconds"] = @(MAX([entry durationInSeconds].integerValue, 60));
        params[@"task-id"] = entry.task.taskId;
        NSString *tags = [entry joinedTagsMinusDefaultTags];
        if ([tags hasValue]) {
            params[@"tags"] = tags;
        }
        if ([entry.comment hasValue]) {
            params[@"comments"] = entry.comment;
        }

        NSDictionary *sentContent = @{@"time-entry": params};

        if (entry.remoteId) {
            [self updateTaskWithContent:sentContent entryId:entry.remoteId];
        } else {
            [self createTaskWithContent:sentContent];
        }
    }];
}

- (void)createTaskWithContent:(NSDictionary *)params {
    NSString *path = [NSString stringWithFormat:kCreateTaskPathBase, self.objectModel.loggedInUserId];
    [self postToPath:path content:params];
}

- (void)updateTaskWithContent:(NSDictionary *)params entryId:(NSNumber *)entryId {
    NSString *path = [NSString stringWithFormat:kUpdateTaskPathBase, self.objectModel.loggedInUserId, entryId];
    [self putToPath:path content:params];
}

@end
