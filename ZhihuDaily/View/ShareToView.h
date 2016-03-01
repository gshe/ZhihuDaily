//
//  ShareToView.h
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "PopupBaseView.h"

typedef void (^ShareToClicked)(SharePlatform shareToType, NSString *name);

@interface ShareToView : PopupBaseView
@property(nonatomic, copy) ShareToClicked shareToClicked;
@end
