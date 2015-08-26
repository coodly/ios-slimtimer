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

#import <JCSFoundation/UIView+JCSLoadView.h>
#import "TagsViewController.h"
#import "ObjectModel+Tags.h"
#import "TagSelectionCell.h"
#import "AddTagViewController.h"
#import "NSString+JCSValidations.h"
#import "TimerAlertView.h"
#import "Tag.h"

@interface TagsViewController ()

@property (nonatomic, strong) TagSelectionCell *measureCell;

@end

@implementation TagsViewController

- (id)init {
    self = [super initWithNibName:@"TagsViewController" bundle:nil];
    if (self) {
        [self setSelectionCellNib:[TagSelectionCell viewNib]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    [self setSelectableObjectsController:[self.objectModel fetchedControllerForAllUserTags]];
    [self.navigationItem setTitle:NSLocalizedString(@"tags.controller.title", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)addTagPressed {
    AddTagViewController *controller = [[AddTagViewController alloc] init];
    [controller setEntryValidationBlock:^BOOL(NSString *input) {
        NSString *message = nil;
        if (![input hasValue]) {
            message = NSLocalizedString(@"add.tag.no.input.error.message", nil);
        } else if ([self.objectModel hasTagNamed:input]) {
            message = NSLocalizedString(@"add.tag.exists.error.message", nil);
        }

        if ([message hasValue]) {
            TimerAlertView *alertView = [TimerAlertView alertViewWithTitle:NSLocalizedString(@"add.tag.error.alert.title", nil) message:message];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"add.tag.error.dismiss.button", nil)];
            [alertView show];
        }

        return ![message hasValue];
    }];

    [controller setCompletionBlock:^(NSString *input) {
        Tag *tag = [self.objectModel addTagWithValue:input];
        [self.objectModel saveContext:^{
            [self addToSelected:tag];

            NSIndexPath *indexPath = [self.selectableObjectsController indexPathForObject:tag];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];

        [self.navigationController popViewControllerAnimated:YES];
    }];

    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tag *tag = [self.selectableObjectsController objectAtIndexPath:indexPath];
    [self.measureCell configureWithSelectable:tag];
    return CGRectGetHeight(self.measureCell.frame);
}

@end
