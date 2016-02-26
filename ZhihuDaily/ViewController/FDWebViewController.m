//
//  FDWebViewController.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDWebViewController.h"
@interface FDWebViewController ()
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation FDWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.webView = [[UIWebView alloc] init];

  [self.view addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSURLRequest *request =
      [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
  [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
}
@end
