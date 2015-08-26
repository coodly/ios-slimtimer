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

#import "TagObject.h"
#import "NSString+JCSValidations.h"

@interface TagObject ()

@property (nonatomic, copy) NSString *value;

@end

@implementation TagObject

- (id)initWithString:(NSString *)tagString {
    self = [super init];
    if (self) {
        [self setValue:tagString];
    }

    return self;
}

+ (NSArray *)tagsFromString:(NSString *)tagsString {
    if (![tagsString hasValue]) {
        return @[];
    }

    NSArray *components = [tagsString componentsSeparatedByString:@","];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[components count]];
    for (NSString *tagString in components) {
        if (![tagString hasValue]) {
            continue;
        }

        [result addObject:[TagObject tagWithString:tagString]];
    }
    return [NSArray arrayWithArray:result];
}

+ (TagObject *)tagWithString:(NSString *)tagString {
    return [[TagObject alloc] initWithString:tagString];
}

@end
