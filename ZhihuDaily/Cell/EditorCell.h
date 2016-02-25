//
//  EditorCell.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"

@interface EditorCellUserData : NSObject
@property(nonatomic, strong) EditorDataModel *editor;
@end

@interface EditorCell : FDTableViewCell
@property(nonatomic, strong) EditorCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
