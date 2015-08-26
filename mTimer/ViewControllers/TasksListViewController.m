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

#import "TasksListViewController.h"
#import "Constants.h"
#import "ObjectModel.h"
#import "ListTasksRequest.h"
#import "ObjectModel+Credentials.h"
#import "ObjectModel+Tasks.h"
#import "TasksListCell.h"
#import "Task.h"
#import "TimerAlertView.h"
#import "SettingsViewController.h"
#import "TimeEntry.h"
#import "ObjectModel+TimeEntries.h"
#import "EditEntryViewController.h"
#import "TimerTabActivityView.h"
#import "ListTimeEntriesRequest.h"
#import "NSDate+Calculations.h"
#import "ObjectModel+Settings.h"
#import "UIColor+Theme.h"
#import "ManageTasksViewController.h"
#import "UIView+CDYLoadHelper.h"

@interface TasksListViewController ()

@property (nonatomic, strong) SlimtimerRequest *executedRequest;
@property (nonatomic, strong) TasksListCell *measureCell;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation TasksListViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tasks.list.controller.tab.title", nil) image:[UIImage imageNamed:@"1097-timer-2"] selectedImage:[UIImage imageNamed:@"1097-timer-2-selected"]]];
        [self setFetchedEntityCellNib:[TasksListCell viewNib]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"tasks.list.controller.title", nil)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObjects) name:kTimerLoggedOutNotification object:nil];

    [self setMeasureCell:[TasksListCell loadInstance]];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"740-gear-toolbar"] style:UIBarButtonItemStyleDone target:self action:@selector(settingsPressed)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"tasks.list.controller.manage.tasks.button", nil) style:UIBarButtonItemStyleDone target:self action:@selector(presentManageTasks)]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self scrollToFirstRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self.objectModel hasNoTasks]) {
        [self refreshTasksList];
    }
}

- (NSFetchedResultsController *)createFetchedController {
    if (![self.objectModel loggedIn]) {
        return nil;
    }

    return [self.objectModel fetchedControllerForActiveUserTasks];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TasksListCell *tasksListCell = (TasksListCell *) cell;
    Task *task = object;
    [self configureTaskCell:tasksListCell withTask:task statTimer:YES];
}

- (void)configureTaskCell:(TasksListCell *)tasksListCell withTask:(Task *)task statTimer:(BOOL)startTimer {
    [tasksListCell.taskNameLabel setText:task.name];
    [tasksListCell adjustHeight];

    if (!startTimer) {
        return;
    }

    TimeEntry *timeEntry = [self.objectModel runningEntryForTask:task];
    [tasksListCell setBackgroundColor:(timeEntry ? [UIColor runningTaskColor] : (task.completeValue ? [UIColor completeTaskBackgroundColor] : [UIColor clearColor]))];
    [tasksListCell setTimerStartTime:timeEntry.startTime];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [[self allObjects] objectAtIndexPath:indexPath];
    [self configureTaskCell:self.measureCell withTask:task statTimer:NO];
    return CGRectGetHeight(self.measureCell.frame);
}

- (void)tappedOnObject:(id)tapped {
    Task *task = tapped;
    TimerLog(@"Tapped on %@", task.name);
    TimeEntry *running = [self.objectModel runningEntryForTask:task];
    if (running) {
        TimerLog(@"Have running");
        EditEntryViewController *controller = [[EditEntryViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setTimeEntry:running];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        TimerLog(@"Start new");
        [self.objectModel stopRunningEntries];
        [self.objectModel createEntryForTask:task];
        [self.objectModel saveContext];
    }
}

- (void)refreshTasksList {
    TimerLog(@"refreshTasksList");
    if (![self.objectModel loggedIn]) {
        return;
    }

    if (self.executedRequest) {
        return;
    }

    TimerTabActivityView *hud = [TimerTabActivityView activityViewWithMessage:NSLocalizedString(@"tasks.list.controller.refreshing.message", nil)];
    [hud positionOnView:self.view bottomOffset:CGRectGetHeight(self.tabBarController.tabBar.frame)];
    dispatch_async(dispatch_get_main_queue(), ^{
        ListTasksRequest *request = [[ListTasksRequest alloc] init];
        [self setExecutedRequest:request];
        [request setObjectModel:self.objectModel];
        [request setResponseHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setExecutedRequest:nil];

                [hud hide];

                if (error) {
                    TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"tasks.list.pull.error.title", nil) error:error];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"tasks.list.pull.error.dismiss.button", nil)];
                    [alertView show];
                    return;
                }

                [self checkForRunningEntries:YES];
            });
        }];
        [request execute];
    });
}

- (void)settingsPressed {
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)scrollToFirstRunning {
    TimeEntry *running = [self.objectModel anyRunningEntry];
    if (!running) {
        return;
    }

    NSIndexPath *indexPathForRunning = [self.allObjects indexPathForObject:running.task];
    NSArray *visible = [self.tableView indexPathsForVisibleRows];
    if ([visible containsObject:indexPathForRunning]) {
        return;
    }


    [self.tableView scrollToRowAtIndexPath:indexPathForRunning atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)checkForRunningEntries {
    [self checkForRunningEntries:NO];
}

- (void)checkForRunningEntries:(BOOL)force {
    TimerLog(@"checkForRunningEntries");
    if (![self.objectModel loggedIn]) {
        return;
    }

    if (self.executedRequest) {
        return;
    }

    NSDate *lastCheckTime = [self.objectModel lastEntriesCheckTime];
    if (!force && [lastCheckTime lessThanHourAgo]) {
        TimerLog(@"Last check time %@. Ignore.", lastCheckTime);
        return;
    }

    ListTimeEntriesRequest *request = [[ListTimeEntriesRequest alloc] init];
    NSDate *checkTime = [NSDate date];
    [self setExecutedRequest:request];
    [request setObjectModel:self.objectModel];
    [request setStartDate:[checkTime dateByAddingDays:-1]];
    [request setEndDate:checkTime];
    [request setResponseHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setExecutedRequest:nil];

            if (error) {
                TimerLog(@"Check entries error:%@", error);
                return;
            }

            [self.objectModel setLastEntriesCheckTime:checkTime];
            [self.objectModel saveContext];

            [self scrollToFirstRunning];
        });
    }];
    [request execute];
}

- (void)presentManageTasks {
    TimerLog(@"presentManageTasks");
    ManageTasksViewController *controller = [[ManageTasksViewController alloc] init];
    [controller setObjectModel:self.objectModel];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
