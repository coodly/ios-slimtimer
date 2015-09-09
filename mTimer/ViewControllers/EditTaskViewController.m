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

#import "EditTaskViewController.h"
#import "EditTaskNameCell.h"
#import "Task.h"
#import "Tag.h"
#import "EditTaskTagsCell.h"
#import "TagsViewController.h"
#import "ObjectModel+SyncStatuses.h"
#import "UIView+CDYLoadHelper.h"

NSString *const kEditTaskNameCellIdentifier = @"kEditTaskNameCellIdentifier";
NSString *const kEditTaskTagsCellIdentifier = @"kEditTaskTagsCellIdentifier";

NSInteger kSectionName = 0;
NSInteger kSectionTags = 1;

@interface EditTaskViewController ()

@property (nonatomic, strong) EditTaskNameCell *nameCell;
@property (nonatomic, strong) EditTaskTagsCell *tagsCell;
@property (nonatomic, strong) NSString *startName;
@property (nonatomic, strong) NSString *startTags;
@property (nonatomic, assign) BOOL ignoreHide;
@property (nonatomic, assign) BOOL shown;

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:self.title];

    [self.tableView registerNib:[EditTaskNameCell viewNib] forCellReuseIdentifier:kEditTaskNameCellIdentifier];
    [self.tableView registerNib:[EditTaskTagsCell viewNib] forCellReuseIdentifier:kEditTaskTagsCellIdentifier];

    EditTaskNameCell *nameCell = [self.tableView dequeueReusableCellWithIdentifier:kEditTaskNameCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [self addCellForPresentation:nameCell];
    [self closeSection];

    EditTaskTagsCell *tagsCell = [self.tableView dequeueReusableCellWithIdentifier:kEditTaskTagsCellIdentifier];
    [self setTagsCell:tagsCell];
    [self addCellForPresentation:tagsCell];

    [self setStartName:self.task.name];
    [self setStartTags:[Tag joinedTags:[self.task.defaultTags allObjects] joinedBy:@","]];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"edit.task.controller.done.button.title", nil) style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
    if (self.task.temporaryValue) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"edit.task.controller.cancel.button.title", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed)]];
        [self.navigationItem setRightBarButtonItem:doneButton];
    } else {
        [self.navigationItem setLeftBarButtonItem:doneButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.shown) {
        return;
    }

    [self.nameCell.entryField setText:self.task.name];
    [self updateTagsPresentation];
    [self setShown:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.ignoreHide) {
        [self setIgnoreHide:NO];
        return;
    }

    BOOL syncNeeded = NO;

    NSString *taskName = [self.nameCell value];
    if (![taskName isEqualToString:self.startName]) {
        [self.task setName:taskName];
        syncNeeded = YES;
    }

    NSString *endTags = [Tag joinedTags:[self.task.defaultTags allObjects] joinedBy:@","];
    if (![endTags isEqualToString:self.startTags]) {
        syncNeeded = YES;
    }

    if (syncNeeded) {
        [self.task markUpdated];
        [self.task markSyncNeeded];
        [self.objectModel saveContext];
    }
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionTags) {
        TagsViewController *controller = [[TagsViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setSelectedObjects:[[self.task defaultTags] allObjects]];
        [controller setSelectionCompletionBlock:^(NSArray *selected) {
            NSSet *tagsSelected = [NSSet setWithArray:selected];
            if ([self.task.defaultTags isEqualToSet:tagsSelected]) {
                return;
            }

            [self.task setDefaultTags:tagsSelected];
            [self updateTagsPresentation];
            [self.tableView reloadData];
            [self.objectModel saveContext];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)updateTagsPresentation {
    [self.tagsCell.tagsLabel setText:[Tag joinedTags:[self.task.defaultTags allObjects] joinedBy:@", "]];
    [self.tagsCell adjustSize];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kSectionName) {
        return NSLocalizedString(@"edit.task.controller.name.section.title", nil);
    } else if (section == kSectionTags) {
        return NSLocalizedString(@"edit.task.controller.default.tags.section.title", nil);
    }

    return nil;
}

- (void)cancelPressed {
    [self setIgnoreHide:YES];
    if (self.task.temporaryValue) {
        [self.objectModel deleteObject:self.task];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePressed {
    [self.task setTemporaryValue:NO];
    [self.objectModel saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
