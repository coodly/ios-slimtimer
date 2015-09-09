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

#import <CDYFoundation/UIView+CDYLoadHelper.h>
#import "EditEntryViewController.h"
#import "EditTaskTaskCell.h"
#import "TimeEntry.h"
#import "Task.h"
#import "TaskSelectionViewController.h"
#import "EditTaskTimeCell.h"
#import "UITableViewCell+JCSPositioning.h"
#import "EditTaskTimePickerCell.h"
#import "EditEntryTagsCell.h"
#import "EditTaskCommentCell.h"
#import "JCSQuickActionSheet.h"
#import "ObjectModel+TimeEntries.h"
#import "TagsViewController.h"
#import "ObjectModel+TimeReports.h"

NSUInteger const kTaskNameSection = 0;
NSUInteger const kTaskTimeSection = 1;
NSUInteger const kTaskTagsSection = 2;
NSUInteger const kTaskCommentSection = 3;
NSUInteger const kRowStartTime = 0;
NSUInteger const kRowEndTime = 1;

CGFloat const kGroupedTableSectionSeparatorHeight = 20;
CGFloat const kGroupedTableHeadingHeight = 35;
CGFloat const kGroupedTableFooterSeparatorHeight = 10;

CGFloat const kMinCommentCellHeight = 90;

NSString *const kEditTaskTaskNameCellIdentifier = @"kEditTaskTaskNameCellIdentifier";
NSString *const kEditTaskTimeCellIdentifier = @"kEditTaskTimeCellIdentifier";
NSString *const kEditTaskTimePickerCellIdentifier = @"kEditTaskTimePickerCellIdentifier";
NSString *const kEditEntryTagsCellIdentifier = @"kEditEntryTagsCellIdentifier";
NSString *const kEditTaskCommentCellIdentifier = @"kEditTaskCommentCellIdentifier";

@interface EditEntryViewController ()

@property (nonatomic, strong) EditTaskTaskCell *taskCell;
@property (nonatomic, strong) EditTaskTimeCell *startTimeCell;
@property (nonatomic, strong) EditTaskTimeCell *endTimeCell;
@property (nonatomic, strong) EditTaskTimePickerCell *startTimePickerCell;
@property (nonatomic, strong) EditTaskTimePickerCell *endTimePickerCell;
@property (nonatomic, strong) EditEntryTagsCell *tagsCell;
@property (nonatomic, strong) EditTaskCommentCell *commentCell;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, assign) BOOL ignoreHide;
@property (nonatomic, assign) BOOL taskEntryChanged;

@end

@implementation EditEntryViewController

