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

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "ObjectModel.h"
#import "MainViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Constants.h"
#import "TasksListViewController.h"
#import "EntriesSyncService.h"
#import "ObjectModel+TimeEntries.h"
#import "RMStore.h"
#import "RMStoreAppReceiptVerificator.h"
#import "RMStoreKeychainPersistence.h"
#import "UIColor+Theme.h"
#import "CDYAdLoader.h"
#import "CDYIAdLoader.h"
#import "CDYAdMobLoader.h"
#import "Secrets.h"
#import "GADRequest.h"

@interface AppDelegate ()

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) EntriesSyncService *entriesSync;
@property (nonatomic, strong) RMStoreAppReceiptVerificator *verificator;
@property (nonatomic, strong) RMStoreKeychainPersistence *persistence;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if DEBUG
    UITapGestureRecognizer *toggleHistoryRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTransactions)];
    [toggleHistoryRecognizer setNumberOfTapsRequired:2];
    [toggleHistoryRecognizer setNumberOfTouchesRequired:3];
    [toggleHistoryRecognizer setCancelsTouchesInView:NO];
    [self.window addGestureRecognizer:toggleHistoryRecognizer];
#endif

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [self setVerificator:[[RMStoreAppReceiptVerificator alloc] init]];
    [self.verificator setBundleIdentifier:@"com.coodly.mtimer"];
    //TODO jaanus: think something with bundle version
    [[RMStore defaultStore] setReceiptVerificator:self.verificator];
    [self setPersistence:[[RMStoreKeychainPersistence alloc] init]];
    [[RMStore defaultStore] setTransactionPersistor:self.persistence];

    [Fabric with:@[[Crashlytics class]]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];

    MainViewController *controller = [[MainViewController alloc] init];
    [self setMainViewController:controller];
    [controller setObjectModel:model];
    [self.window setRootViewController:controller];

#if SHOW_ADS
    [[CDYAdLoader sharedInstance] addService:[[CDYIAdLoader alloc] init]];
    CDYAdMobLoader *adMobLoader = [[CDYAdMobLoader alloc] initWithAdMobUnit:TimerAdMobUnit];
    [adMobLoader setRootViewController:controller];
#if DEBUG
    [adMobLoader setTesting:YES];
    [adMobLoader setTestDevices:@[@"4c330763bc5b214c8bd93a3b8f68f9db", GAD_SIMULATOR_ID]];
#endif
    [[CDYAdLoader sharedInstance] addService:adMobLoader];
#endif

    [[CDYAdLoader sharedInstance] setBannerAdPosition:AdPositionBottom];
    [[CDYAdLoader sharedInstance] setAdCheckTime:TimerAdCheckTimeSeconds];

    EntriesSyncService *service = [[EntriesSyncService alloc] initWithObjectModel:model];
    [self setEntriesSync:service];

    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];

#if DEBUG
    [self redirectLogToFile];
#endif

    return YES;
}

#if DEBUG
- (void)removeTransactions {
    TimerLog(@"Remove transactions");
    [((RMStoreKeychainPersistence *)[RMStore defaultStore].transactionPersistor) removeTransactions];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimerCheckFullHistoryStatus object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimerCheckShowAddStatus object:nil];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    TimerLog(@"applicationDidEnterBackground");
    NSUInteger numberOfRunning = [self.objectModel numberOfRunningEntries];
    [application setApplicationIconBadgeNumber:numberOfRunning];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    TimerLog(@"applicationDidBecomeActive");
    [self.mainViewController.tasksListViewController checkForRunningEntries];
    [self.entriesSync checkStatusesToPush];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimerCheckShowAddStatus object:nil];
    [[CDYAdLoader sharedInstance] reloadAds];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.objectModel saveContext];
}

- (void)redirectLogToFile {
#if !TARGET_IPHONE_SIMULATOR
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = allPaths[0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fileName = [NSString stringWithFormat:@"%@-console.txt", [dateFormatter stringFromDate:[NSDate date]]];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:fileName];

    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
#endif
}

@end
