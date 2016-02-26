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

@interface MainViewController ()
@property(nonatomic, strong) UIViewController *currentViewController;
@property(nonatomic, strong) UIViewController *containerController;
@property(nonatomic, strong) NSMutableArray *naviControllers;
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self createMapToNavi];
  _containerController = [UIViewController new];
  _containerController.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_containerController.view];

  [self showSelectedViewController];
}

- (void)createMapToNavi {
  _naviControllers = [NSMutableArray array];
  for (BaseViewController *vc in _controllers) {
    UINavigationController *naviVC =
        [[UINavigationController alloc] initWithRootViewController:vc];
    [_naviControllers addObject:naviVC];
  }
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
