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

#import "CDYArrayCollectionViewController.h"

@interface CDYArrayCollectionViewController ()

@property (nonatomic, strong) NSArray *elements;

@end

@implementation CDYArrayCollectionViewController

- (void)presentElements:(NSArray *)elements {
    [self setElements:elements];

    [self.collectionView reloadData];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *altered = [NSMutableArray arrayWithArray:self.elements];
    NSMutableArray *subAltered = [NSMutableArray arrayWithArray:altered[indexPath.section]];
    [subAltered removeObjectAtIndex:indexPath.row];
    altered[indexPath.section] = subAltered;
    [self setElements:altered];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
    }];
}

- (NSInteger)numberOfSections {
    return self.elements.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionElements = self.elements[section];
    return sectionElements.count;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionElements = self.elements[indexPath.section];
    return sectionElements[indexPath.row];
}

@end
