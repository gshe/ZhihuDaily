//
//  LaunchDataModel.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LaunchDataModel.h"

@implementation LaunchDataModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}
@end
