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

#import "ManageTaskCell.h"

@interface ManageTaskCell ()

@property (nonatomic, strong) IBOutlet UILabel *taskNameLabel;

@end

@implementation ManageTaskCell

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
    [self adjustHeight];
}

- (void)adjustHeight {
    CGRect labelFrame = self.taskNameLabel.frame;
    CGFloat perfectTaskNameHeight = [self.taskNameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(labelFrame), CGFLOAT_MAX)].height;

    CGRect myFrame = self.frame;
    myFrame.size.height = perfectTaskNameHeight + 2 * 10;
    [self setFrame:myFrame];
}

@end
