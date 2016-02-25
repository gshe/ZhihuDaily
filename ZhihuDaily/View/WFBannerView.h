//
//  WFBannerView.h
//  WFZhihuDaily
//
//  Created by xiupintech on 16/1/6.
//  Copyright © 2016年 xiupintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerStoryDataModel.h"

/**
 *  banner视图
 */
@interface WFBannerView : UIImageView

@property(nonatomic, strong) BannerStoryDataModel *banner;

@property(nonatomic, copy) void (^clickBannerCallBackBlock)
    (BannerStoryDataModel *banner);

@property(nonatomic, strong) UILabel *bannerTitleLbl;

@property(nonatomic, assign) CGFloat offsetY;

@property(nonatomic, assign) CGFloat titleAlpha;

@end
