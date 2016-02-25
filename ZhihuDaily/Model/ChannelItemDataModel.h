//
//  ChannelItemDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelItemDataModel : NSObject
- (instancetype)initWithChannelId:(NSInteger)channleId
                             name:(NSString *)channelName
                               vc:(UIViewController *)channelVC
                         selected:(BOOL)isSelected;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) NSInteger channleId;
@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, weak) UIViewController *channelVC;
@end
