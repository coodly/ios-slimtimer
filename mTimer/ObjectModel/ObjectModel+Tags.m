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

#import "ObjectModel+Tags.h"
#import "TagObject.h"
#import "ObjectModel+Users.h"
#import "Tag.h"
#import "Constants.h"

@implementation ObjectModel (Tags)

- (NSArray *)existingTagsWithValues:(NSArray *)values {
    NSPredicate *valuePredicate = [NSPredicate predicateWithFormat:@"value IN %@", values];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[valuePredicate, userPredicate]];
    return [self fetchEntitiesNamed:[Tag entityName] withPredicate:predicate];
}

- (NSSet *)insertOrUpdateTags:(NSArray *)tagObjects {
    if ([tagObjects count] == 0) {
        return [NSSet set];
    }

    NSMutableArray *tagStrings = [NSMutableArray arrayWithCapacity:[tagObjects count]];
    for (TagObject *tagObject in tagObjects) {
        [tagStrings addObject:tagObject.value];
    }

    TimerLog(@"Tags in %lu - %@", [tagObjects count], tagObjects);
    NSArray *existingTags = [self existingTagsWithValues:tagStrings];
    TimerLog(@"%lu already exist", [existingTags count]);
    if ([existingTags count] == [tagObjects count]) {
        return [NSSet setWithArray:existingTags];
    }

    [tagStrings filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *checked = evaluatedObject;
        for (Tag *tag in existingTags) {
            if ([checked isEqualToString:tag.value]) {
                return NO;
            }
        }

        return YES;
    }]];

    NSMutableArray *result = [NSMutableArray arrayWithArray:existingTags];
    User *user = [self loggedInUser];

    TimerLog(@"Missing %lu tags: %@", [tagStrings count], tagStrings);
    for (NSString *tagString in tagStrings) {
        Tag *tag = [Tag insertInManagedObjectContext:self.managedObjectContext];
        [tag setValue:tagString];
        [tag setUser:user];
        [result addObject:tag];
    }

    return [NSSet setWithArray:result];
}

- (NSFetchedResultsController *)fetchedControllerForAllUserTags {
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSSortDescriptor *valueSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    return [self fetchedControllerForEntity:[Tag entityName] predicate:userPredicate sortDescriptors:@[valueSortDescriptor]];
}

- (BOOL)hasTagNamed:(NSString *)input {
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *tagValuePredicate = [NSPredicate predicateWithFormat:@"value LIKE [cd] %@", input];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[tagValuePredicate, userPredicate]];
    return [self countInstancesOfEntity:[Tag entityName] withPredicate:predicate] != 0;
}

- (Tag *)addTagWithValue:(NSString *)value {
    Tag *tag = [Tag insertInManagedObjectContext:self.managedObjectContext];
    [tag setValue:value];
    [tag setUser:[self loggedInUser]];
    return tag;
}

@end
