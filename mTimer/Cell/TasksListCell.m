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

#import "TasksListCell.h"
#import "NSDate+Formatting.h"
#import "NSString+JCSValidations.h"

CGFloat const kLabelsSpacing = 5;

@interface TasksListCell ()

@property (nonatomic, strong) IBOutlet UILabel *taskNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *taskTimeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime;

@end

@implementation TasksListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContentFont:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    [self adjustContentFont:nil];
}

- (void)adjustContentFont:(NSNotification *)notification {
    [self.taskNameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self.taskTimeLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];

    if (![self.taskNameLabel.text hasValue]) {
        [self.taskTimeLabel setText:@"W"];
    }
    if (![self.taskTimeLabel.text hasValue]) {
        [self.taskTimeLabel setText:@"W"];
    }

    [self adjustHeight];
}

- (void)prepareForReuse {
    [self.timer invalidate];
}

- (void)adjustHeight {
    CGRect labelFrame = self.taskNameLabel.frame;
    CGFloat perfectTaskNameHeight = [self.taskNameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(labelFrame), CGFLOAT_MAX)].height;
    CGFloat heightChange = perfectTaskNameHeight - CGRectGetHeight(labelFrame);
    labelFrame.size.height += heightChange;
    [self.taskNameLabel setFrame:labelFrame];

    CGRect timeFrame = self.taskTimeLabel.frame;
    CGFloat perfectTimeHeight = [self.taskTimeLabel sizeThatFits:CGSizeMake(CGRectGetWidth(timeFrame), CGFLOAT_MAX)].height;
    CGFloat timeHeightChange = perfectTimeHeight - CGRectGetHeight(timeFrame);
    timeFrame.size.height += timeHeightChange;
    [self.taskTimeLabel setFrame:timeFrame];


    CGRect myFrame = self.frame;
    myFrame.size.height = CGRectGetHeight(labelFrame) + CGRectGetHeight(timeFrame) + 2 * kLabelsSpacing;
    [self setFrame:myFrame];
}

- (void)setTimerStartTime:(NSDate *)date {
    [self.timer invalidate];
    [self setStartTime:date];

    if (date) {
        CGRect nameFrame = self.taskNameLabel.frame;
        nameFrame.origin.y = kLabelsSpacing;
        [self.taskNameLabel setFrame:nameFrame];

        [self.taskTimeLabel setHidden:NO];
        CGRect timeFrame = self.taskTimeLabel.frame;
        timeFrame.origin.y = kLabelsSpacing + CGRectGetHeight(nameFrame);
        [self.taskTimeLabel setFrame:timeFrame];

        [self setTimer:[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES]];
        [self updateTime];
    } else {
        [self.taskTimeLabel setHidden:YES];
        [self yCenterLabel:self.taskNameLabel];
    }
}

- (void)updateTime {
    [self.taskTimeLabel setText:[[NSDate date] formattedDifferenceFromDate:self.startTime]];
}

- (void)yCenterLabel:(UILabel *)label {
    CGRect labelFrame = label.frame;
    labelFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(labelFrame)) / 2;
    [label setFrame:labelFrame];
}

@end
