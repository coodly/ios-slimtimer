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

#import "LoginRequest.h"
#import "SlimtimerRequest+Private.h"
#import "Constants.h"
#import "LoginResponse.h"
#import "ObjectModel+Credentials.h"
#import "ObjectModel+Users.h"

NSString *const kLoginPath = @"/users/token";

@interface LoginRequest ()

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

@end

@implementation LoginRequest

- (id)initWithEmail:(NSString *)email password:(NSString *)password {
    self = [super initWithResponseSerializer:[LoginResponse serializer]];
    if (self) {
        [self setEmail:email];
        [self setPassword:password];
    }
    return self;
}

- (void)execute {
    TimerLog(@"Execute");

    __weak LoginRequest *weakSelf = self;
    [self setRawErrorHandler:^(NSError *error) {
        TimerLog(@"Error:%@", error);
        weakSelf.responseHandler(NO, error);
    }];

    [self setRawResponseHandler:^(SlimtimerResponse *response) {
        TimerLog(@"Success response:%@", response);
        [weakSelf.workerModel performBlock:^{
            LoginResponse *loginResponse = (LoginResponse *) response;
            [weakSelf.workerModel setLoginDetails:weakSelf.email password:weakSelf.password];
            [weakSelf.workerModel setUserCredentials:loginResponse.userId accessToken:loginResponse.accessToken];
            [weakSelf.workerModel ensureUserWithIdExists:loginResponse.userId];
            [weakSelf.workerModel saveContext:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kTimerLoggedInNotification object:nil];
                weakSelf.responseHandler(YES, nil);
            }];
        }];
    }];

    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    content[@"api-key"] = kSlimtimerAPIKey;
    content[@"user"] = @{@"email": self.email, @"password": self.password};

    [self postToPath:kLoginPath content:content];
}

- (BOOL)shouldAddCredentialsToPath {
    return NO;
}

@end
