//
//  FDWebViewController.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface FDWebViewController () <UIWebViewDelegate,
                                   NJKWebViewProgressDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NJKWebViewProgress *progressProxy;
@property(nonatomic, strong) NJKWebViewProgressView *progressView;
@end

@implementation FDWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.webView = [[UIWebView alloc] init];

  _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
  self.webView.delegate = _progressProxy;
  _progressProxy.webViewProxyDelegate = self;
  _progressProxy.progressDelegate = self;
  _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectZero];

  [self.view addSubview:self.webView];
  [self.view addSubview:_progressView];
  self.view.backgroundColor = [UIColor whiteColor];
  [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.height.mas_equalTo(2);
  }];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(_progressView.mas_bottom);
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

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress
         updateProgress:(float)progress {
  if (progress == NJKFinalProgressValue) {
    _progressView.hidden = YES;
  } else {
    [_progressView setProgress:progress animated:NO];
  }
}
@end
