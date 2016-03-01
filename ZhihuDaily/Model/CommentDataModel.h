//
//  CommentDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol CommentDataModel
@end

@interface CommentDataModel : JSONModel
@property(nonatomic, assign) BOOL own;
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) long long commentId;
@property(nonatomic, assign) BOOL voted;
@property(nonatomic, assign) long likes;
@property(nonatomic, assign) long status;
@property(nonatomic, strong) CommentDataModel *reply_to;

@property(nonatomic, strong) NSString *timeStr;
@end
