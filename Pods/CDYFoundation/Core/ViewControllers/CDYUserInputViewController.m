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

#import "CDYUserInputViewController.h"
#import "CDYUserInputSection.h"

@interface CDYUserInputViewController ()

@property (nonatomic, strong) NSMutableArray *presentedSections;

@end

@implementation CDYUserInputViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presentedSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CDYUserInputSection *inputSection = self.presentedSections[section];
    return [inputSection numberOfCells];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDYUserInputSection *inputSection = self.presentedSections[indexPath.section];
    return [inputSection cellAtRow:indexPath.row];
}

- (void)addSectionForPresentation:(CDYUserInputSection *)section {
    if (!self.presentedSections) {
        [self setPresentedSections:[NSMutableArray array]];
    }

    [self.presentedSections addObject:section];
}

- (void)tappedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CDYUserInputSection *inputSection = self.presentedSections[indexPath.section];
    UITableViewCell *cell = [inputSection cellAtRow:indexPath.row];
    [self tappedCell:cell atIndexPath:indexPath];
}

@end
