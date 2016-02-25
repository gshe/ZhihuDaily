//
//  LaunchDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LaunchDataModel : JSONModel
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *img;
@end
