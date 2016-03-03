//
//  AppDelegate.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "LeftDrawerViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#include "LaunchViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIViewController *)getRootViewController {
  MainViewController *mainVC =
      [[MainViewController alloc] initWithNibName:nil bundle:nil];

  LeftDrawerViewController *leftVC =
      [[LeftDrawerViewController alloc] initWithNibName:nil bundle:nil];
  mainVC.leftViewController = leftVC;
  leftVC.delegate = mainVC;
  MMDrawerController *drawerController =
      [[MMDrawerController alloc] initWithCenterViewController:mainVC
                                      leftDrawerViewController:leftVC];
  [drawerController setShowsShadow:YES];
  [drawerController setRestorationIdentifier:@"MMDrawer2"];
  [drawerController setMaximumLeftDrawerWidth:200];
  [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
  [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
  [drawerController
      setDrawerVisualStateBlock:^(MMDrawerController *drawerController,
                                  MMDrawerSide drawerSide,
                                  CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
            drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
          block(drawerController, drawerSide, percentVisible);
        }
      }];

  return drawerController;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSURLCache *cache =
      [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                    diskCapacity:100 * 1024 * 1024
                                        diskPath:nil];
  [NSURLCache setSharedURLCache:cache];

  // AFNetworking
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

  [[UINavigationBar appearance]
      setBackgroundColor:[UIColor colorWithRed:236 / 255.0
                                         green:190 / 255.0
                                          blue:146 / 255.0
                                         alpha:0.9]];
  UIViewController *rootVC = [self getRootViewController];
  self.window.rootViewController = rootVC;
  [self.window makeKeyAndVisible];
  [XWindowStack pushWindow:self.window];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
  [self launchScreen];
  return YES;
}

- (void)launchScreen {
  LaunchViewController *launchVC =
      [[LaunchViewController alloc] initWithNibName:nil bundle:nil];
  [self.window addSubview:launchVC.view];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
