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

#import <StoreKit/StoreKit.h>
#import "TimerAlertView.h"
#import "Constants.h"
#import "NSMutableString+Issues.h"

@interface TimerAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *actionsMapping;

@end

@implementation TimerAlertView

+ (TimerAlertView *)alertViewWithTitle:(NSString *)alertTitle message:(NSString *)message {
    TimerAlertView *alertView = [[TimerAlertView alloc] initWithTitle:alertTitle
                                                              message:message
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
    [alertView setDelegate:alertView];
    return alertView;
}

+ (TimerAlertView *)alertViewWithTitle:(NSString *)title error:(NSError *)error {
    if ([error.domain isEqualToString:kTimerErrorDomain] && error.userInfo[@"errors"]) {
        NSArray *errors = error.userInfo[@"errors"];
        NSMutableString *issues = [NSMutableString string];
        for (NSString *issue in errors) {
            NSString *errorKey = [[[issue componentsSeparatedByString:@" "] componentsJoinedByString:@"."] lowercaseString];
            errorKey = [NSString stringWithFormat:@"server.error.%@", errorKey];
            [issues appendIssue:NSLocalizedString(errorKey, nil)];
        }

        return [TimerAlertView alertViewWithTitle:title message:issues];
    } else if ([error.domain isEqualToString:SKErrorDomain]) {
        return [TimerAlertView alertViewWithTitle:title message:error.localizedDescription];
    } else {
        return [TimerAlertView alertViewWithTitle:title message:error.localizedDescription];
    }
}

- (void)setConfirmButtonTitle:(NSString *)title {
    [self setConfirmButtonTitle:title action:nil];
}

- (void)setConfirmButtonTitle:(NSString *)title action:(JCSActionBlock)action {
    NSInteger index = [self addButtonWithTitle:title];

    if (!action) {
        return;
    }

    self.actionsMapping[@(index)] = action;
}

- (void)setCancelButtonTitle:(NSString *)title action:(JCSActionBlock)action {
    NSInteger index = [self addButtonWithTitle:title];
    [self setCancelButtonIndex:index];

    if (!action) {
        return;
    }

    self.actionsMapping[@(index)] = action;
}


- (NSMutableDictionary *)actionsMapping {
    if (!_actionsMapping) {
        _actionsMapping = [NSMutableDictionary dictionary];
    }

    return _actionsMapping;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    JCSActionBlock actionBlock = self.actionsMapping[@(buttonIndex)];
    if (actionBlock) {
        actionBlock();
    }
}


@end
