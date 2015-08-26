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

#import "TimerTabActivityView.h"
#import "UIView+JCSLoadView.h"

@interface TimerTabActivityView ()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;

@end

@implementation TimerTabActivityView

+ (TimerTabActivityView *)activityViewWithMessage:(NSString *)message {
    TimerTabActivityView *result = [TimerTabActivityView loadInstance];
    [result.messageLabel setText:message];
    [result setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    return result;
}

- (void)positionOnView:(UIView *)view {
    [self positionOnView:view bottomOffset:0];
}

- (void)positionOnView:(UIView *)view bottomOffset:(CGFloat)offset {
    CGRect myFrame = self.frame;
    CGFloat positionY = CGRectGetHeight(view.frame) - CGRectGetHeight(myFrame) - offset;
    myFrame.origin.y = positionY;
    myFrame.size.width = CGRectGetWidth(view.frame);
    [self setFrame:myFrame];

    [view addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

@end
