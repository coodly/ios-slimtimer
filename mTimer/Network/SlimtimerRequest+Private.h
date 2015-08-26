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

#import <Foundation/Foundation.h>

@class GDataXMLDocument;
@class SlimtimerResponse;

typedef void (^SlimtimerRawResponseBlock)(SlimtimerResponse *response);
typedef void (^SlimtimerRawErrorBlock)(NSError *error);

@interface SlimtimerRequest (Private)

- (void)postToPath:(NSString *)path content:(NSDictionary *)content;
- (void)putToPath:(NSString *)path content:(NSDictionary *)content;
- (void)deleteToPath:(NSString *)path;
- (void)getDataFromPath:(NSString *)path params:(NSDictionary *)params;
- (void)setRawResponseHandler:(SlimtimerRawResponseBlock)handler;
- (void)setRawErrorHandler:(SlimtimerRawErrorBlock)handler;

@end
