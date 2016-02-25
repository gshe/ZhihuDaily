//
//  LaunchViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LaunchViewController.h"
#import "LaunchDataModel.h"

@interface LaunchViewController ()
@property(nonatomic, strong) UIImageView *firstImage;
@property(nonatomic, strong) UIImageView *secondImage;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configUI];
  [self requestLaunchImage];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)configUI {
  _secondImage = [[UIImageView alloc] initWithFrame:kScreenBounds];
  _secondImage.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:_secondImage];

  _firstImage = [[UIImageView alloc] initWithFrame:kScreenBounds];
  _firstImage.contentMode = UIViewContentModeScaleAspectFill;
  _firstImage.image = Image(@"Default");
  [self.view addSubview:_firstImage];
}

- (void)requestLaunchImage {
  [[ZhihuDataManager shardInstance]
      requestLaunchImage:^(LaunchDataModel *json) {
        [_secondImage sd_setImageWithURL:[NSURL URLWithString:json.img]
                        placeholderImage:nil];
        [UIView animateWithDuration:2.0
            animations:^{
              _firstImage.alpha = 0;
              _secondImage.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            }
            completion:^(BOOL finished) {
              [_secondImage removeFromSuperview];
              [_firstImage removeFromSuperview];
              [self.view removeFromSuperview];
            }];
      }
      failed:^(NSError *error) {
        [_secondImage removeFromSuperview];
        [_firstImage removeFromSuperview];
        [self.view removeFromSuperview];
      }];
}

@end
