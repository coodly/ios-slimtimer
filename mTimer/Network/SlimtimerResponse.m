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

#import "SlimtimerResponse.h"
#import "GDataXMLDocument+Helpers.h"
#import "Constants.h"
#import "GDataXMLElement+Extension.h"
#import "JCSFoundationConstants.h"

@interface SlimtimerResponse ()

@property (nonatomic, strong) NSArray *errors;

@end

@implementation SlimtimerResponse

- (id)init {
    self = [super init];
    if (self) {
        NSMutableIndexSet *acceptable = [NSMutableIndexSet indexSet];
        [acceptable addIndex:200];
        [acceptable addIndex:404];
        [acceptable addIndex:500];
        [self setAcceptableStatusCodes:acceptable];
        [self setAcceptableContentTypes:[NSSet setWithObject:@"application/xml"]];
    }

    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError * __autoreleasing *)error {
    BOOL valid = [self validateResponse:(NSHTTPURLResponse *)response data:data error:error];

    if (!valid) {
        return nil;
    }

    NSError *xmlError = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding error:&xmlError];
    if (xmlError) {
        TimerLog(@"XML parse error:%@", xmlError);
        return nil;
    }

    return [[self class] responseWithDocument:document];
}

+ (instancetype)responseWithDocument:(GDataXMLDocument *)document {
    NSArray *errorNodes = [document nodesFromRootForXPath:@"//errors/error"];

    if ([errorNodes count] > 0) {
        return [[self alloc] initWithErrors:errorNodes];
    }

    SlimtimerResponse *response = [[self alloc] init];
    [response loadDataFromDocument:document];
    return response;
}

- (void)loadDataFromDocument:(GDataXMLDocument *)document {
    JCS_ABSTRACT_METHOD;
}

- (id)initWithErrors:(NSArray *)errorNodes {
    self = [super init];
    if (self) {
        NSMutableArray *errors = [[NSMutableArray alloc] init];
        for (GDataXMLElement *node in errorNodes) {
            NSString *value = [node stringValue];
            [errors addObject:value];
        }

        [self setErrors:[NSArray arrayWithArray:errors]];
    }
    return self;
}

- (BOOL)hasErrors {
    return [self.errors count] > 0;
}

- (NSError *)responseError {
    return [NSError errorWithDomain:kTimerErrorDomain code:0 userInfo:@{@"errors": self.errors}];
}

@end
