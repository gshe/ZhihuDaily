//
//  MainViewController.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftDrawerViewController.h"

@interface MainViewController
    : UIViewController <LeftDrawerViewControllerDelegate>
@property(nonatomic, strong) LeftDrawerViewController *leftViewController;

@end
