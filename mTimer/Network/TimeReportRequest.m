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

#include <sys/sysctl.h>
#import <Lockbox/Lockbox.h>
#import <JCSFoundation/NSString+JCSValidations.h>
#import "TimeReportRequest.h"
#import "Constants.h"
#import "ObjectModel+Settings.h"
#import "TimeReport.h"

NSString *const kTimeReportServerURLString = @"http://apps.jaanussiim.com";
NSString *const kTimeReportPath = @"/apps/mtimer/add";
NSString *const kReportingCodeKey = @"kSlimTimerReportingKey";

@interface TimeReportRequest ()

@property (nonatomic, strong) NSManagedObjectID *reportID;

@end

@implementation TimeReportRequest

- (id)initWithReportID:(NSManagedObjectID *)reportID {
    self = [super initWithBaseURL:[NSURL URLWithString:kTimeReportServerURLString]];
    if (self) {
        [self setReportID:reportID];
    }

    return self;
}

- (void)execute {
    __weak TimeReportRequest *weakSelf = self;
    [self.objectModel performBlock:^{
        NSLog(@"Execute");

        TimeReport *report = (TimeReport *) [weakSelf.objectModel.managedObjectContext objectWithID:self.reportID];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *code = [Lockbox stringForKey:kReportingCodeKey];
        if ([code hasValue]) {
            params[@"reporting_code"] = code;
        }

        params[@"seconds"] = report.seconds;
        params[@"platform"] = @"ios";

        UIDevice *device = [UIDevice currentDevice];
        params[@"version"] = device.systemVersion;
        params[@"model"] = [self platform];
        params[@"manufacturer"] = @"Apple";
        CGSize size = [UIScreen mainScreen].bounds.size;
        params[@"s_width"] = @([[NSNumber numberWithFloat:size.width] intValue]);
        params[@"s_height"] = @([[NSNumber numberWithFloat:size.height] intValue]);
        params[@"density"] = @([self density]);
        params[@"app_version"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        [self POST:kTimeReportPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            TimerLog(@"Success");
            [self handleCode:operation.response.statusCode content:operation.responseString];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            TimerLog(@"Error");
            [self handleCode:operation.response.statusCode content:operation.responseString];
        }];
    }];
}

- (void)handleCode:(NSInteger)httpCode content:(NSString *)content {
    TimerLog(@"Handled code:%ld content:%@", httpCode, content);
    if (httpCode == 200) {
        if ([content hasValue]) {
            [Lockbox setString:content forKey:kReportingCodeKey];
        }
        self.responseHandler(YES, nil);
    } else {
        self.responseHandler(NO, nil);
    }
}

- (float)density {
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        return screen.scale;
    } else {
        return 1.0;
    }
}

- (NSString *)platform {
    //http://www.clintharris.net/2009/iphone-model-via-sysctlbyname/
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    /*
     Possible values:
     "iPhone1,1" = iPhone 1G
     "iPhone1,2" = iPhone 3G
     "iPhone2,1" = iPhone 3GS
     "iPod1,1"   = iPod touch 1G
     "iPod2,1"   = iPod touch 2G
     */
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];

    free(machine);
    return platform;
}

@end
