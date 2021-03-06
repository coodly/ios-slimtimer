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

#import <Foundation/Foundation.h>

#if DEBUG
    #define TimerLog(s, ...) NSLog( @"<%@:%@ (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define TimerLog(s, ...) //
    #define JCSAssert(expression, ...) //
#endif

extern NSString *const kTimerErrorDomain;
extern NSString *const kTimerLoggedInNotification;
extern NSString *const kTimerLoggedOutNotification;
extern NSString *const kTimerCheckShowAddStatus;
extern NSString *const kTimerCheckFullHistoryStatus;
extern NSString *const kProductIdentifierRemoveAds;
extern NSString *const kProductIdentifierFullHistory;
static NSTimeInterval const TimerAdCheckTimeSeconds = 60;

#define kAppStoreId 793812713

#define DISABLE_PURCHASES 0
#define SHOW_ADS 1