- (id)init {
    self = [super initWithNibName:@"EditEntryViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[EditTaskTaskCell viewNib] forCellReuseIdentifier:kEditTaskTaskNameCellIdentifier];
    [self.tableView registerNib:[EditTaskTimeCell viewNib] forCellReuseIdentifier:kEditTaskTimeCellIdentifier];
    [self.tableView registerNib:[EditTaskTimePickerCell viewNib] forCellReuseIdentifier:kEditTaskTimePickerCellIdentifier];
    [self.tableView registerNib:[EditEntryTagsCell viewNib] forCellReuseIdentifier:kEditEntryTagsCellIdentifier];
    [self.tableView registerNib:[EditTaskCommentCell viewNib] forCellReuseIdentifier:kEditTaskCommentCellIdentifier];

    [self setTaskCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskTaskNameCellIdentifier]];
    [self addCellForPresentation:self.taskCell];
    [self closeSection];

    [self setStartTimeCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskTimeCellIdentifier]];
    [self.startTimeCell.titleLabel setText:NSLocalizedString(@"edit.entry.start.time.label", nil)];
    [UITableViewCell adjustWidthForTitle:self.startTimeCell.titleLabel value:self.startTimeCell.timeLabel];
    [self addCellForPresentation:self.startTimeCell];
    [self setEndTimeCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskTimeCellIdentifier]];
    [self.endTimeCell.titleLabel setText:NSLocalizedString(@"edit.entry.end.time.label", nil)];
    [UITableViewCell adjustWidthForTitle:self.endTimeCell.titleLabel value:self.endTimeCell.timeLabel];
    [self addCellForPresentation:self.endTimeCell];

    [self setStartTimePickerCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskTimePickerCellIdentifier]];
    [self addInlinePickerCell:self.startTimePickerCell forIndexPath:[NSIndexPath indexPathForRow:kRowStartTime inSection:kTaskTimeSection]];
    __weak EditEntryViewController *weakSelf = self;
    [self.startTimePickerCell setWillPresentHandler:^{
        [weakSelf.startTimePickerCell setDate:weakSelf.timeEntry.startTime];
        [weakSelf.startTimePickerCell.datePicker setMaximumDate:[weakSelf.timeEntry possibleEndTime]];
    }];
    [self.startTimePickerCell setValueChangeHandler:^(NSDate *date) {
        [weakSelf setTaskEntryChanged:YES];
        [weakSelf updateEntryStartTime:date];
    }];

    [self setEndTimePickerCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskTimePickerCellIdentifier]];
    [self addInlinePickerCell:self.endTimePickerCell forIndexPath:[NSIndexPath indexPathForRow:kRowEndTime inSection:kTaskTimeSection]];
    [self.endTimePickerCell setWillPresentHandler:^{
        NSDate *presented = [weakSelf.timeEntry possibleEndTime];
        [weakSelf.endTimePickerCell setDate:presented];
        [weakSelf.endTimePickerCell.datePicker setMinimumDate:weakSelf.timeEntry.startTime];
    }];
    [self.endTimePickerCell setValueChangeHandler:^(NSDate *date) {
        [weakSelf setTaskEntryChanged:YES];
        [weakSelf updateEntryEndTime:date];
    }];

    [self closeSection];

    [self setTagsCell:[self.tableView dequeueReusableCellWithIdentifier:kEditEntryTagsCellIdentifier]];
    [self addCellForPresentation:self.tagsCell];

    [self closeSection];

    [self setCommentCell:[self.tableView dequeueReusableCellWithIdentifier:kEditTaskCommentCellIdentifier]];
    [self addCellForPresentation:self.commentCell];

    [self.tableView setTableFooterView:self.toolbar];

    [self.navigationItem setTitle:NSLocalizedString(@"edit.entry.controller.title", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.shown) {
        return;
    }

    [self setShown:YES];

    [self updatePresentedTaskName];
    [self updateEntryTimePresentations];
    [self updatePresentedTags];
    [self updateToolbarButtons];
    [self.commentCell setValue:self.timeEntry.comment];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.ignoreHide) {
        [self setIgnoreHide:NO];
        return;
    }

    [self setTaskEntryChanged:self.taskEntryChanged || ![self.timeEntry.comment isEqualToString:self.commentCell.value]];

    if (!self.taskEntryChanged) {
        return;
    }

    [self.timeEntry setComment:self.commentCell.value];
    [self.timeEntry markUpdated];
    [self.timeEntry markSyncRequired];
    [self.objectModel saveContext];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kTaskNameSection) {
        TaskSelectionViewController *controller = [[TaskSelectionViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        Task *previousTask = self.timeEntry.task;
        [controller setSelected:previousTask];
        [controller setSelectionCompletionBlock:^(id <JCSSelectable> selected) {
            if ([previousTask isEqual:selected]) {
                return;
            }

            Task *selectedTask = (Task *) selected;

            [self setTaskEntryChanged:YES];
            [self.objectModel mapEntry:self.timeEntry withTask:selectedTask];
            [self.objectModel saveContext:^{
                [self updatePresentedTaskName];
                [self updatePresentedTags];
                [self.tableView reloadData];
            }];
        }];
        [self pushViewController:controller];
    } else if (indexPath.section == kTaskTagsSection) {
        TagsViewController *controller = [[TagsViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setSelectedObjects:[[self.timeEntry tags] allObjects]];
        [controller setSelectionCompletionBlock:^(NSArray *selected) {
            NSSet *tagsSelected = [NSSet setWithArray:selected];
            if ([self.timeEntry.tags isEqualToSet:tagsSelected]) {
                return;
            }

            [self setTaskEntryChanged:YES];
            [self.timeEntry setTags:tagsSelected];
            [self updatePresentedTags];
            [self.tableView reloadData];
            [self.objectModel saveContext];
        }];
        [self pushViewController:controller];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != kTaskCommentSection) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }

    CGFloat availableHeight = CGRectGetHeight(self.tableView.frame);
    availableHeight -= self.tableView.contentInset.top;
    availableHeight -= CGRectGetHeight(self.taskCell.frame);
    availableHeight -= CGRectGetHeight(self.startTimeCell.frame);
    availableHeight -= CGRectGetHeight(self.endTimeCell.frame);
    availableHeight -= CGRectGetHeight(self.tagsCell.frame);
    availableHeight -= CGRectGetHeight(self.toolbar.frame);
    availableHeight -= 3 * kGroupedTableSectionSeparatorHeight;
    availableHeight -= kGroupedTableHeadingHeight;
    availableHeight -= kGroupedTableFooterSeparatorHeight;

    return MAX(availableHeight, kMinCommentCellHeight);
}

- (void)updateEntryStartTime:(NSDate *)date {
    [self.timeEntry setStartTime:date];
    [self.timeEntry.task markUpdated];
    [self.objectModel saveContext];
    [self updateEntryTimePresentations];
}

- (void)updateEntryEndTime:(NSDate *)date {
    BOOL shouldCreateTimeReport = self.timeEntry.endTime == nil;
    [self.timeEntry setEndTime:date];
    [self.timeEntry.task markUpdated];
    if (shouldCreateTimeReport) {
        [self.objectModel createTimeReportWithSeconds:[self.timeEntry durationInSeconds]];
    }
    [self.objectModel saveContext];
    [self updateEntryTimePresentations];
    [self updateToolbarButtons];
}

- (void)updateEntryTimePresentations {
    [self.startTimeCell.timeLabel setText:[self.timeEntry formattedStartTime]];
    [self.endTimeCell.timeLabel setText:[self.timeEntry formattedEndTime]];
}

- (void)markCompletePressed {
    [self setTaskEntryChanged:YES];
    [self.objectModel markEntryComplete:self.timeEntry pushChange:NO];
    [self updateEntryTimePresentations];
    [self updateToolbarButtons];
}

- (void)updateToolbarButtons {
    NSMutableArray *items = [NSMutableArray array];
    if (!self.timeEntry.endTime) {
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1040-checkmark"] style:UIBarButtonItemStyleBordered target:self action:@selector(markCompletePressed)]];
    }

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"711-trash"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteEntryPressed)]];

    [self.toolbar setItems:items animated:YES];
}

- (void)deleteEntryPressed {
    JCSQuickActionSheet *actionSheet = [JCSQuickActionSheet actionSheetWithMessage:NSLocalizedString(@"delete.task.entry.confirmation.message", nil)];
    [actionSheet addDestructiveButtonWithTitle:NSLocalizedString(@"delete.task.confirmation.delete.button", nil) action:^{
        [self setTaskEntryChanged:YES];
        [self.objectModel markEntryForDeletion:self.timeEntry];
        [self.objectModel saveContext:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [actionSheet addCancelButtonWithTitle:NSLocalizedString(@"delete.task.confirmation.cancel.button", nil) action:^{

    }];
    [actionSheet showInView:self.view];
}

- (void)updatePresentedTags {
    [self.tagsCell setTitle:NSLocalizedString(@"edit.entry.tags.title", nil) tags:self.timeEntry.joinedTags];
}

- (void)updatePresentedTaskName {
    [self.taskCell.textLabel setText:self.timeEntry.task.name];
}

- (void)pushViewController:(UIViewController *)controller {
    [self setIgnoreHide:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
