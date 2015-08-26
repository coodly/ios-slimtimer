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

#import "EditTaskCommentCell.h"
#import "JCSQuickNumericInputAccessoryView.h"
#import "UIApplication+Keyboard.h"

@interface EditTaskCommentCell ()

@property (nonatomic, strong) IBOutlet UITextView *textView;

@end

@implementation EditTaskCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    JCSQuickNumericInputAccessoryView *accessory = [[JCSQuickNumericInputAccessoryView alloc] init];
    [self.textView setInputAccessoryView:accessory];
    [accessory setReturnButtonTitle:NSLocalizedString(@"task.comment.entry.done.button.title", nil) action:^{
        [UIApplication dismissKeyboard];
    }];
}

- (NSString *)value {
    return self.textView.text;
}

- (void)setValue:(NSString *)comment {
    [self.textView setText:comment];
}

@end
