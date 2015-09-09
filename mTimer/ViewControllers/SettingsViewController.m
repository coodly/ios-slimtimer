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

@import MessageUI;
#import "SettingsViewController.h"
#import "ButtonCell.h"
#import "UIView+JCSLoadView.h"
#import "ObjectModel.h"
#import "ObjectModel+Credentials.h"
#import "TimerProgressHUD.h"
#import "ObjectModel+Users.h"
#import "Constants.h"
#import "SettingSwitchCell.h"
#import "ObjectModel+Settings.h"
#import "TimerAlertView.h"
#import "VersionDisplayView.h"

NSString *const kSettingButtonCellIdentifier = @"kSettingButtonCellIdentifier";
NSString *const kSettingSwitchCellIdentifier = @"kSettingSwitchCellIdentifier";

NSUInteger const kFeedbackSection = 1;
NSUInteger const kRateAppRow = 0;
NSUInteger const kSendFeedbackRow = 1;
NSUInteger const kLogoutSection = 2;

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) SettingSwitchCell *showCompleteTasksCell;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) BOOL productsPullError;

@end

@implementation SettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)]];
    [self.navigationItem setTitle:NSLocalizedString(@"settings.controller.title", nil)];

    [self.tableView registerNib:[ButtonCell viewNib] forCellReuseIdentifier:kSettingButtonCellIdentifier];
    [self.tableView registerNib:[SettingSwitchCell viewNib] forCellReuseIdentifier:kSettingSwitchCellIdentifier];

    __weak SettingsViewController *weakSelf = self;
    [self setShowCompleteTasksCell:[self.tableView dequeueReusableCellWithIdentifier:kSettingSwitchCellIdentifier]];
    [self.showCompleteTasksCell setValueChangeHandler:^(BOOL isOn) {
        [[weakSelf.objectModel spawnBackgroundInstance] setShowCompleteTasks:isOn];
    }];
    [self addCellForPresentation:self.showCompleteTasksCell];

    [self closeSection];

    ButtonCell *rateAppCell = [self.tableView dequeueReusableCellWithIdentifier:kSettingButtonCellIdentifier];
    [rateAppCell.textLabel setText:NSLocalizedString(@"settings.controller.rate.app.button", nil)];
    [self addCellForPresentation:rateAppCell];

    ButtonCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:kSettingButtonCellIdentifier];
    [emailCell.textLabel setText:NSLocalizedString(@"settings.controller.send.feedback.button", nil)];
    [self addCellForPresentation:emailCell];

    [self closeSection];

    ButtonCell *logoutCell = [self.tableView dequeueReusableCellWithIdentifier:kSettingButtonCellIdentifier];
    [logoutCell.textLabel setText:NSLocalizedString(@"settings.controller.logout.button", nil)];
    [self addCellForPresentation:logoutCell];

    [self.tableView setTableFooterView:[VersionDisplayView loadInstance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.showCompleteTasksCell setTitle:NSLocalizedString(@"settings.controller.show.complete.tasks.label", nil) value:self.objectModel.showCompleteTasks];
}

- (void)donePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kLogoutSection) {
        TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"settings.controller.logout.confirm.title", nil) message:NSLocalizedString(@"settings.controller.logout.confirm.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"settings.controller.logout.button", nil) action:^{
            [self performUserLogout];
        }];
        [alertView setCancelButtonTitle:NSLocalizedString(@"settings.controller.logout.cancel.button", nil) action:nil];
        [alertView show];
    } else if (indexPath.section == kFeedbackSection && indexPath.row == kRateAppRow) {
        NSString *templateReviewURL = @"itms-apps://itunes.apple.com/app/idAPP_ID";

        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", kAppStoreId]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    } else if (indexPath.section == kFeedbackSection && indexPath.row == kSendFeedbackRow) {
        [self presentMailComposer];
    }
}

- (void)presentMailComposer {
    if (![MFMailComposeViewController canSendMail]) {
        TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"settings.controller.cant.send.email.title", nil) message:NSLocalizedString(@"settings.controller.cant.send.email.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"settings.controller.cant.send.email.confirm.button", nil)];
        [alertView show];
        return;
    }

    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    [controller setToRecipients:@[@"contact@coodly.com"]];
    [controller setSubject:NSLocalizedString(@"settings.controller.feedback.email.subject", nil)];
    NSString *messageBody = [NSString stringWithFormat:@"\n\n\n| App version: %@ |", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [controller setMessageBody:messageBody isHTML:NO];

    [controller.navigationBar setTintColor:[UIColor whiteColor]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"settings.controller.send.email.error.title", nil)
                                                             message:NSLocalizedString(@"settings.controller.send.email.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"settings.controller.send.email.error.button.ok", nil)];
        [alertView show];
        return;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)performUserLogout {
    TimerProgressHUD *hud = [TimerProgressHUD showHUDOnView:self.view];
    [self.objectModel performBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kTimerLoggedOutNotification object:nil];
        [self.objectModel deleteLoggedInUser];
        [self.objectModel clearCredentials];
        [self.objectModel saveContext:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];

    }];
}

@end
