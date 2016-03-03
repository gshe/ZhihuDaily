//
//  ChannelItemDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeDataModel.h"
@interface ChannelItemDataModel : NSObject
- (instancetype)initWithInfo:(ThemeDataModel *)themeInfo
                          vc:(UIViewController *)channelVC
                    selected:(BOOL)isSelected;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL isSubscribed;
@property(nonatomic, strong) ThemeDataModel *themeInfo;
@property(nonatomic, weak) UIViewController *channelVC;
@end
