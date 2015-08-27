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

#import "CDYAdLoader.h"
#import "CDYAdService.h"
#import "CDYAdLoadDelegate.h"

NSTimeInterval const CDYAdLoaderAnimationTime = 0.3;

@interface CDYAdLoader () <CDYAdLoadDelegate>

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) id <CDYAdService> presentedService;
@property (nonatomic, strong) UIView *presentedBanner;

@end

@implementation CDYAdLoader

+ (CDYAdLoader *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[CDYAdLoader alloc] initSingleton];
    });
    return _sharedObject;

}

- (id)initSingleton {
    self = [super init];
    if (self) {
        _services = [[NSMutableArray alloc] init];
        _bannerAdPosition = AdPositionTop;
    }
    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (void)addService:(id <CDYAdService>)adService {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.services addObject:adService];
    });
}

- (void)reloadAds {
    dispatch_async(dispatch_get_main_queue(), ^{
        CDYALLog(@"reloadAds");
        [self hideBanner:NO completion:^{
            [self loadBannerUsingService:[self.services firstObject]];
        }];
    });
}

- (void)setAdCheckTime:(NSTimeInterval)adCheckTime {
    _adCheckTime = adCheckTime;

    CDYAdLoaderDelayedExecution(adCheckTime, ^{
        [self checkAdShown];
    });
}

- (void)setLoadingAdsDisabled:(BOOL)loadingAdsDisabled {
    _loadingAdsDisabled = loadingAdsDisabled;

    if (!loadingAdsDisabled) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBanner:YES completion:^{
            CDYALLog(@"hidden");
        }];
    });
}

- (void)checkAdShown {
    CDYALLog(@"checkAdShown");
    if (![self isBannerVisible] && !self.loadingAdsDisabled) {
        CDYALLog(@"Banner not visible. Reload");
        [self reloadAds];
    }

    CDYAdLoaderDelayedExecution(self.adCheckTime, ^{
        [self checkAdShown];
    });
}

- (void)hideBanner:(BOOL)animated completion:(CDYAdLoaderBlock)completion {
    CDYALLog(@"hideBanner");

    if (![self isBannerVisible]) {
        CDYALLog(@"Banner not visible. Nothing to hide");
        completion();
        return;
    }

    void (^hideAnimationBlock)() = ^{
        CGRect bannerFrame = [self bannerHiddenFrame];
        [self.presentedBanner setFrame:bannerFrame];

        CGRect contentFrame = self.contentView.frame;
        if (self.bannerAdPosition == AdPositionTop) {
            contentFrame.origin.y -= CGRectGetHeight(bannerFrame);
        }
        contentFrame.size.height += CGRectGetHeight(bannerFrame);
        [self.contentView setFrame:contentFrame];
    };

    void (^hideCompletionBlock)(BOOL finished) = ^(BOOL finished) {
        [self.presentedBanner removeFromSuperview];
        [self setPresentedBanner:nil];
        completion();
    };

    if (!animated) {
        [UIView performWithoutAnimation:hideAnimationBlock];
        hideCompletionBlock(YES);
        return;
    }

    [UIView animateWithDuration:CDYAdLoaderAnimationTime delay:0 options:0 animations:hideAnimationBlock completion:hideCompletionBlock];
}

- (void)showBanner:(BOOL)animated {
    CDYALLog(@"showBanner:%d", animated);
    if ([self isBannerVisible]) {
        CDYALLog(@"Banner already visible");
        return;
    }

    [self.mainView addSubview:self.presentedBanner];
    [self.presentedBanner setFrame:[self bannerHiddenFrame]];
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    if (self.bannerAdPosition == AdPositionTop) {
        autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    } else {
        autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    }
    [self.presentedBanner setAutoresizingMask:autoresizingMask];

    void (^animationBlock)() = ^{
        CGRect bannerFrame = [self bannerVisibleFrame];
        [self.presentedBanner setFrame:bannerFrame];

        CGRect contentFrame = self.contentView.frame;
        if (self.bannerAdPosition == AdPositionTop) {
            contentFrame.origin.y += CGRectGetHeight(bannerFrame);
        }
        contentFrame.size.height -= CGRectGetHeight(bannerFrame);
        [self.contentView setFrame:contentFrame];
    };

    if (!animated) {
        [UIView performWithoutAnimation:animationBlock];
        return;
    }

    [UIView animateWithDuration:CDYAdLoaderAnimationTime delay:0 options:0 animations:animationBlock completion:^(BOOL finished) {

    }];
}

- (void)loadBannerUsingService:(id <CDYAdService>)service {
    CDYALLog(@"loadBannerUsingService:%@", service);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.presentedService setDelegate:nil];
        [self setPresentedService:nil];

        if (self.loadingAdsDisabled) {
            CDYALLog(@"Ads should not be shown");
            return;
        }

        [self setPresentedService:service];
        [service setDelegate:self];
        [service loadBanner];
    });
}

- (void)service:(id <CDYAdService>)service didLoadAdInBanner:(UIView *)banner {
    dispatch_async(dispatch_get_main_queue(), ^{
        CDYALLog(@"didLoadAdInBanner");
        [self setPresentedBanner:banner];
        [self showBanner:YES];
    });
}

- (void)service:(id <CDYAdService>)service loadAdError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        CDYALLog(@"loadAdError:%@", error);
        [self hideBanner:YES completion:^{
            [self loadBannerUsingService:[self nextService]];
        }];
    });
}

- (id <CDYAdService>)nextService {
    if (!self.presentedService) {
        return [self.services firstObject];
    }

    NSUInteger presentedIndex = [self.services indexOfObject:self.presentedService];
    NSUInteger nextIndex = presentedIndex + 1;

    if (nextIndex >= self.services.count) {
        return nil;
    }

    return self.services[nextIndex];
}

- (BOOL)isBannerVisible {
    if (!self.presentedBanner || !self.presentedBanner.superview) {
        return NO;
    }

    CGRect intersection = CGRectIntersection(self.mainView.bounds, self.presentedBanner.frame);
    return CGRectGetHeight(intersection) == CGRectGetHeight(self.presentedBanner.frame);
}

- (CGRect)bannerHiddenFrame {
    CGFloat yOffset = (self.bannerAdPosition == AdPositionTop ? -CGRectGetHeight(self.presentedBanner.frame) : CGRectGetHeight(self.mainView.frame));
    return CGRectOffset(self.presentedBanner.bounds,
            (CGRectGetWidth(self.mainView.bounds) - CGRectGetWidth(self.presentedBanner.frame)) / 2,
            yOffset);
}

- (CGRect)bannerVisibleFrame {
    CGRect bannerFrame = self.presentedBanner.frame;
    if (self.bannerAdPosition == AdPositionTop) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y = CGRectGetHeight(self.mainView.bounds) - CGRectGetHeight(bannerFrame);
    }

    return bannerFrame;
}

@end
