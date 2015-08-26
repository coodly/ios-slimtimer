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

#import <JCSFoundation/JCSSelectable.h>
#import "TaskSelectionCell.h"

@interface TaskSelectionCell ()

@property (nonatomic, strong) IBOutlet UILabel *taskNameLabel;

@end

@implementation TaskSelectionCell

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
    [self configureWithTaskName:self.taskNameLabel.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithSelectable:(id <JCSSelectable>)selectable {
    [self configureWithTaskName:selectable.name];
}

- (void)configureWithTaskName:(NSString *)name {
    [self.taskNameLabel setText:name];

    CGRect labelFrame = self.taskNameLabel.frame;
    CGFloat perfectHeight = [self.taskNameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(labelFrame), CGFLOAT_MAX)].height;
    labelFrame.size.height = perfectHeight;
    [self.taskNameLabel setFrame:labelFrame];

    CGRect myFrame = self.frame;
    myFrame.size.height = perfectHeight + 2 * 10;
    [self setFrame:myFrame];
}

- (void)markSelected:(BOOL)isSelected {
    [self setAccessoryType:isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
}

@end
