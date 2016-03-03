//
//  ThemeListDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/3/3.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ThemeDataModel.h"

@interface ThemeListDataModel : JSONModel
@property(nonatomic, assign) long limit;
@property(nonatomic, assign) NSArray<ThemeDataModel> *subscribed;
@property(nonatomic, assign) NSArray<ThemeDataModel> *others;
@end
