//
//  CommentsListDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CommentDataModel.h"

@interface CommentsListDataModel : JSONModel
@property(nonatomic, strong) NSArray<CommentDataModel> *comments;
@end
