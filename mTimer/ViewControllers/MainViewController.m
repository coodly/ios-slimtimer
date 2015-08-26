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

#import "MainViewController.h"
#import "ObjectModel.h"
#import "ObjectModel+Credentials.h"
#import "LoginViewController.h"
#import "TasksListViewController.h"
#import "HistoryViewController.h"
#import "Constants.h"
#import "ObjectModel+Purchases.h"
#import "CDYAdLoader.h"

@interface MainViewController ()

@property (nonatomic, strong) TasksListViewController *tasksListViewController;
@property (nonatomic, strong) HistoryViewController *historyViewController;
@property (nonatomic, strong) UITabBarController *presentedTabController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TasksListViewController *tasksController = [[TasksListViewController alloc] init];
    [self setTasksListViewController:tasksController];
    [tasksController setObjectModel:self.objectModel];
    UINavigationController *tasksNavigationController = [[UINavigationController alloc] initWithRootViewController:tasksController];

    HistoryViewController *historyController = [[HistoryViewController alloc] init];
    [historyController setObjectModel:self.objectModel];
    [self setHistoryViewController:historyController];
    UINavigationController *historyNavigationController = [[UINavigationController alloc] initWithRootViewController:historyController];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [self setPresentedTabController:tabBarController];
    [self addChildViewController:tabBarController];

    [tabBarController setViewControllers:@[tasksNavigationController, historyNavigationController]];

    [tabBarController.view setFrame:self.view.bounds];
    [self.view addSubview:tabBarController.view];

    [[CDYAdLoader sharedInstance] setMainView:self.view];
    [[CDYAdLoader sharedInstance] setContentView:tabBarController.view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAdPresentation) name:kTimerCheckShowAddStatus object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![self.objectModel loggedIn]) {
        [self presentLoginViewController];
    }
}

- (void)presentLoginViewController {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setObjectModel:self.objectModel];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)checkAdPresentation {
    dispatch_async(dispatch_get_main_queue(), ^{
        TimerLog(@"checkAdPresentation - disabled %d", [self.objectModel adsHaveBeenDisabled]);
        [[CDYAdLoader sharedInstance] setLoadingAdsDisabled:[self.objectModel adsHaveBeenDisabled]];
    });
}

@end
