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

#import <Lockbox/Lockbox.h>
#import <RMStore/RMStore.h>
#import <RMStore/RMStoreKeychainPersistence.h>
#import "ObjectModel+Purchases.h"
#import "Task.h"
#import "ObjectModel+Tasks.h"
#import "Constants.h"

NSString *const kLockboxUnlockedTask = @"kLockboxUnlockedTask";

@implementation ObjectModel (Purchases)

- (BOOL)adsHaveBeenDisabled {
#if DISABLE_PURCHASES
    return YES;
#endif
    return [((RMStoreKeychainPersistence *) [RMStore defaultStore].transactionPersistor) isPurchasedProductOfIdentifier:kProductIdentifierRemoveAds];
}

- (BOOL)hasPurchasedFullHistory {
#if DISABLE_PURCHASES
    return YES;
#endif
    return [((RMStoreKeychainPersistence *) [RMStore defaultStore].transactionPersistor) isPurchasedProductOfIdentifier:kProductIdentifierFullHistory];
}

- (NSInteger)unlockedTaskId {
    return [[Lockbox stringForKey:kLockboxUnlockedTask] integerValue];
}

- (void)setUnlockedTaskId:(NSInteger)taskId {
    [Lockbox setString:[NSString stringWithFormat:@"%ld", (long)taskId] forKey:kLockboxUnlockedTask];
}

- (void)checkUnlockedTask {
    TimerLog(@"checkUnlockedTask");
    NSInteger unlockedId = self.unlockedTaskId;
    if (unlockedId == 0) {
        TimerLog(@"Nothing unlocked");
        return;
    }

    Task *task = [self taskWithRemoteId:@(unlockedId)];
    if (task) {
        TimerLog(@"Unlocked exists");
        return;
    }

    TimerLog(@"Reset unlocked");
    [self setUnlockedTaskId:0];
}


@end
