//
//  WFBannerView.h
//  WFZhihuDaily
//
//  Created by xiupintech on 16/1/6.
//  Copyright © 2016年 xiupintech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  banner视图
 */
@interface BannerView : UIImageView

@property(nonatomic, strong) StoryDataModel *banner;

@property(nonatomic, copy) void (^clickBannerCallBackBlock)
    (StoryDataModel *banner);

@property(nonatomic, strong) UILabel *bannerTitleLbl;

@property(nonatomic, assign) CGFloat offsetY;

@property(nonatomic, assign) CGFloat titleAlpha;

@end
