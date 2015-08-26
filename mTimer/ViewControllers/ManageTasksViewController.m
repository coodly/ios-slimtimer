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

#import "ManageTasksViewController.h"
#import "ManageTaskCell.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+Tasks.h"
#import "Task.h"
#import "UIColor+Theme.h"
#import "EditTaskViewController.h"
#import "ListTasksRequest.h"
#import "TimerAlertView.h"
#import "UIView+CDYLoadHelper.h"

@interface ManageTasksViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ManageTaskCell *measureCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ListTasksRequest *executedRequest;

@end

@implementation ManageTasksViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setFetchedEntityCellNib:[ManageTaskCell viewNib]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"manage.tasks.controller.title", nil)];

    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"manage.tasks.controller.done.button.title", nil) style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed)]];

    [self setMeasureCell:[ManageTaskCell loadInstance]];

    [self.tableView setEstimatedRowHeight:44];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self setRefreshControl:refreshControl];
    [refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)createFetchedController {
    return [self.objectModel fetchedControllerForAllTasks];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    ManageTaskCell *taskCell = (ManageTaskCell *) cell;
    Task *task = object;
    [taskCell.taskNameLabel setText:task.name];

    if (task.completeValue) {
        [taskCell.contentView setBackgroundColor:[UIColor completeTaskBackgroundColor]];
    } else {
        [taskCell.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.allObjects objectAtIndexPath:indexPath];
    [self configureCell:self.measureCell atIndexPath:indexPath withObject:task];
    [self.measureCell adjustHeight];
    return CGRectGetHeight(self.measureCell.frame);
}

- (void)donePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPressed {
    Task *task = [self.objectModel createTemporaryTask];
    [self presentEditWithTask:task controllerTitle:NSLocalizedString(@"edit.task.controller.add.title", nil)];
}

- (void)presentEditWithTask:(Task *)task controllerTitle:(NSString *)title {
    EditTaskViewController *controller = [[EditTaskViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setTask:task];
    [controller setTitle:title];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tappedOnObject:(id)tapped {
    [self presentEditWithTask:tapped controllerTitle:NSLocalizedString(@"edit.task.controller.edit.title", nil)];
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)pullRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.executedRequest) {
            return;
        }

        ListTasksRequest *request = [[ListTasksRequest alloc] init];
        [self setExecutedRequest:request];
        [request setObjectModel:self.objectModel];
        [request setResponseHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setExecutedRequest:nil];

                [self.refreshControl endRefreshing];

                if (error) {
                    TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"manage.tasks.pull.error.title", nil) error:error];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"manage.tasks.pull.error.dismiss.button", nil)];
                    [alertView show];
                    return;
                }
            });
        }];
        [request execute];
    });

}

@end
