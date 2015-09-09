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

#import "TagSelectionCell.h"
#import "JCSSelectable.h"

CGFloat const kTagCellSpacing = 10;

@interface TagSelectionCell ()

@property (nonatomic, strong) IBOutlet UILabel *tagLabel;

@end

@implementation TagSelectionCell

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
    [self.tagLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
}

- (void)configureWithSelectable:(id <JCSSelectable>)selectable {
    [self.tagLabel setText:selectable.name];

    CGRect textFrame = self.tagLabel.frame;
    CGFloat fitHeight = [self.tagLabel sizeThatFits:CGSizeMake(CGRectGetWidth(textFrame), CGFLOAT_MAX)].height;
    CGFloat heightChange = fitHeight - CGRectGetHeight(textFrame);
    textFrame.size.height += heightChange;
    [self.tagLabel setFrame:textFrame];

    CGRect myFrame = self.frame;
    myFrame.size.height = CGRectGetHeight(textFrame) + 2 * kTagCellSpacing;
    [self setFrame:myFrame];
}

- (void)markSelected:(BOOL)isSelected {
    [self setAccessoryType:isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
}

@end
