/*
 * Copyright 2015 Coodly OÜ
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

#import "CDYUserInputSection.h"

@interface CDYUserInputSection ()

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, strong) NSArray *sectionCells;

@end

@implementation CDYUserInputSection

+ (CDYUserInputSection *)sectionWithCells:(NSArray *)cells {
    return [CDYUserInputSection sectionWithTitle:nil cells:cells];
}

+ (CDYUserInputSection *)sectionWithTitle:(NSString *)title cells:(NSArray *)cells {
    CDYUserInputSection *section = [[CDYUserInputSection alloc] init];
    [section setSectionTitle:title];
    [section setSectionCells:cells];
    return section;
}

- (NSInteger)numberOfCells {
    return [self.sectionCells count];
}

- (UITableViewCell *)cellAtRow:(NSInteger)row {
    return self.sectionCells[row];
}

@end
