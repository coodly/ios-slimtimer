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

@class GDataXMLElement;
@class TaskObject;

@interface TimeEntryObject : NSObject

@property (nonatomic, strong, readonly) NSNumber *remoteId;
@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, strong, readonly) NSDate *endTime;
@property (nonatomic, assign, readonly) BOOL inProgress;
@property (nonatomic, strong, readonly) TaskObject *task;
@property (nonatomic, copy, readonly) NSString *comment;
@property (nonatomic, strong, readonly) NSArray *tags;
@property (nonatomic, strong, readonly) NSDate *updatedAt;

+ (TimeEntryObject *)loadFromElement:(GDataXMLElement *)element;

@end
