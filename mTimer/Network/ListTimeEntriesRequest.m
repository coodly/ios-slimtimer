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

#import "ListTimeEntriesRequest.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+Credentials.h"
#import "NSDate+Formatting.h"
#import "Constants.h"
#import "SlimtimerRequest+Private.h"
#import "NSDate+Calculations.h"
#import "ListTimeEntriesResponse.h"
#import "TimeEntryObject.h"
#import "ObjectModel+TimeEntries.h"

NSInteger const kListEntriesLimit = 5000;
NSString *const kListEntriesPathBase = @"/users/%@/time_entries";

@interface ListTimeEntriesRequest ()

@property (nonatomic, strong) NSMutableSet *knownRemoteIds;

@end

@implementation ListTimeEntriesRequest

- (id)init {
    self = [super initWithResponseSerializer:[ListTimeEntriesResponse serializer]];
    if (self) {

    }
    return self;
}

- (void)execute {
    [self listEntriesWithOffset:0];
}

- (void)listEntriesWithOffset:(NSInteger)offset {
    TimerLog(@"listEntriesWithOffset:%ld", offset);

    NSString *path = [NSString stringWithFormat:kListEntriesPathBase, [self.objectModel loggedInUserId]];

    __weak ListTimeEntriesRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(NO, error);
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        [weakSelf.workerModel performBlock:^{
            ListTimeEntriesResponse *listResponse = (ListTimeEntriesResponse *) response;
            NSArray *entries = [listResponse entries];
            for (TimeEntryObject *entryObject in entries) {
                [weakSelf.workerModel insertOrUpdateTimeEntry:entryObject];
                [weakSelf.knownRemoteIds removeObject:entryObject.remoteId];
            }

            if (entries.count != kListEntriesLimit) {
                [weakSelf.objectModel markEntriesDeletedRemotely:[weakSelf.knownRemoteIds allObjects]];
            }

            [weakSelf.workerModel saveContext:^{
                if (entries.count == kListEntriesLimit) {
                   [weakSelf listEntriesWithOffset:offset + kListEntriesLimit];
                } else {
                    weakSelf.responseHandler(YES, nil);
                }
            }];
        }];
    }];

    if (!self.startDate) {
        [self setStartDate:[self.date startOfDay]];
        [self setEndDate:[[self.date nextDay] startOfDay]];
    }

    NSArray *existingIds = [self.objectModel remoteIdsForEntriesStartedFromDate:self.startDate toDate:self.endDate];
    [self setKnownRemoteIds:[NSMutableSet setWithArray:existingIds]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"range_start"] = [self.startDate slimtimerParamsTimeString];
    params[@"range_end"] = [self.endDate slimtimerParamsTimeString];
    params[@"offset"] = @(offset);

    [self getDataFromPath:path params:params];
}

@end
