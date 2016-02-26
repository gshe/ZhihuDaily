//
//  WFDetailHeaderView.h
//  WFZhihuDaily
//
//  Created by xiupintech on 16/1/6.
//  Copyright © 2016年 xiupintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryDetailDataModel.h"
@interface WFDetailHeaderView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *imgSourceLab;
@property(nonatomic, weak) UIWebView *webView;

- (void)refreshHeaderView:(StoryDetailDataModel *)detailStory;

- (void)wf_parallaxHeaderViewWithOffset:(CGFloat)offset;

@end
