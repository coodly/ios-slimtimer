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

#import "PushTaskRequest.h"
#import "Task.h"
#import "Tag.h"
#import "ObjectModel+Credentials.h"
#import "SlimtimerRequest+Private.h"
#import "PushTaskResponse.h"
#import "TaskObject.h"
#import "ObjectModel+Tasks.h"
#import <JCSFoundation/JCSFoundationConstants.h>

NSString *const kTaskCreatePathBase = @"/users/%@/tasks";
NSString *const kTaskUpdatePathBase = @"/users/%@/tasks/%@";

@interface PushTaskRequest ()

@property (nonatomic, strong) NSManagedObjectID *taskID;

@end

@implementation PushTaskRequest

- (id)initWithTaskID:(NSManagedObjectID *)taskID {
    self = [super initWithResponseSerializer:[PushTaskResponse serializer]];
    if (self) {
        [self setTaskID:taskID];
    }
    return self;
}

- (void)execute {
    __weak PushTaskRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(NO, error);
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        PushTaskResponse *pushResponse = (PushTaskResponse *) response;
        TaskObject *object = pushResponse.taskObject;
        [weakSelf.workerModel performBlock:^{
            Task *task = (Task *) [weakSelf.workerModel.managedObjectContext objectWithID:weakSelf.taskID];
            JCSActionBlock updateTaskData = ^{
                [weakSelf.workerModel insertOrUpdateTask:object];
                [weakSelf.workerModel saveContext:^{
                    weakSelf.responseHandler(YES, nil);
                }];
            };

            if (task.taskIdValue == 0) {
                [task setTaskId:object.remoteId];
                [weakSelf.objectModel saveContext:updateTaskData];
            } else {
                [weakSelf.objectModel performBlock:updateTaskData];
            }
        }];
    }];

    [self.objectModel performBlock:^{
        Task *task = (Task *) [self.objectModel.managedObjectContext objectWithID:self.taskID];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"] = task.name;
        params[@"tags"] = [Tag joinedTags:[task.defaultTags allObjects] joinedBy:@","];

        NSDictionary *sent = @{@"task" : params};

        if (task.taskIdValue == 0) {
            NSString *path = [NSString stringWithFormat:kTaskCreatePathBase, [self.objectModel loggedInUserId]];
            [self postToPath:path content:sent];
        } else {
            NSString *path = [NSString stringWithFormat:kTaskUpdatePathBase, [self.objectModel loggedInUserId], task.taskId];
            [self putToPath:path content:sent];
        }
    }];
}

@end
