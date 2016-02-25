//
//  StoryExtraDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StoryDetailExtraDataModel : JSONModel
@property(nonatomic, assign) NSInteger post_reasonn;
@property(nonatomic, assign) NSInteger long_comments;
@property(nonatomic, assign) NSInteger popularity;
@property(nonatomic, assign) NSInteger normal_comments;
@property(nonatomic, assign) NSInteger comments;
@property(nonatomic, assign) NSInteger short_comments;
@end
