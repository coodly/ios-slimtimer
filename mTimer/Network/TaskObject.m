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

#import "TaskObject.h"
#import "GDataXMLElement+Extension.h"
#import "TagObject.h"
#import "NSString+JCSValidations.h"
#import "NSDate+Formatting.h"

@interface TaskObject ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *remoteId;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSDate *completedOn;

@end

@implementation TaskObject

+ (TaskObject *)loadFromElement:(GDataXMLElement *)element {
    TaskObject *result = [[TaskObject alloc] init];

    NSString *name = [element firstValueForField:@"name"];
    [result setName:name];

    NSInteger remoteId = [[element firstValueForField:@"id"] integerValue];
    [result setRemoteId:@(remoteId)];

    NSString *tagsString = [element firstValueForField:@"tags"];
    [result setTags:[TagObject tagsFromString:tagsString]];

    NSString *completedOnString = [element firstValueForField:@"completed-on"];
    if ([completedOnString hasValue]) {
        [result setCompletedOn:[NSDate dateFromSlimtimerTime:completedOnString]];
    }

    return result;
}

@end
