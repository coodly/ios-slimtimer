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

#import "ObjectModel+Users.h"
#import "User.h"
#import "ObjectModel+Credentials.h"

@implementation ObjectModel (Users)

- (User *)userWithId:(NSNumber *)userId {
    NSPredicate *userIdPredicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    return [self fetchEntityNamed:[User entityName] withPredicate:userIdPredicate];
}

- (User *)loggedInUser {
    NSNumber *userId = [self loggedInUserId];
    return [self userWithId:userId];
}

- (void)ensureUserWithIdExists:(NSNumber *)userId {
    User *user = [self userWithId:userId];
    if (!user) {
        user = [User insertInManagedObjectContext:self.managedObjectContext];
        [user setUserId:userId];
    }
}

- (void)deleteLoggedInUser {
    User *user = [self loggedInUser];
    [self deleteObject:user saveAfter:NO];
}

@end
