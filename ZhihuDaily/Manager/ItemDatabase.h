//
//  ItemDatabase.h
//  ZhihuDaily
//
//  Created by George She on 16/3/4.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDatabase : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isItemReadByUser:(long long)itemId;
- (void)itemReadByUser:(long long)itemId;

@end
