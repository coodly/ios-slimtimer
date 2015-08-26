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

#import "ObjectModel+Credentials.h"
#import "Lockbox.h"
#import "NSString+JCSValidations.h"
#import "ObjectModel+Users.h"

NSString *const kKeyEmail = @"kKeyEmail";
NSString *const kKeyPassword = @"kKeyPassword";
NSString *const kKeyUserId = @"kKeyUserId";
NSString *const kKeyAccessToken = @"kKeyAccessToken";

@implementation ObjectModel (Credentials)

- (BOOL)loggedIn {
    return [self loggedInUser] != nil;
}

- (void)setLoginDetails:(NSString *)email password:(NSString *)password {
    [Lockbox setString:email forKey:kKeyEmail];
    [Lockbox setString:password forKey:kKeyPassword];
}

- (void)setUserCredentials:(NSNumber *)userId accessToken:(NSString *)accesToken {
    [Lockbox setString:[NSString stringWithFormat:@"%@", userId] forKey:kKeyUserId];
    [Lockbox setString:accesToken forKey:kKeyAccessToken];
}

- (NSNumber *)loggedInUserId {
    NSString *userId = [Lockbox stringForKey:kKeyUserId];
    if ([userId hasValue]) {
        return @([userId integerValue]);
    }

    return @(-1);
}

- (void)clearCredentials {
    [Lockbox setString:@"" forKey:kKeyEmail];
    [Lockbox setString:@"" forKey:kKeyPassword];
    [Lockbox setString:@"" forKey:kKeyUserId];
    [Lockbox setString:@"" forKey:kKeyAccessToken];
}

- (NSString *)accessToken {
    return [Lockbox stringForKey:kKeyAccessToken];
}

@end
