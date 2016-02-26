//
//  StoryDetailDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//image_source: "Yestone.com 版权图片库",
//title: "只要在游戏里花过一次钱，你就已经感染这种「病毒」了",
//image: "http://pic4.zhimg.com/8fe60eb8017f02d99ccbf22cb0dba3bf.jpg",
//share_url: "http://daily.zhihu.com/story/7911560",
//js: [ ],
//ga_prefix: "022407",
//type: 0,
//id: 7911560,
@interface StoryDetailDataModel : JSONModel
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *image_source;
@property(nonatomic, assign) long storyType;
@property(nonatomic, assign) long long storyId;
@property(nonatomic, strong) NSString *ga_prefix;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArray *css;
@end
