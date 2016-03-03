//
//  MainViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomePageViewController.h"
#import "ChannelItemDataModel.h"
#import "ThemeListDataModel.h"
#import "ChannelCommonViewController.h"

@interface MainViewController ()
@property(nonatomic, strong) UIViewController *currentViewController;
@property(nonatomic, strong) UIViewController *containerController;
@property(nonatomic, strong) NSMutableArray *controllers;
@property(nonatomic, strong) NSMutableArray *naviControllers;
@property(nonatomic, strong) ThemeListDataModel *allThemes;
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _naviControllers = [NSMutableArray array];
  _controllers = [NSMutableArray array];

  ThemeDataModel *homeTheme = [[ThemeDataModel alloc] init];
  homeTheme.name = @"首页";
  HomePageViewController *homeVC =
      [[HomePageViewController alloc] initWithNibName:nil bundle:nil];
  homeVC.channleModel = [[ChannelItemDataModel alloc] initWithInfo:homeTheme
                                                                vc:homeVC
                                                          selected:YES];
  [_controllers addObject:homeVC];

  UINavigationController *naviVC =
      [[UINavigationController alloc] initWithRootViewController:homeVC];
  [_naviControllers addObject:naviVC];

  _containerController = [UIViewController new];
  _containerController.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_containerController.view];

  self.leftViewController.controllers = _controllers;

  [self showSelectedViewController];
  [self requestChannels];
}

- (void)requestChannels {
  FDWeakSelf;
  [[ZhihuDataManager shardInstance]
      requestChannelsWithSuccessBlock:^(ThemeListDataModel *json) {
        FDStrongSelf;
        _allThemes = json;
        [self refreshTheme];
      }
      failed:^(NSError *error){

      }];
}

- (void)refreshTheme {
  for (ThemeDataModel *theme in _allThemes.subscribed) {
    ChannelCommonViewController *themeVC =
        [[ChannelCommonViewController alloc] initWithNibName:nil bundle:nil];
    themeVC.channleModel = [[ChannelItemDataModel alloc] initWithInfo:theme
                                                                   vc:themeVC
                                                             selected:NO];
    themeVC.channleModel.isSubscribed = YES;
    [_controllers addObject:themeVC];

    UINavigationController *naviVC =
        [[UINavigationController alloc] initWithRootViewController:themeVC];
    [_naviControllers addObject:naviVC];
  }

  for (ThemeDataModel *theme in _allThemes.others) {
    ChannelCommonViewController *themeVC =
        [[ChannelCommonViewController alloc] initWithNibName:nil bundle:nil];
    themeVC.channleModel = [[ChannelItemDataModel alloc] initWithInfo:theme
                                                                   vc:themeVC
                                                             selected:NO];
    themeVC.channleModel.isSubscribed = NO;
    [_controllers addObject:themeVC];

    UINavigationController *naviVC =
        [[UINavigationController alloc] initWithRootViewController:themeVC];
    [_naviControllers addObject:naviVC];
  }
  self.leftViewController.controllers = _controllers;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma LeftDrawerViewControllerDelegate
- (void)channelSelected:(BaseViewController *)channelVC {
  [self.mm_drawerController closeDrawerAnimated:YES
                                     completion:^(BOOL finished) {
                                       [self showSelectedViewController];
                                     }];
}

- (void)showSelectedViewController {
  if (_currentViewController != nil) { //如果不为nil移除最上面的视图控制器
    [_currentViewController.view removeFromSuperview];
    [_currentViewController removeFromParentViewController];
  }

  NSInteger index = 0;
  for (; index < _controllers.count; index++) {
    BaseViewController *baseVC = _controllers[index];
    if (baseVC.channleModel.isSelected) {

      break;
    }
  }
  if (index >= _controllers.count) {
    index = 0;
  }
  UIViewController *selectedNaviVC = _naviControllers[index];

  [_containerController addChildViewController:selectedNaviVC];
  [_containerController.view addSubview:selectedNaviVC.view];

  selectedNaviVC.view.alpha = 0.f;
  [UIView animateWithDuration:0.4f
      animations:^{
        selectedNaviVC.view.alpha = 1.0f;
      }
      completion:^(BOOL finished) {
        _currentViewController = selectedNaviVC;
      }];
}

- (BOOL)isLeftDrawerShow {
  return self.mm_drawerController.openSide == MMDrawerSideLeft;
}

- (void)showLeftDrawer {
  [self.mm_drawerController openDrawerSide:MMDrawerSideLeft
                                  animated:YES
                                completion:nil];
}

- (void)hideLeftDrawer {
  [self.mm_drawerController closeDrawerAnimated:YES
                                     completion:^(BOOL finished){

                                     }];
}
@end
