//
//  DetailViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "DetailViewController.h"
#import "StoryDetailDataModel.h"
#import "StoryDetailExtraDataModel.h"
#import "FDWebViewController.h"

@interface DetailViewController () <UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIBarButtonItem *goBackButton;
@property(nonatomic, strong) UIBarButtonItem *goForwardButton;
@property(nonatomic, strong) UIBarButtonItem *refreshButton;
@property(nonatomic, strong) UIBarButtonItem *stopButton;

@property(nonatomic, strong) StoryDetailDataModel *detailInfo;
@property(nonatomic, strong) StoryDetailExtraDataModel *extraInfo;
@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.storyDateModel.title;
  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(onClose:)];

  [self.view addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];

  self.goBackButton = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"Browser_Icon_Backward"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(goBackPressed:)];
  self.goForwardButton = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"Browser_Icon_Forward"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(goForwardPressed:)];
  self.refreshButton = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"Browser_Icon_Refresh"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(refreshPressed:)];
  self.stopButton = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"Browser_close"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(stopPressed:)];
  UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                           target:nil
                           action:nil];
  [self
      setToolbarItems:[NSArray arrayWithObjects:flexItem, self.goBackButton,
                                                flexItem, self.goForwardButton,
                                                flexItem, self.refreshButton,
                                                flexItem, self.stopButton,
                                                flexItem, nil]
             animated:YES];

  [self requestData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)requestData {
  [self showHUD];
  [[ZhihuDataManager shardInstance]
      requestNewsDetail:self.storyDateModel.storyId
      successBlock:^(StoryDetailDataModel *json) {
        _detailInfo = json;
        [self configUI];
        [self hideAllHUDs];
      }
      failed:^(NSError *error){

      }];

  [[ZhihuDataManager shardInstance]
      requestNewsDetailExtra:self.storyDateModel.storyId
      successBlock:^(StoryDetailExtraDataModel *json) {
        _extraInfo = json;
        [self configUI];
      }
      failed:^(NSError *error){

      }];
}

- (void)configUI {
  if (self.detailInfo) {
    [_webView loadHTMLString:self.detailInfo.body baseURL:nil];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.navigationController.toolbarHidden = NO;
                   }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
  self.navigationController.toolbarHidden = YES;
}

- (void)goBackPressed:(id)sender {
}

- (void)goForwardPressed:(id)sender {
}

- (void)refreshPressed:(id)sender {
}

- (void)stopPressed:(id)sender {
}

- (void)onClose:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    FDWebViewController *webVC =
        [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.title = self.storyDateModel.title;
    webVC.urlString = request.URL.absoluteString;
    [self.navigationController pushViewController:webVC animated:YES];
    return NO;
  }
  return YES;
}
@end
