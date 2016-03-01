//
//  ShareToView.m
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ShareToView.h"

NSString *const WFSharePlatformWeChat = @"微信好友";
NSString *const WFSharePlatformWeChatFriends = @"微信朋友圈";
NSString *const WFSharePlatformSinaWeibo = @"新浪微博";
NSString *const WFSharePlatformQQ = @"QQ";
NSString *const WFSharePlatformMail = @"邮件";
NSString *const WFSharePlatformNULL = @"NULL";
NSString *const WFSharePlatformCopyLink = @"复制链接";
NSString *const WFSharePlatformYouDao = @"有道云笔记";    // 有道云
NSString *const WFSharePlatformYinXiang = @"印象笔记";     //印象笔记
NSString *const WFSharePlatformTencentWeibo = @"腾讯微博"; //腾讯微博
NSString *const WFSharePlatformMessage = @"信息";            //信息
NSString *const WFSharePlatformInstapaper = @"Instapaper";     // Instapaper
NSString *const WFSharePlatformTwitter = @"推特";            //推特
NSString *const WFSharePlatformRenRen = @"人人";             //人人

@interface ShareToView () <UIScrollViewDelegate>
@property(nonatomic, strong) NSDictionary *platformDict;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ShareToView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _platformDict = @{
      WFSharePlatformWeChat : @[ @(SharePlatformWeChat), @"weChat" ],
      WFSharePlatformWeChatFriends :
          @[ @(SharePlatformWeChatFriends), @"weChaFriend" ],
      WFSharePlatformSinaWeibo : @[ @(SharePlatformSinaWeibo), @"sinaWeiBo" ],
      WFSharePlatformQQ : @[ @(SharePlatformQQ), @"QQ" ],
      WFSharePlatformCopyLink : @[ @(SharePlatformCopyLink), @"copyLink" ],
      WFSharePlatformYouDao : @[ @(SharePlatformYouDao), @"youDao" ],
      WFSharePlatformYinXiang : @[ @(SharePlatformYinXiang), @"yinXiang" ],
      WFSharePlatformTencentWeibo :
          @[ @(SharePlatformTencentWeibo), @"tencentWeiBo" ],
      WFSharePlatformMessage : @[ @(SharePlatformMessage), @"message" ],
      WFSharePlatformInstapaper :
          @[ @(SharePlatformInstapaper), @"instapaper" ],
      WFSharePlatformTwitter : @[ @(SharePlatformTwitter), @"twitter" ],
      WFSharePlatformRenRen : @[ @(SharePlatformRenRen), @"renRen" ],
      WFSharePlatformMail : @[ @(SharePlatformMail), @"mail" ]
    };
    [self addEvent];
    [self configUI];
  }
  return self;
}

- (void)configUI {
  self.contentView = [UIView new];
  self.contentView.backgroundColor = RGBColor(233, 233, 233, 1);
  self.contentView.layer.cornerRadius = 4;
  [self addSubview:self.contentView];
  UILabel *shartToMessage = [UILabel new];
  shartToMessage.text = @"分享这篇内容";
  shartToMessage.font = Font_15_B;
  [self.contentView addSubview:shartToMessage];
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.directionalLockEnabled = YES;
  _scrollView.pagingEnabled = YES;
  [self.contentView addSubview:_scrollView];

  _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
  _pageControl.enabled = NO;
  _pageControl.currentPage = 0;
  [self.contentView addSubview:_pageControl];

  UIButton *cancelButton = [UIButton new];
  cancelButton.backgroundColor = [UIColor whiteColor];
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  [cancelButton setTitleColor:[UIColor ex_subTextColor]
                     forState:UIControlStateNormal];
  [cancelButton addTarget:self
                   action:@selector(cancelButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
  UIButton *favButton = [UIButton new];
  favButton.backgroundColor = [UIColor whiteColor];
  [favButton setTitle:@"收藏" forState:UIControlStateNormal];
  [favButton setTitleColor:[UIColor ex_subTextColor]
                  forState:UIControlStateNormal];
  [favButton addTarget:self
                action:@selector(favButtonPressed:)
      forControlEvents:UIControlEventTouchUpInside];

  [self.contentView addSubview:favButton];
  [self.contentView addSubview:cancelButton];

  [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView);
    make.top.equalTo(shartToMessage.mas_bottom).offset(10);
    make.width.equalTo(self.contentView);
    make.height.mas_equalTo(160);
  }];

  [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_scrollView.mas_bottom).offset(10);
    make.centerX.equalTo(self.contentView);
    make.width.mas_equalTo(50);
    make.height.mas_equalTo(20);
  }];

  [shartToMessage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView);
    make.top.equalTo(self.contentView).offset(5);
  }];

  [favButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.right.equalTo(self.contentView).offset(-15);
    make.height.mas_equalTo(44);
    make.bottom.equalTo(cancelButton.mas_top).offset(-15);

  }];
  [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.right.equalTo(self.contentView).offset(-15);
    make.height.mas_equalTo(44);
    make.bottom.equalTo(self.contentView).offset(-15);
  }];
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self);
    make.right.equalTo(self);
    make.height.mas_equalTo(345);
    make.bottom.equalTo(self);
  }];
  [self configShareButtons];
}

- (void)configShareButtons {
  _scrollView.contentSize =
      CGSizeMake(kScreenWidth * (_platformDict.count / 8 + 1), 160);
  _pageControl.numberOfPages = (_platformDict.count / 8 + 1);

  CGFloat offset = (kScreenWidth - 30 - 65 * 4) / 3;
  NSArray *keys = [_platformDict allKeys];
  for (NSInteger index = 0; index < keys.count; index++) {
    NSInteger curPage = index / 8;
    NSArray *shareBtnInfo = _platformDict[keys[index]];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:Image(shareBtnInfo[1]) forState:UIControlStateNormal];
    NSNumber *shareType = shareBtnInfo[0];
    shareButton.tag = shareType.integerValue;
    [shareButton addTarget:self
                    action:@selector(shareButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
      if (index % 8 >= 4) {
        make.top.equalTo(_scrollView.mas_bottom).offset(80);
      } else {
        make.top.equalTo(_scrollView.mas_bottom);
      }

      make.left.equalTo(self.scrollView)
          .offset(kScreenWidth * curPage + 15 + (index % 4) * (offset + 65));
      make.width.mas_equalTo(65);
      make.height.mas_equalTo(80);
    }];
  }
}

- (void)cancelButtonPressed:(id)sender {
  [self dismiss];
}

- (void)favButtonPressed:(id)sender {
  [self dismiss];
}

- (void)shareButtonClicked:(id)sender {
  if (self.shareToClicked) {
    UIButton *btn = (UIButton *)sender;
    self.shareToClicked(btn.tag, [self getShareTypeName:btn.tag]);
  }
  [self dismiss];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  _pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

- (NSString *)getShareTypeName:(SharePlatform)shareType {
  NSArray *keys = [_platformDict allKeys];
  for (NSInteger index = 0; index < keys.count; index++) {
    NSArray *shareBtnInfo = _platformDict[keys[index]];
    NSNumber *shareTypeNumber = shareBtnInfo[0];
                if (shareTypeNumber.integerValue == shareType){
			return keys[index];
		}
	}
	return nil;
}

@end
