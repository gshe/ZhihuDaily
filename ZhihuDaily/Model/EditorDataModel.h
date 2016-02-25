//
//  EditorDataModel.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol EditorDataModel
@end

@interface EditorDataModel : JSONModel
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *bio;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) long long editorId;
@end
