//
//  StoryDetailDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface StoryDetailDataModel : JSONModel
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *image_source;
@property(nonatomic, assign) long storyType;
@property(nonatomic, assign) long long storyId;
@property(nonatomic, strong) NSString *ga_prefix;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArray *css;
@property(nonatomic, strong) NSArray *recommenders;
@end
