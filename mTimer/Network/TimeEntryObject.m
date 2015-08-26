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

#import "TimeEntryObject.h"
#import "TaskObject.h"
#import "GDataXMLElement+Extension.h"
#import "NSDate+Formatting.h"
#import "GDataXMLNode+Helpers.h"
#import "TagObject.h"

@interface TimeEntryObject ()

@property (nonatomic, strong) NSNumber *remoteId;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, assign) BOOL inProgress;
@property (nonatomic, strong) TaskObject *task;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSDate *updatedAt;

@end

@implementation TimeEntryObject

+ (TimeEntryObject *)loadFromElement:(GDataXMLElement *)element {
    TimeEntryObject *result = [[TimeEntryObject alloc] init];
    [result setRemoteId:@([[element firstValueForField:@"id"] integerValue])];
    [result setStartTime:[NSDate dateFromSlimtimerTime:[element firstValueForField:@"start-time"]]];
    [result setEndTime:[NSDate dateFromSlimtimerTime:[element firstValueForField:@"end-time"]]];
    [result setInProgress:[[element firstValueForField:@"in-progress"] boolValue]];
    GDataXMLElement *dataXMLElement = [element firstElementFromXPath:@"task"];
    [result setTask:[TaskObject loadFromElement:dataXMLElement]];
    NSString *tagsString = [element firstValueForField:@"tags"];
    [result setTags:[TagObject tagsFromString:tagsString]];
    [result setComment:[element firstValueForField:@"comments"]];
    [result setUpdatedAt:[NSDate dateFromSlimtimerTime:[element firstValueForField:@"updated-at"]]];

    return result;
}

@end
