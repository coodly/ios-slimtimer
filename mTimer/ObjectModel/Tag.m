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

#import "Tag.h"


@interface Tag ()

@end

@implementation Tag

- (NSString *)name {
    return self.value;
}

+ (NSString *)joinedTags:(NSArray *)tags joinedBy:(NSString *)joinedBy {
    NSMutableArray *tagStrings = [NSMutableArray arrayWithCapacity:[tags count]];
    for (Tag *tag in tags) {
        [tagStrings addObject:tag.value];
    }

    [tagStrings sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *one = obj1;
        NSString *two = obj2;
        return [one localizedCaseInsensitiveCompare:two];
    }];

    return [tagStrings componentsJoinedByString:joinedBy];
}

@end
