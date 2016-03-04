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
#import "RecommendersView.h"
#import "WFToastView.h"
#import "CommentsViewController.h"
#import "ShareToView.h"
#import "ItemDatabase.h"

@interface DetailViewController () <UIWebViewDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIBarButtonItem *goBackButton;
@property(nonatomic, strong) UIBarButtonItem *nextButton;
@property(nonatomic, strong) UIButton *votedButton;
@property(nonatomic, strong) UIBarButtonItem *votedBarButton;
@property(nonatomic, strong) UIBarButtonItem *shareButton;
@property(nonatomic, strong) UIButton *commentButton;
@property(nonatomic, strong) UIBarButtonItem *commentBarButton;
@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) StoryDetailDataModel *detailInfo;
@property(nonatomic, strong) StoryDetailExtraDataModel *extraInfo;
@property(nonatomic, strong) WFDetailHeaderView *detailHeaderView;
@property(nonatomic, strong) WFLoadingView *loadingView;
@property(nonatomic, strong) RecommendersView *recommendersView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.storyDataModel.title;
  [self configUI];
  [self requestData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)configUI {
  self.containerView = [UIView new];
  [self.view addSubview:self.containerView];

  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;

  [self.containerView addSubview:self.webView];
  self.view.backgroundColor = [UIColor whiteColor];

  [self configDetailHeaderView];
  [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  if (self.isShowHeaderView) {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.containerView);
      make.right.equalTo(self.containerView);
      make.top.equalTo(self.containerView).offset(20);
      make.bottom.equalTo(self.containerView);
    }];
  } else {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.containerView);
      make.right.equalTo(self.containerView);
      make.top.equalTo(_recommendersView.mas_bottom);
      make.bottom.equalTo(self.containerView);
    }];
  }
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
  self.votedButton.titleLabel.font = Font_10;
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
  self.commentButton.titleLabel.font = Font_10;
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
  FDWeakSelf;
  [[ZhihuDataManager shardInstance]
      requestNewsDetail:self.storyDataModel.storyId
      successBlock:^(StoryDetailDataModel *json) {
        FDStrongSelf;
        _detailInfo = json;
        [self refreshUI];

        [_loadingView dismissLoadingView];
        _loadingView = nil;
      }
      failed:^(NSError *error) {
        [_loadingView dismissLoadingView];
        _loadingView = nil;
      }];

  [[ZhihuDataManager shardInstance]
      requestNewsDetailExtra:self.storyDataModel.storyId
      successBlock:^(StoryDetailExtraDataModel *json) {
        FDStrongSelf;
        _extraInfo = json;
        [self refreshUI];
      }
      failed:^(NSError *error){

      }];
}

- (void)refreshUI {
  [[ItemDatabase sharedInstance] itemReadByUser:self.storyDataModel.storyId];
  [self refreshToolbarStatus];
  if (self.detailInfo) {
    NSString *htmlStr = [self generateHtmlWithCss];
    [_webView loadHTMLString:htmlStr baseURL:nil];
    [self refreshDetailHeaderView];
    if (self.extraInfo) {
      [self.votedButton
          setTitle:[NSString stringWithFormat:@"%ld", self.extraInfo.popularity]
          forState:UIControlStateNormal];
      [self.votedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 18, 0)];
      [self.commentButton
          setTitle:[NSString stringWithFormat:@"%ld", self.extraInfo.comments]
          forState:UIControlStateNormal];
      [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -48, 18, 0)];
    }
  }
}

- (void)configDetailHeaderView {
  if (self.isShowHeaderView) {
    if (!_detailHeaderView) {
      _detailHeaderView = [[WFDetailHeaderView alloc]
          initWithFrame:CGRectMake(0, -40, kScreenWidth, 260)];
      [self.containerView addSubview:_detailHeaderView];
    }
  } else {
    if (!_recommendersView) {
      _recommendersView = [[RecommendersView alloc]
          initWithFrame:CGRectMake(0, 20, kScreenWidth, 56)];
      [self.containerView addSubview:_recommendersView];
    }
  }
}

