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
#import "WFDetailHeaderView.h"
#import "WFLoadingView.h"

@interface DetailViewController () <UIWebViewDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIBarButtonItem *goBackButton;
@property(nonatomic, strong) UIBarButtonItem *nextButton;
@property(nonatomic, strong) UIButton *votedButton;
@property(nonatomic, strong) UIBarButtonItem *votedBarButton;
@property(nonatomic, strong) UIBarButtonItem *shareButton;
@property(nonatomic, strong) UIButton *commentButton;
@property(nonatomic, strong) UIBarButtonItem *commentBarButton;

@property(nonatomic, strong) StoryDetailDataModel *detailInfo;
@property(nonatomic, strong) StoryDetailExtraDataModel *extraInfo;
@property(nonatomic, strong) WFDetailHeaderView *detailHeaderView;
@property(nonatomic, strong) WFLoadingView *loadingView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.storyDateModel.title;
  [self configUI];
  //[self.view addSubview:self.loadingView];
  [self requestData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)configUI {

  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;

  [self.view addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(20);
    make.bottom.equalTo(self.view);
  }];
  [self configDetailHeaderView];
  self.goBackButton =
      [[UIBarButtonItem alloc] initWithImage:Image(@"detail_Back")
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(goBackPressed:)];
  self.nextButton =
      [[UIBarButtonItem alloc] initWithImage:Image(@"detail_Next")
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(nextPressed:)];
  self.votedButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *votedImg = Image(@"detail_Voted");
  [self.votedButton setImage:votedImg forState:UIControlStateNormal];
  [self.votedButton addTarget:self
                       action:@selector(votedPressed:)
             forControlEvents:UIControlEventTouchUpInside];
  self.votedButton.titleLabel.font = Font_12;
  [self.votedButton setTitleColor:[UIColor ex_mainTextColor]
                         forState:UIControlStateNormal];
  self.votedButton.tintColor = [UIColor lightGrayColor];
  self.votedButton.frame =
      CGRectMake(0, 0, votedImg.size.width, votedImg.size.height);
  self.votedBarButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.votedButton];

  self.shareButton =
      [[UIBarButtonItem alloc] initWithImage:Image(@"detail_Share")
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(sharePressed:)];
  self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *commentImg = Image(@"detail_Comment");
  [self.commentButton setImage:commentImg forState:UIControlStateNormal];
  [self.commentButton addTarget:self
                         action:@selector(commentPressed:)
               forControlEvents:UIControlEventTouchUpInside];
  self.commentButton.titleLabel.font = Font_12;
  [self.commentButton setTitleColor:[UIColor ex_mainTextColor]
                           forState:UIControlStateNormal];
  self.commentButton.tintColor = [UIColor lightGrayColor];
  self.commentButton.frame =
      CGRectMake(0, 0, votedImg.size.width, votedImg.size.height);
  self.commentBarButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.commentButton];
  UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                           target:nil
                           action:nil];
  [self
      setToolbarItems:[NSArray arrayWithObjects:flexItem, self.goBackButton,
                                                flexItem, self.nextButton,
                                                flexItem, self.votedBarButton,
                                                flexItem, self.shareButton,
                                                flexItem, self.commentBarButton,
                                                flexItem, nil]
             animated:YES];
}

- (void)requestData {
  [self showHUD];
  [[ZhihuDataManager shardInstance]
      requestNewsDetail:self.storyDateModel.storyId
      successBlock:^(StoryDetailDataModel *json) {
        _detailInfo = json;
        [self refreshUI];
        [self hideAllHUDs];
      }
      failed:^(NSError *error){

      }];

  [[ZhihuDataManager shardInstance]
      requestNewsDetailExtra:self.storyDateModel.storyId
      successBlock:^(StoryDetailExtraDataModel *json) {
        _extraInfo = json;
        [self refreshUI];
      }
      failed:^(NSError *error){

      }];
}

- (void)refreshUI {

  if (self.detailInfo) {
    NSString *htmlStr = [self generateHtmlWithCss];
    [_webView loadHTMLString:htmlStr baseURL:nil];
    [self refreshDetailHeaderView];
    if (self.extraInfo) {
      [self.votedButton
          setTitle:[NSString stringWithFormat:@"%ld", self.extraInfo.popularity]
          forState:UIControlStateNormal];
      [self.votedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 18, 0)];
      [self.commentButton
          setTitle:[NSString stringWithFormat:@"%ld", self.extraInfo.comments]
          forState:UIControlStateNormal];
      [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 18, 0)];
    }
  }
}

- (void)configDetailHeaderView {
  if (!_detailHeaderView) {
    _detailHeaderView = [[WFDetailHeaderView alloc]
        initWithFrame:CGRectMake(0, -40, kScreenWidth, 260)];
    [self.view addSubview:_detailHeaderView];
    _detailHeaderView.webView = _webView;
  }
}

- (void)refreshDetailHeaderView {

  [_detailHeaderView refreshHeaderView:self.detailInfo];
}

- (NSString *)generateHtmlWithCss {
  NSMutableString *htmlString =
      [[NSMutableString alloc] initWithString:@"<html>"];

  [htmlString appendString:@"<head>"];
  for (NSString *cssName in self.detailInfo.css) {
    [htmlString appendString:@"<link rel =\"stylesheet\" href = \""];
    [htmlString appendString:cssName];
    [htmlString appendString:@"\" type=\"text/css\" />"];
  }

  [htmlString appendString:@"</head>"];
  [htmlString appendString:@"<body>"];
  [htmlString appendString:self.detailInfo.body];
  [htmlString appendString:@"</body>"];
  [htmlString appendString:@"</html>"];
  return htmlString;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (_webView.scrollView.contentOffset.y >= 200) {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];

  } else {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
  }
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.navigationController.toolbarHidden = NO;
                   }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
  self.navigationController.toolbarHidden = YES;
}

- (void)goBackPressed:(id)sender {
}

- (void)nextPressed:(id)sender {
}

- (void)sharePressed:(id)sender {
}

- (void)votedPressed:(id)sender {
}

- (void)commentPressed:(id)sender {
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGFloat offSetY = scrollView.contentOffset.y;

  if (-offSetY <= 80 && -offSetY >= 0) {

    [_detailHeaderView wf_parallaxHeaderViewWithOffset:offSetY];

    if (-offSetY > 40 && !_webView.scrollView.isDragging) {

      //[self getPreviousNews];
    }
  } else if (-offSetY > 80) { //到－80 让webview不再能被拉动

    _webView.scrollView.contentOffset = CGPointMake(0, -80);

  } else if (offSetY <= 300) {

    _detailHeaderView.frame = CGRectMake(0, -40 - offSetY, kScreenWidth, 260);
  }

  if (offSetY + kScreenHeight > scrollView.contentSize.height + 160 &&
      !_webView.scrollView.isDragging) {

    //[self getNextNews];
  }

  if (offSetY >= 200) {

    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];

  } else {

    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
  }
}

#pragma mark - Getter
- (WFLoadingView *)loadingView {

  if (!_loadingView) {
    _loadingView = [[WFLoadingView alloc]
        initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
  }

  return _loadingView;
}
@end
