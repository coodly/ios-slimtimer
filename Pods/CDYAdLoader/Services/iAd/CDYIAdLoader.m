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

#import <iAd/iAd.h>
#import "CDYIAdLoader.h"
#import "CDYAdLoaderConstants.h"
#import "CDYAdLoadDelegate.h"

@interface CDYIAdLoader () <ADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *presentedBanner;

@end

@implementation CDYIAdLoader

- (void)loadBanner {
    CDYALLog(@"loadBanner");
    [self.presentedBanner setDelegate:nil];
    [self.presentedBanner removeFromSuperview];

    ADBannerView *banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    [self setPresentedBanner:banner];
    [banner setDelegate:self];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    CDYALLog(@"iAd:bannerViewDidLoadAd");
    [self.delegate service:self didLoadAdInBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    CDYALLog(@"iAd:didFailToReceiveAdWithError:%@", error);
    [self.delegate service:self loadAdError:error];

    [self.presentedBanner setDelegate:nil];
    [self setPresentedBanner:nil];
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    CDYALLog(@"iAd:bannerViewWillLoadAd:");
}

@end
