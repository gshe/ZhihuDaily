//
//  ChannelItemCell.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
#import "ChannelItemDataModel.h"

@interface ChannelItemCellUserData : NSObject
@property(nonatomic, strong) ChannelItemDataModel *channelItem;
@end

@interface ChannelItemCell : FDTableViewCell
@property(nonatomic, strong) ChannelItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
