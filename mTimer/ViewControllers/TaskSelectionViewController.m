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

#import "TaskSelectionViewController.h"
#import "ObjectModel.h"
#import "ObjectModel+Tasks.h"
#import "TaskSelectionCell.h"
#import "Task.h"
#import "UIView+CDYLoadHelper.h"

@interface TaskSelectionViewController ()

@property (nonatomic, strong) TaskSelectionCell *measureCell;

@end

@implementation TaskSelectionViewController

- (id)init {
    self = [super initWithNibName:@"TaskSelectionViewController" bundle:nil];
    if (self) {
        [self setSelectionCellNib:[TaskSelectionCell viewNib]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setMeasureCell:[TaskSelectionCell loadInstance]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    [self setSelectableObjectsController:[self.objectModel fetchedControllerForActiveUserTasks]];

    [self.navigationItem setTitle:NSLocalizedString(@"task.selection.controller.title", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.selectableObjectsController objectAtIndexPath:indexPath];
    [self.measureCell configureWithSelectable:task];
    return CGRectGetHeight(self.measureCell.frame);
}

- (void)contentSizeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
