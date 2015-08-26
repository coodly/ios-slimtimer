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

#import "ObjectModel+TimeReports.h"
#import "TimeReport.h"
#import "SyncStatus.h"
#import "Constants.h"

@implementation ObjectModel (TimeReports)

- (void)createTimeReportWithSeconds:(NSNumber *)seconds {
    TimerLog(@"createTimeReportWithSeconds:%@", seconds);
    TimeReport *report = [TimeReport insertInManagedObjectContext:self.managedObjectContext];
    [report setSeconds:seconds];
    [report setSyncStatus:[SyncStatus insertInManagedObjectContext:self.managedObjectContext]];
    [report.syncStatus setSyncNeededValue:YES];
}

@end
