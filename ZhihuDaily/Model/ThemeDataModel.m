//
//  ThemeInfo.m
//  ZhihuDaily
//
//  Created by George She on 16/3/3.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ThemeDataModel.h"

@implementation ThemeDataModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"description" : @"desc",
    @"id" : @"themeId",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
