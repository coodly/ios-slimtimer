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

#import "ObjectModel+Tasks.h"
#import "TaskObject.h"
#import "Task.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+Tags.h"
#import "Constants.h"
#import "ObjectModel+Settings.h"

@implementation ObjectModel (Tasks)

- (Task *)taskWithRemoteId:(NSNumber *)remoteId {
    NSPredicate *taskIdPredicate = [NSPredicate predicateWithFormat:@"taskId = %@", remoteId];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[taskIdPredicate, userPredicate]];
    return [self fetchEntityNamed:[Task entityName] withPredicate:predicate];
}

- (Task *)insertOrUpdateTask:(TaskObject *)taskObject {
    Task *task = [self taskWithRemoteId:taskObject.remoteId];
    if (!task) {
        task = [Task insertInManagedObjectContext:self.managedObjectContext];
    }

    [task setTaskId:taskObject.remoteId];
    [task setName:taskObject.name];
    [task setUser:[self loggedInUser]];
    [task setDefaultTags:[self insertOrUpdateTags:taskObject.tags]];
    [task setCompleteValue:taskObject.completedOn != nil];
    [task setHiddenValue:taskObject.completedOn != nil && ![self showCompleteTasks]];
    return task;
}

- (NSFetchedResultsController *)fetchedControllerForActiveUserTasks {
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *notHiddenPredicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSPredicate *notTemporaryPredicate = [NSPredicate predicateWithFormat:@"temporary = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notHiddenPredicate, userPredicate, notTemporaryPredicate]];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    return [self fetchedControllerForEntity:[Task entityName] predicate:predicate sortDescriptors:@[nameSortDescriptor]];
}

- (BOOL)hasNoTasks {
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    return [self countInstancesOfEntity:[Task entityName] withPredicate:userPredicate] == 0;
}

- (void)hideCompleteTasks:(BOOL)hide {
    [self performBlock:^{
        NSArray *complete = [self allCompleteTasks];
        TimerLog(@"Have %lu complete tasks", [complete count]);
        for (Task *task in complete) {
            [task setHiddenValue:hide];
        }

        [self saveContext];
    }];
}

- (NSArray *)allCompleteTasks {
    NSPredicate *completePredicate = [NSPredicate predicateWithFormat:@"complete = YES"];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[completePredicate, userPredicate]];
    return [self fetchEntitiesNamed:[Task entityName] withPredicate:predicate];
}

- (NSFetchedResultsController *)fetchedControllerForAllTasks {
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self loggedInUser]];
    NSPredicate *notTemporaryPredicate = [NSPredicate predicateWithFormat:@"temporary = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate, notTemporaryPredicate]];
    return [self fetchedControllerForEntity:[Task entityName] predicate:predicate sortDescriptors:@[nameSortDescriptor]];
}

- (Task *)createTemporaryTask {
    Task *task = [Task insertInManagedObjectContext:self.managedObjectContext];
    [task setTemporaryValue:YES];
    [task setUser:[self loggedInUser]];
    return task;
}

- (NSArray *)knownTaskIds {
    return [self fetchAttributeNamed:@"taskId" forEntity:[Task entityName]];
}

- (void)deleteTasksWithIds:(NSArray *)idsToDelete {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId IN %@", idsToDelete];
    NSArray *tasksToDelete = [self fetchEntitiesNamed:[Task entityName] withPredicate:predicate];
    TimerLog(@"Will delete %d tasks removed from server", tasksToDelete.count);
    [self deleteObjects:tasksToDelete saveAfter:YES];
}

@end
