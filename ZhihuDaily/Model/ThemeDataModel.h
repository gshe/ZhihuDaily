//
//  ThemeInfo.h
//  ZhihuDaily
//
//  Created by George She on 16/3/3.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol ThemeDataModel
@end

@interface ThemeDataModel : JSONModel
@property(nonatomic, assign) long long themeId;
@property(nonatomic, assign) NSInteger color;
@property(nonatomic, strong) NSString *thumbnail;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *name;
@end
