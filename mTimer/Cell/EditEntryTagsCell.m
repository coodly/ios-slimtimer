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

#import "EditEntryTagsCell.h"

@interface EditEntryTagsCell ()

@property (nonatomic, assign) CGFloat originalHeight;

@end

@implementation EditEntryTagsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setOriginalHeight:CGRectGetHeight(self.textLabel.frame)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title tags:(NSString *)tags {
    NSString *message = [NSString stringWithFormat:@"%@ %@", title, tags];
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedMessage setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} range:NSMakeRange(0, [message length])];
    NSRange titleRange = [message rangeOfString:title];
    [attributedMessage setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} range:titleRange];
    [self.textLabel setAttributedText:attributedMessage];

    CGRect textFrame = self.textLabel.frame;
    CGFloat perfectHeight = [self.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(textFrame), CGFLOAT_MAX)].height;
    perfectHeight = MAX(perfectHeight, self.originalHeight);
    CGFloat heightChange = perfectHeight -= CGRectGetHeight(textFrame);

    CGRect myFrame = self.frame;
    myFrame.size.height += heightChange;
    [self setFrame:myFrame];
}

@end