- (void)refreshDetailHeaderView {
  if (self.isShowHeaderView) {
    [_detailHeaderView refreshHeaderView:self.detailInfo];
  } else {
    _recommendersView.recommenders = self.detailInfo.recommenders;
  }
}

- (NSString *)generateHtmlWithCss {
  if (self.detailInfo.body) {
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
  } else {
    return nil;
  }
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
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPressed:(id)sender {
  [self getNextNews];
}

- (void)sharePressed:(id)sender {
  ShareToView *shartView = [[ShareToView alloc] initWithFrame:CGRectZero];
  shartView.shareToClicked = ^(SharePlatform shareType, NSString *name) {
    NSString *title = [NSString stringWithFormat:@"已分享！%@", name];
    [[WFToastView class] showMsg:title inView:nil];
  };
  [shartView show];
}

- (void)votedPressed:(id)sender {
  [[ZhihuDataManager shardInstance] voteNews:self.storyDataModel.storyId
      successBlock:^(id json) {
        [[WFToastView class] showMsg:@"已赞！" inView:nil];
      }
      failed:^(NSError *error) {
        [[WFToastView class] showMsg:@"点赞失败！" inView:nil];
      }];
}

- (void)commentPressed:(id)sender {
  CommentsViewController *commentVC =
      [[CommentsViewController alloc] initWithNibName:nil bundle:nil];
  commentVC.storyItem = self.storyDataModel;
  [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)getNextNews {
  FDWeakSelf;
  [UIView animateWithDuration:0.25
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        self.containerView.frame =
            CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
      }
      completion:^(BOOL finished) {
        FDStrongSelf;
        [self.view insertSubview:self.loadingView belowSubview:self.webView];
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
              self.containerView.frame =
                  CGRectMake(0, 0, kScreenWidth, kScreenHeight);
              NSUInteger index =
                  [self.storyDataList indexOfObject:self.storyDataModel];
              if (index < self.storyDataList.count - 1) {
                self.storyDataModel = self.storyDataList[index + 1];
                self.detailInfo = nil;
                self.extraInfo = nil;
              }
              [self requestData];
            });

      }];
}

- (void)getPreviousNews {
  FDWeakSelf;
  [UIView animateWithDuration:0.25
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        self.containerView.frame =
            CGRectMake(0, kScreenHeight + 40, kScreenWidth, kScreenHeight);
      }
      completion:^(BOOL finished) {
        FDStrongSelf;
        [self.view insertSubview:self.loadingView belowSubview:self.webView];
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
              self.containerView.frame =
                  CGRectMake(0, 0, kScreenWidth, kScreenHeight);
              NSUInteger index =
                  [self.storyDataList indexOfObject:self.storyDataModel];
              if (index > 0 && index < self.storyDataList.count) {
                self.storyDataModel = self.storyDataList[index - 1];
                self.detailInfo = nil;
                self.extraInfo = nil;
              }
              [self requestData];
            });

      }];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    FDWebViewController *webVC =
        [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.title = self.storyDataModel.title;
    webVC.urlString = request.URL.absoluteString;
    [self.navigationController pushViewController:webVC animated:YES];
    return NO;
  }
  return YES;
}

- (void)refreshToolbarStatus {
  NSUInteger index = [self.storyDataList indexOfObject:self.storyDataModel];
  if (index == self.storyDataList.count - 1) {
    self.nextButton.enabled = NO;
  } else {
    self.nextButton.enabled = YES;
  }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGFloat offSetY = scrollView.contentOffset.y;

  if (-offSetY <= 80 && -offSetY >= 0) {

    [_detailHeaderView wf_parallaxHeaderViewWithOffset:offSetY];

    if (-offSetY > 40 && !_webView.scrollView.isDragging) {

      [self getPreviousNews];
    }
  } else if (-offSetY > 80) { //到－80 让webview不再能被拉动

    _webView.scrollView.contentOffset = CGPointMake(0, -80);

  } else if (offSetY <= 300) {

    _detailHeaderView.frame = CGRectMake(0, -40 - offSetY, kScreenWidth, 260);
  }

  if (offSetY + kScreenHeight > scrollView.contentSize.height + 160 &&
      !_webView.scrollView.isDragging) {

    [self getNextNews];
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
