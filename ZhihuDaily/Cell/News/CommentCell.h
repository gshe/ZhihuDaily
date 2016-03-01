//
//  CommentCell.h
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
#import "CommentDataModel.h"

@interface CommentCellUserData : NSObject
@property(nonatomic, strong) CommentDataModel *commentItem;
@end

@interface CommentCell : FDTableViewCell
@property(nonatomic, strong) CommentCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
