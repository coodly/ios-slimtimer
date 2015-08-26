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

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)navigationBarColor {
    return [UIColor colorWithRed:0.075 green:0.420 blue:0.984 alpha:1.000];
}

+ (UIColor *)runningTaskColor {
    return [UIColor colorWithRed:0.373 green:0.992 blue:0.267 alpha:1.000];
}

+ (UIColor *)completeTaskBackgroundColor {
    return [UIColor lightGrayColor];
}

@end
