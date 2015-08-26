/*
 * Copyright 2015 Coodly OÜ
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

#import "CDYCoreDataChangeAction.h"

@interface CDYCoreDataChangeAction ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSFetchedResultsChangeType type;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;

@end

@implementation CDYCoreDataChangeAction

+ (CDYCoreDataChangeAction *)actionAtIndexPath:(NSIndexPath *)indexPath changeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)nextIndexPath {
    CDYCoreDataChangeAction *action = [[CDYCoreDataChangeAction alloc] init];
    [action setIndexPath:indexPath];
    [action setType:type];
    [action setNextIndexPath:nextIndexPath];
    return action;
}

@end
