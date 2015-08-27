/*
 * Copyright 2014 Coodly OÜ
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

typedef void (^CDYAdLoaderBlock)();

void CDYAdLoaderDelayedExecution(NSTimeInterval seconds, CDYAdLoaderBlock action);


#ifndef CDY_ENABLE_AD_LOADER_LOGGING
    #ifdef DEBUG
        #define CDY_ENABLE_AD_LOADER_LOGGING 1
    #else
        #define CDY_ENABLE_AD_LOADER_LOGGING 0
    #endif
#endif

#if CDY_ENABLE_AD_LOADER_LOGGING
    #define CDYALLog(s, ...) NSLog( @"<%@:%@ (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define CDYALLog(s, ...) //
#endif

typedef NS_ENUM(short, CDYBannerAdPosition) {
    AdPositionTop,
    AdPositionBottom
};