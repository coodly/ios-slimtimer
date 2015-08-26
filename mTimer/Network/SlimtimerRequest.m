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

#import "SlimtimerRequest.h"
#import "ObjectModel.h"
#import "SlimtimerRequest+Private.h"
#import "GDataXMLNode.h"
#import "Constants.h"
#import "ObjectModel+Credentials.h"
#import "SlimtimerResponse.h"
#import "NSString+UrlEncode.h"
#import "JCSFoundationConstants.h"

@interface SlimtimerRequest ()

@property (nonatomic, copy) SlimtimerRawResponseBlock rawResponseHandler;
@property (nonatomic, copy) SlimtimerRawErrorBlock rawErrorHandler;
@property (nonatomic, strong) ObjectModel *workerModel;

@end

@implementation SlimtimerRequest

- (id)initWithResponseSerializer:(AFHTTPResponseSerializer *)serializer {
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://slimtimer.com"]];
    if (self) {
        [self setResponseSerializer:serializer];
    }
    return self;
}

- (void)execute {
    JCS_ABSTRACT_METHOD;
}

- (void)postToPath:(NSString *)path content:(NSDictionary *)content {
    [self executeMethod:@"POST" withContent:content params:@{} toPath:path];
}

- (void)putToPath:(NSString *)path content:(NSDictionary *)content {
    [self executeMethod:@"PUT" withContent:content params:@{} toPath:path];
}

- (void)deleteToPath:(NSString *)path {
    [self executeMethod:@"DELETE" withContent:@{} params:@{} toPath:path];
}

- (void)getDataFromPath:(NSString *)path params:(NSDictionary *)params {
    [self executeMethod:@"GET" withContent:@{} params:params toPath:path];
}

- (void)executeMethod:(NSString *)method withContent:(NSDictionary *)content params:(NSDictionary *)params toPath:(NSString *)path {
    JCSAssert(self.objectModel);

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];

    NSMutableDictionary *urlParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([self shouldAddCredentialsToPath]) {
        urlParams[@"api_key"] = kSlimtimerAPIKey;
        urlParams[@"access_token"] = [self.objectModel accessToken];
    }

    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    urlString = [self addParameters:urlParams toString:urlString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:urlString parameters:urlParams];
    TimerLog(@"%@ to %@", method, [request.URL absoluteString]);

    [request addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    if ([content count] > 0) {
        [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
        NSData *bodyData = [self buildRequestBody:content];
        [request setHTTPBody:bodyData];
        TimerLog(@"Body:%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    }

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *op, id responseObject) {
        TimerLog(@"Success:%@", responseObject);
        TimerLog(@"Response:%@", op.responseString);
        SlimtimerResponse *response = responseObject;
        [self callbackWithResponseObject:response];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        TimerLog(@"Error:%@", error);
        TimerLog(@"Response:%@", op.responseString);
        self.rawErrorHandler(error);
    }];

    [self.operationQueue addOperation:operation];
}

- (void)callbackWithResponseObject:(SlimtimerResponse *)response {
    if ([response hasErrors]) {
        self.rawErrorHandler([response responseError]);
    } else {
        self.rawResponseHandler(response);
    }
}

- (NSData *)buildRequestBody:(NSDictionary *)body {
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"request"];

    [self addDictionary:body toElement:requestElement];

    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    return [document XMLData];
}

- (void)addDictionary:(NSDictionary *)values toElement:(GDataXMLElement *)element {
    NSArray *keys = values.keyEnumerator.allObjects;
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *key in sortedKeys) {
        id value = [values valueForKey:key];
        [self addChildWithName:key value:value toElement:element];
    }
}

- (void)addChildWithName:(NSString *)name value:(id)value toElement:(GDataXMLElement *)element {
    if ([value isKindOfClass:[NSString class]]) {
        [self addString:value withName:name toElement:element];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        GDataXMLElement *dictElement = [GDataXMLNode elementWithName:name];
        [self addDictionary:value toElement:dictElement];
        [element addChild:dictElement];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        [self addString:[NSString stringWithFormat:@"%@", value] withName:name toElement:element];
    }
}

- (void)addString:(NSString *)value withName:(NSString *)name toElement:(GDataXMLElement *)element {
    GDataXMLElement *stringElement = [GDataXMLNode elementWithName:name stringValue:value];
    [element addChild:stringElement];
}

- (ObjectModel *)workerModel {
    if (!_workerModel) {
        _workerModel = [self.objectModel spawnBackgroundInstance];
    }

    return _workerModel;
}

- (BOOL)shouldAddCredentialsToPath {
    return YES;
}

- (NSString *)addParameters:(NSMutableDictionary *)params toString:(NSString *)urlString {
    if ([params count] == 0) {
        return urlString;
    }

    NSMutableString *result = [NSMutableString stringWithString:urlString];
    if ([result rangeOfString:@"?"].location == NSNotFound) {
        [result appendString:@"?"];
    } else {
        [result appendString:@"&"];
    }

    for (id key in params) {
        id value = params[key];
        NSString *append = [value isKindOfClass:[NSString class]] ? value : [NSString stringWithFormat:@"%@", value];
        [result appendFormat:@"%@=%@&", key, [append urlEncode]];
    }

    [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];

    return [NSString stringWithString:result];
}

@end
