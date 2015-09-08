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

#import <JCSFoundation/UIView+JCSLoadView.h>
#import <JCSFoundation/NSString+JCSValidations.h>
#import "DayEntriesViewController.h"
#import "Constants.h"
#import "ListTimeEntriesRequest.h"
#import "ObjectModel+TimeEntries.h"
#import "TimeEntryCell.h"
#import "TimeEntry.h"
#import "Task.h"
#import "TimerTabActivityView.h"
#import "EditEntryViewController.h"
#import "ObjectModel+Dates.h"
#import "TimerAlertView.h"

@interface DayEntriesViewController ()

@property (nonatomic, strong) NSDate *presentedDate;
@property (nonatomic, strong) SlimtimerRequest *executedRequest;
@property (nonatomic, strong) TimeEntryCell *measureCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation DayEntriesViewController

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self setPresentedDate:date];
        [self setFetchedEntityCellNib:[TimeEntryCell viewNib]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setMeasureCell:[TimeEntryCell loadInstance]];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![self.objectModel hasMarkerForDate:self.presentedDate]) {
        [self refreshTimeEntries];
    }
}

- (NSFetchedResultsController *)createFetchedController {
    JCSAssert(self.objectModel);
    return [self.objectModel fetchedControllerForEntriesOnDate:self.presentedDate];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TimeEntryCell *entryCell = (TimeEntryCell *) cell;
    TimeEntry *entry = object;
    [entryCell.taskNameLabel setText:[entry.task name]];
    [entryCell.tagsLabel setText:[entry joinedTags]];
    [entryCell.timesLabel setText:[entry formattedStartEndTime]];
    [self setFormattedTime:[entry formattedRunTime] intoLabel:entryCell.runTimeLabel];
    [entryCell.commentLabel setText:[entry comment]];

    [entryCell adjustHeight];
}

- (void)setFormattedTime:(NSString *)formattedTime intoLabel:(UILabel *)label {
    if (![formattedTime hasValue]) {
        [label setAttributedText:[[NSAttributedString alloc] initWithString:@""]];
        return;
    }

    if (!label || !label.font) {
        TimerLog(@"How can this happen? %@ - %@", label, label.font);
        return;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formattedTime];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentLeft];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName: style} range:NSMakeRange(0, [formattedTime length])];
    [attributedString setAttributes:@{NSFontAttributeName: label.font} range:NSMakeRange(0, [formattedTime length])];
    [attributedString setAttributes:@{NSFontAttributeName: [label.font fontWithSize:label.font.pointSize * .75]} range:NSMakeRange([formattedTime length] - 3, 3)];
    [label setAttributedText:attributedString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.measureCell atIndexPath:indexPath withObject:[self.allObjects objectAtIndexPath:indexPath]];

    return CGRectGetHeight(self.measureCell.frame);
}

- (void)tappedOnObject:(id)tapped {
    EditEntryViewController *controller = [[EditEntryViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setTimeEntry:tapped];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pullRefresh {
    [self refreshTimeEntries:NO];
}

- (void)refreshTimeEntries {
    [self refreshTimeEntries:YES];
}

- (void)refreshTimeEntries:(BOOL)showHud {
    TimerTabActivityView *hud;
    if (showHud) {
        hud = [TimerTabActivityView activityViewWithMessage:NSLocalizedString(@"day.entries.loading.entries", nil)];
        [hud positionOnView:self.view];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        TimerLog(@"refreshTimeEntries");
        ListTimeEntriesRequest *request = [[ListTimeEntriesRequest alloc] init];
        [self setExecutedRequest:request];
        [request setDate:self.presentedDate];
        [request setObjectModel:self.objectModel];
        [request setResponseHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                [self.refreshControl endRefreshing];
                if (!error) {
                    [self.objectModel addMarkerForDate:self.presentedDate];
                }
            });
        }];
        [request execute];
    });
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)checkFullHistoryStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
