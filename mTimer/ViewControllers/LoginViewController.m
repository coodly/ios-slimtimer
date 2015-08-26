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

#import "LoginViewController.h"
#import "LoginCell.h"
#import "UIView+JCSLoadView.h"
#import "ButtonCell.h"
#import "NSString+JCSValidations.h"
#import "TimerAlertView.h"
#import "TimerProgressHUD.h"
#import "ObjectModel.h"
#import "LoginRequest.h"
#import "OnePasswordExtension.h"

NSString *const kLoginCellIdentifier = @"kLoginCellIdentifier";
NSString *const kLoginButtonCellIdentifier = @"kLoginButtonCellIdentifier";

NSUInteger const kCredentialsSection = 0;
NSUInteger const kButtonSection = 1;

@interface LoginViewController ()

@property (nonatomic, strong) LoginCell *emailCell;
@property (nonatomic, strong) LoginCell *passwordCell;
@property (nonatomic, strong) ButtonCell *buttonCell;
@property (nonatomic, strong) SlimtimerRequest *executedRequest;

@end

@implementation LoginViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[LoginCell viewNib] forCellReuseIdentifier:kLoginCellIdentifier];
    [self.tableView registerNib:[ButtonCell viewNib] forCellReuseIdentifier:kLoginButtonCellIdentifier];
    [self.navigationItem setTitle:NSLocalizedString(@"login.controller.title", nil)];

    [self setEmailCell:[self.tableView dequeueReusableCellWithIdentifier:kLoginCellIdentifier]];
    [self.emailCell setTitle:NSLocalizedString(@"login.controller.email.title", nil) value:@""];
    [self.emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.emailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self addCellForPresentation:self.emailCell];

    [self setPasswordCell:[self.tableView dequeueReusableCellWithIdentifier:kLoginCellIdentifier]];
    [self.passwordCell setTitle:NSLocalizedString(@"login.controller.password.title", nil) value:@""];
    [self.passwordCell.entryField setSecureTextEntry:YES];
    [self addCellForPresentation:self.passwordCell];

    [self closeSection];

    [self setButtonCell:[self.tableView dequeueReusableCellWithIdentifier:kLoginButtonCellIdentifier]];
    [self.buttonCell.textLabel setText:NSLocalizedString(@"login.controller.log.in.button", nil)];
    [self addCellForPresentation:self.buttonCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        return;
    }

    UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"onepassword-navbar"] style:UIBarButtonItemStylePlain target:self action:@selector(onePasswordLogin)];
    [self.navigationItem setRightBarButtonItem:login];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != kButtonSection) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self haveValidInput]) {
            TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"login.entry.invalid.alert.title", nil) message:NSLocalizedString(@"login.entry.invalid.alert.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"login.entry.invalid.alert.dismiss.button", nil)];
            [alertView show];
            return;
        }

        [self executeLogin];
    });
}

- (BOOL)haveValidInput {
    return [self.emailCell.entryField.text hasValue] && [self.passwordCell.entryField.text hasValue];
}

- (void)executeLogin {
    TimerProgressHUD *hud = [TimerProgressHUD showHUDOnView:self.navigationController.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginRequest *request = [[LoginRequest alloc] initWithEmail:[self.emailCell value] password:[self.passwordCell value]];
        [self setExecutedRequest:request];
        [request setObjectModel:self.objectModel];
        [request setResponseHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                if (error) {
                    TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) error:error];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"login.error.dismiss.button.title", nil)];
                    [alertView show];

                    return;
                }

                if (success) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
        [request execute];
    });
}

- (void)onePasswordLogin {
    [[OnePasswordExtension sharedExtension] findLoginForURLString:@"http://slimtimer.com/" forViewController:self sender:nil completion:^(NSDictionary *loginDict, NSError *error) {
        if (!loginDict) {
            return;
        }

        [self.emailCell.entryField setText:loginDict[AppExtensionUsernameKey]];
        [self.passwordCell.entryField setText:loginDict[AppExtensionPasswordKey]];
        [self executeLogin];
    }];
}

@end
