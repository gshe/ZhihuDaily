//
//  StoryDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol StoryDataModel
@end

@interface StoryDataModel : JSONModel
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, assign) long storyType;
@property(nonatomic, assign) long long storyId;
@property(nonatomic, strong) NSString *ga_prefix;
@property(nonatomic, strong) NSString *title;
@end
