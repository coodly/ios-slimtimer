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

#import "ListTasksRequest.h"
#import "ObjectModel+Credentials.h"
#import "SlimtimerRequest+Private.h"
#import "ListTasksResponse.h"
#import "TaskObject.h"
#import "ObjectModel+Tasks.h"
#import "Constants.h"
#import "ObjectModel+Purchases.h"

NSString *const kListTasksPathBase = @"/users/%@/tasks";

@interface ListTasksRequest ()

@property (nonatomic, strong) NSMutableArray *knownTaskIds;

@end

@implementation ListTasksRequest

- (id)init {
    self = [super initWithResponseSerializer:[ListTasksResponse serializer]];
    if (self) {

    }

    return self;
}

- (void)execute {
    NSArray *knownIds =  [self.objectModel knownTaskIds];
    TimerLog(@"Know %tu ids", [knownIds count]);
    [self setKnownTaskIds:[NSMutableArray arrayWithArray:knownIds]];
    [self executeWithOffset:0];
}

- (void)executeWithOffset:(NSInteger)offset {
    TimerLog(@"executeWithOffset:%tu", offset);
    NSString *path = [NSString stringWithFormat:kListTasksPathBase, [self.objectModel loggedInUserId]];

    __weak ListTasksRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(NO, error);
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        [weakSelf.workerModel performBlock:^{
            ListTasksResponse *listResponse = (ListTasksResponse *) response;
            NSArray *tasks = listResponse.tasks;
            for (TaskObject *task in tasks) {
                [weakSelf.knownTaskIds removeObject:task.remoteId];
                [weakSelf.workerModel insertOrUpdateTask:task];
            }

            [weakSelf.workerModel saveContext:^{
                if ([tasks count] == 50) {
                    [weakSelf executeWithOffset:offset + 50];
                } else {
                    [weakSelf.objectModel deleteTasksWithIds:weakSelf.knownTaskIds];
                    [weakSelf.objectModel checkUnlockedTask];
                    weakSelf.responseHandler(YES, nil);
                }
            }];
        }];
    }];

    [self getDataFromPath:path params:@{@"offset" : @(offset)}];
}

@end
