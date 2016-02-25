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
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _containerController = [UIViewController new];
  _containerController.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_containerController.view];

  [self showSelectedViewController];
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

  UIViewController *selectedVC = nil;
  for (BaseViewController *vc in _controllers) {

    if (vc.channleModel.isSelected) {
      selectedVC = vc;
      break;
    }
  }

  [_containerController addChildViewController:selectedVC];
  [_containerController.view addSubview:selectedVC.view];

  selectedVC.view.alpha = 0.f;
  [UIView animateWithDuration:0.4f
      animations:^{
        selectedVC.view.alpha = 1.0f;
      }
      completion:^(BOOL finished) {
        _currentViewController = selectedVC;
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
