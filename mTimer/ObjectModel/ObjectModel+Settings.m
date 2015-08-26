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

#import "ObjectModel+Settings.h"
#import "Setting.h"
#import "ObjectModel+Tasks.h"

typedef NS_ENUM(short, SettingKey) {
    SettingShowCompleteTasks,
    SettingEntriesCheckTime
};

@implementation ObjectModel (Settings)

- (BOOL)showCompleteTasks {
    return [self booleanValueForKey:SettingShowCompleteTasks defaultValue:YES];
}

- (void)setShowCompleteTasks:(BOOL)show {
    [self setBoolValue:show forKey:SettingShowCompleteTasks];
    [self hideCompleteTasks:!show];
}

- (NSDate *)lastEntriesCheckTime {
    return [self dateValueForKey:SettingEntriesCheckTime defaultValue:[NSDate distantPast]];
}

- (void)setLastEntriesCheckTime:(NSDate *)checkTime {
    [self setDateValue:checkTime forKey:SettingEntriesCheckTime];
}

- (BOOL)booleanValueForKey:(SettingKey)key defaultValue:(BOOL)defaultValue {
    Setting *setting = [self loadSettingForKey:key];
    if (!setting) {
        return defaultValue;
    }

    return [setting boolValue];
}

- (void)setBoolValue:(BOOL)value forKey:(SettingKey)key {
    [self setSettingValue:[NSString stringWithFormat:@"%d", value] forKey:key];
}

- (NSDate *)dateValueForKey:(SettingKey)key defaultValue:(NSDate *)defaultValue {
    Setting *setting = [self loadSettingForKey:key];
    if (!setting) {
        return defaultValue;
    }

    return [setting dateValue];
}

- (void)setDateValue:(NSDate *)date forKey:(SettingKey)key {
    [self setSettingValue:[[Setting settingDateFormatter] stringFromDate:date] forKey:key];
}

- (void)setSettingValue:(NSString *)value forKey:(SettingKey)key {
    Setting *setting = [self loadSettingForKey:key];
    if (!setting) {
        setting = [Setting insertInManagedObjectContext:self.managedObjectContext];
        [setting setKeyValue:key];
    }

    [setting setValue:value];
}

- (Setting *)loadSettingForKey:(SettingKey)key {
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"key = %d", key];
    return [self fetchEntityNamed:[Setting entityName] withPredicate:keyPredicate];
}

@end
