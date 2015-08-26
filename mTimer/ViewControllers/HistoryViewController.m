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

#import "HistoryViewController.h"
#import "DayEntriesViewController.h"
#import "NSDate+Calculations.h"

NSInteger const kAllowedTapWidth = 44;

@interface HistoryViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBarButtonItem *showTodayButton;

@end

@implementation HistoryViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"history.controller.tab.title", nil) image:[UIImage imageNamed:@"851-calendar"] selectedImage:[UIImage imageNamed:@"851-calendar-selected"]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDelegate:self];
    [self setDataSource:self];

    [self setShowTodayButton:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"history.controller.today.button", nil) style:UIBarButtonItemStyleDone target:self action:@selector(todayPressed)]];

    [self setViewControllers:@[[self createControllerOnDate:[NSDate date]]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateTitle];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    DayEntriesViewController *controller = (DayEntriesViewController *) viewController;
    return [self createControllerOnDate:[controller.presentedDate previousDay]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    DayEntriesViewController *controller = (DayEntriesViewController *) viewController;
    return [self createControllerOnDate:[controller.presentedDate nextDay]];
}

- (DayEntriesViewController *)createControllerOnDate:(NSDate *)date {
    DayEntriesViewController *controller = [[DayEntriesViewController alloc] initWithDate:date];
    [controller setObjectModel:self.objectModel];
    return controller;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self updateTitle];
}

- (void)updateTitle {
    DayEntriesViewController *presented = [self.viewControllers firstObject];
    NSString *title = [[HistoryViewController presentedDateFormatter] stringFromDate:presented.presentedDate];
    [self.navigationItem setTitle:title];

    if ([presented.presentedDate isToday]) {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    } else {
        [self.navigationItem setLeftBarButtonItem:self.showTodayButton animated:YES];
    }
}

- (void)todayPressed {
    DayEntriesViewController *presented = [self.viewControllers firstObject];

    DayEntriesViewController *todayController = [self createControllerOnDate:[NSDate date]];

    __weak HistoryViewController *weakSelf = self;

    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self setViewControllers:@[todayController] direction:([presented.presentedDate isDateInPast] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse) animated:YES completion:^(BOOL finished) {
        [weakSelf updateTitle];
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }

    CGPoint point = [gestureRecognizer locationInView:self.view];
    return point.x < kAllowedTapWidth || point.x > (CGRectGetWidth(self.view.frame) - kAllowedTapWidth);
}

static NSDateFormatter *__presentedDateFormatter;
+ (NSDateFormatter *)presentedDateFormatter {
    if (!__presentedDateFormatter) {
        NSString *format = [NSDateFormatter dateFormatFromTemplate:@"EE d MMM YYYY" options:0 locale:[NSLocale currentLocale]];
        __presentedDateFormatter = [[NSDateFormatter alloc] init];
        [__presentedDateFormatter setDateFormat:format];
    }

    return __presentedDateFormatter;
}

@end
