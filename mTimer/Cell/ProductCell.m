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

#import <JCSFoundation/UITableViewCell+JCSPositioning.h>
#import "ProductCell.h"

@interface ProductCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustLabels {
    [UITableViewCell adjustWidthForTitle:self.nameLabel value:self.priceLabel];
}

- (void)showUpdating {
    [self.priceLabel setHidden:YES];
    [self.spinner startAnimating];
}

- (void)setPrice:(NSDecimalNumber *)price locale:(NSLocale *)locale {
    [self.spinner stopAnimating];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:locale];
    NSString *formattedString = [numberFormatter stringFromNumber:price];
    [self.priceLabel setHidden:NO];
    [self.priceLabel setText:formattedString];
}

- (void)showError {
    [self.spinner stopAnimating];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"724-info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [imageView setTintColor:[UIColor redColor]];
    [self setAccessoryView:imageView];
}

- (void)markPurchased {
    [self.spinner stopAnimating];
    [self.priceLabel setHidden:YES];
    [self setAccessoryView:nil];
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
}

@end
