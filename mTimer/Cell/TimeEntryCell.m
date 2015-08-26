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

#import "TimeEntryCell.h"
#import "UIView+AdjustHeight.h"

CGFloat const kLeadSpacing = 10;
CGFloat const kMiddleSpacing = 3;

@interface TimeEntryCell ()

@property (nonatomic, strong) IBOutlet UILabel *taskNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timesLabel;
@property (nonatomic, strong) IBOutlet UILabel *runTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *tagsLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *purchaseHistory;

@end

@implementation TimeEntryCell

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
    [self.purchaseHistory setTextColor:[UIColor lightGrayColor]];
    [self.purchaseHistory setText:NSLocalizedString(@"day.entries.purchase.history.message", nil)];

    [self adjustContentFont:nil];
}

- (void)adjustContentFont:(NSNotification *)notification {
    [self.taskNameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self.tagsLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]];
    [self.timesLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.runTimeLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.purchaseHistory setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.commentLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
}

- (void)adjustHeight {
    CGFloat totalHeight = [self.taskNameLabel adjustToPerfectHeight];
    totalHeight += [self.tagsLabel adjustToPerfectHeight];
    totalHeight += [self.timesLabel adjustToPerfectHeight];
    [self.runTimeLabel adjustToPerfectHeight];
    totalHeight += [self.commentLabel adjustToPerfectHeight];
    totalHeight += kLeadSpacing * 2 + 3 * kMiddleSpacing;

    CGRect myFrame = self.frame;
    myFrame.size.height = totalHeight;
    [self setFrame:myFrame];

    [self positionLabels:@[@[self.taskNameLabel], @[self.tagsLabel], @[self.timesLabel, self.runTimeLabel, self.purchaseHistory], @[self.commentLabel]] offset:kLeadSpacing];
}

- (void)hideContent:(BOOL)hide {
    [self.tagsLabel setHidden:hide];
    [self.timesLabel setHidden:hide];
    [self.runTimeLabel setHidden:hide];
    [self.commentLabel setHidden:hide];
    [self.purchaseHistory setHidden:!hide];
}

- (void)positionLabels:(NSArray *)rows offset:(CGFloat)offset {
    CGFloat yOffset = offset;
    for (NSArray *labels in rows) {
        for (UIView *view in labels) {
            CGRect frame = view.frame;
            frame.origin.y = yOffset;
            [view setFrame:frame];
        }

        UIView *anyView = [labels firstObject];
        yOffset += CGRectGetHeight(anyView.frame);
        yOffset += kMiddleSpacing;
    }
}

@end
