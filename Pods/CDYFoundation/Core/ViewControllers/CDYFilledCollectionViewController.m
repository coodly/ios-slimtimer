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


#import "CDYFilledCollectionViewController.h"

NSString *const CDYFilledCollectionViewControllerCellIdentifier = @"CDYFilledCollectionViewControllerCellIdentifier";

@interface CDYFilledCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CDYFilledCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPresentationCellNib:(UINib *)nib {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:CDYFilledCollectionViewControllerCellIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CDYFilledCollectionViewControllerCellIdentifier forIndexPath:indexPath];
    id object = [self objectAtIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath withObject:object];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    id selected = [self objectAtIndexPath:indexPath];
    [self didSelectedObject:selected atIndexPath:indexPath];
}

- (NSInteger)numberOfSections {
    return 0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {

}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath {

}

@end
