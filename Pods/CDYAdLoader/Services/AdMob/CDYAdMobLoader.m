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

#import <Google-AdMob-Ads-SDK/GADBannerView.h>
#import "CDYAdMobLoader.h"
#import "CDYAdLoadDelegate.h"
#import "CDYAdLoaderConstants.h"

@interface CDYAdMobLoader () <GADBannerViewDelegate>

@property (nonatomic, copy) NSString *adMobUnit;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation CDYAdMobLoader

- (id)initWithAdMobUnit:(NSString *)adMobUnit {
    self = [super init];
    if (self) {
        _adMobUnit = adMobUnit;
        _testDevices = @[];
    }
    return self;
}

- (void)loadBanner {
    CDYALLog(@"adMob:loadBanner");
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    [self setBannerView:bannerView];
    [bannerView setAdUnitID:self.adMobUnit];
    [bannerView setRootViewController:self.rootViewController];
    [bannerView setDelegate:self];
    GADRequest *request = [GADRequest request];
    [request setTesting:self.testing];
    [request setTestDevices:self.testDevices];
    [bannerView loadRequest:request];

}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    CDYALLog(@"adMob:adViewDidReceiveAd");
    [self.delegate service:self didLoadAdInBanner:view];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    CDYALLog(@"adMob:didFailToReceiveAdWithError:%@", error);
    [self.delegate service:self loadAdError:error];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    CDYALLog(@"adMob:adViewWillPresentScreen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    CDYALLog(@"adMob:adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    CDYALLog(@"adMob:adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    CDYALLog(@"adMob:adViewWillLeaveApplication");
}

@end
