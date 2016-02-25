//
//  NewsItemCell.h
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "FDTableViewCell.h"
#import "StoryDataModel.h"

@interface NewsItemCellUserData : NSObject
@property(nonatomic, strong) StoryDataModel *storyItem;
@end

@interface NewsItemCell : FDTableViewCell
@property(nonatomic, strong) NewsItemCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
