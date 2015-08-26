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

#import "EditTaskTagsCell.h"

@interface EditTaskTagsCell ()

@property (nonatomic, strong) IBOutlet UILabel *tagsLabel;
@property (nonatomic, assign) CGFloat minHeight;

@end

@implementation EditTaskTagsCell

- (void)awakeFromNib {
    [self setMinHeight:CGRectGetHeight(self.frame)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustSize {
    CGRect labelFrame = self.tagsLabel.frame;
    CGFloat perfectHeight = [self.tagsLabel sizeThatFits:CGSizeMake(CGRectGetWidth(labelFrame), CGFLOAT_MAX)].height;

    CGRect myFrame = self.frame;
    myFrame.size.height = MAX(perfectHeight + 2 * 10, self.minHeight);
    [self setFrame:myFrame];
}

@end
