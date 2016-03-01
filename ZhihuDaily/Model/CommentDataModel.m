//
//  CommentDataModel.m
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "CommentDataModel.h"

@implementation CommentDataModel
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"commentId",
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}

- (NSString *)timeStr {
  NSDate *dt = [NSDate dateWithTimeIntervalSince1970:self.time];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  return [formatter stringFromDate:dt];
}
@end
