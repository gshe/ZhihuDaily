//
//  StoryListDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "StoryDataModel.h"
#import "EditorDataModel.h"

@interface StoryListDataModel : JSONModel
@property(nonatomic, strong) NSArray<StoryDataModel> *stories;
@property(nonatomic, strong) NSArray<StoryDataModel> *top_stories;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSArray<EditorDataModel> *editors;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *background;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *image_source;
@property(nonatomic, assign) NSInteger color;
@end
