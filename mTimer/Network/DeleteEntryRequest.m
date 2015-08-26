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

#import "DeleteEntryRequest.h"
#import "DeleteEntryResponse.h"
#import "ObjectModel+Settings.h"
#import "TimeEntry.h"
#import "ObjectModel+Credentials.h"
#import "SlimtimerRequest+Private.h"
#import "Constants.h"
#import "NSError+Slimtimer.h"

NSString *const kDeleteTaskPathBase = @"/users/%@/time_entries/%@";

@interface DeleteEntryRequest ()

@property (nonatomic, strong) NSManagedObjectID *entryID;

@end

@implementation DeleteEntryRequest

- (id)initWithEntryID:(NSManagedObjectID *)entryID {
    self = [super initWithResponseSerializer:[DeleteEntryResponse serializer]];
    if (self) {
        [self setEntryID:entryID];
    }

    return self;
}

- (void)execute {
    __weak DeleteEntryRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        if (error.hasNoEntryError) {
            TimerLog(@"No entry on server. Continue!");
            weakSelf.responseHandler(YES, nil);
            return;
        } else {
            weakSelf.responseHandler(NO, error);
        }
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        weakSelf.responseHandler(YES, nil);
    }];

    [self.objectModel performBlock:^{
        TimeEntry *entry = (TimeEntry *) [weakSelf.objectModel.managedObjectContext objectWithID:self.entryID];
        if (entry.remoteId) {
            NSString *path = [NSString stringWithFormat:kDeleteTaskPathBase, weakSelf.objectModel.loggedInUserId, entry.remoteId];
            [self deleteToPath:path];
        } else {
            self.responseHandler(YES, nil);
        }
    }];
}

@end
