//
//  LoginViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property(nonatomic, strong) UIButton *sinaWeiboLogin;
@property(nonatomic, strong) UIButton *tencentWeiboLogin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(closeVC:)];
  self.title = @"用户登录";
  [self configUI];
}

- (void)configUI {
  self.view.backgroundColor = [UIColor ex_blueTextColor];
  UILabel *loginMessage = [UILabel new];
  loginMessage.text = @"使用微博登录";
  loginMessage.textColor = [UIColor whiteColor];
  [self.view addSubview:loginMessage];
  UILabel *notifyMessage = [UILabel new];
  notifyMessage.text = @"知" @"乎"
      @"日报不会未经同意通过你的微博账号发布任何信息";
  notifyMessage.font = Font_10;
  [self.view addSubview:notifyMessage];
  UIImageView *logoView = [[UIImageView alloc] init];
  logoView.layer.cornerRadius = 4;
  logoView.image = [UIImage imageNamed:@"about"];
  [self.view addSubview:logoView];

  _sinaWeiboLogin = [UIButton buttonWithType:UIButtonTypeCustom];
  _sinaWeiboLogin.backgroundColor = [UIColor ex_separatorLineColor];
  _sinaWeiboLogin.layer.cornerRadius = 4;
  [_sinaWeiboLogin setTitleColor:[UIColor ex_subTextColor]
                        forState:UIControlStateNormal];
  [_sinaWeiboLogin setTitle:@"新浪微博" forState:UIControlStateNormal];
  [self.view addSubview:_sinaWeiboLogin];
  _tencentWeiboLogin = [UIButton buttonWithType:UIButtonTypeCustom];
  _tencentWeiboLogin.layer.cornerRadius = 4;
  [_tencentWeiboLogin setTitle:@"新浪微博" forState:UIControlStateNormal];
  _tencentWeiboLogin.backgroundColor = [UIColor ex_separatorLineColor];
  [_tencentWeiboLogin setTitleColor:[UIColor ex_subTextColor]
                           forState:UIControlStateNormal];
  [self.view addSubview:_tencentWeiboLogin];
  [_sinaWeiboLogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(_tencentWeiboLogin.mas_top).offset(-10);
    make.width.mas_equalTo(260);
    make.height.mas_equalTo(45);
  }];

  [_tencentWeiboLogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-60);
    make.width.mas_equalTo(260);
    make.height.mas_equalTo(45);
  }];

  [loginMessage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(_sinaWeiboLogin.mas_top).offset(-15);
  }];

  [notifyMessage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-10);
  }];

  [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(100);
    make.width.mas_equalTo(200);
    make.height.mas_equalTo(76);
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)closeVC:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

@end
