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

#import "CDYFetchedCollectionViewController.h"
#import "CDYCoreDataChangeAction.h"

@interface CDYFetchedCollectionViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *elements;
@property (nonatomic, strong) NSMutableArray *changeActions;

@end

@implementation CDYFetchedCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setChangeActions:[NSMutableArray array]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.elements) {
        [self setElements:[self createFetchedResultsController]];
        [self.elements setDelegate:self];

        [self.collectionView reloadData];;
    }
}


- (NSInteger)numberOfSections {
    return [self.elements sections].count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.elements sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.elements objectAtIndexPath:indexPath];
}

- (NSFetchedResultsController *)createFetchedResultsController {
    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.changeActions setArray:[NSArray array]];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [self.changeActions addObject:[CDYCoreDataChangeAction actionAtIndexPath:indexPath changeType:type newIndexPath:newIndexPath]];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        NSArray *actions = [NSArray arrayWithArray:self.changeActions];
        for (CDYCoreDataChangeAction *action in actions) {
            NSFetchedResultsChangeType type = action.type;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    [self.collectionView insertItemsAtIndexPaths:@[action.nextIndexPath]];
                    break;
                case NSFetchedResultsChangeDelete:
                    [self.collectionView deleteItemsAtIndexPaths:@[action.indexPath]];
                    break;
                case NSFetchedResultsChangeMove:
                    [self.collectionView moveItemAtIndexPath:action.indexPath toIndexPath:action.nextIndexPath];
                    break;
                case NSFetchedResultsChangeUpdate:
                    [self.collectionView reloadItemsAtIndexPaths:@[action.indexPath]];
                    break;
            }
        }
    } completion:^(BOOL finished) {

    }];
}


@end
