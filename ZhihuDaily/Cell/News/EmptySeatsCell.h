//
//  EmptySeatsCell.h
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewCell.h"
@interface EmptySeatsCellUserData : NSObject

@end

@interface EmptySeatsCell : FDTableViewCell
@property(nonatomic, strong) EmptySeatsCellUserData *userData;

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;
@end
