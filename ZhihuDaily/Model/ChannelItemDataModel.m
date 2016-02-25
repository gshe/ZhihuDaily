//
//  ChannelItemDataModel.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ChannelItemDataModel.h"

@implementation ChannelItemDataModel
- (instancetype)initWithChannelId:(NSInteger)channleId
                             name:(NSString *)channelName
                               vc:(UIViewController *)channelVC
                         selected:(BOOL)isSelected {
  self = [super init];
  if (self) {
    _channleId = channleId;
    _channelName = channelName;
    _channelVC = channelVC;
    _isSelected = isSelected;
  }
  return self;
}
@end
