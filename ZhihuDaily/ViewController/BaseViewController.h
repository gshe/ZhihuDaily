//
//  BaseViewController.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelItemDataModel.h"
#import "WFRefreshView.h"

@interface BaseViewController
    : UIViewController <NIMutableTableViewModelDelegate, UITableViewDelegate>
@property(nonatomic, strong) ChannelItemDataModel *channleModel;
@property(nonatomic, assign) BOOL isLoading;

@property(nonatomic, strong) UIView *statusBar;
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) NSString *navigationTitle;
@property(nonatomic, strong) UILabel *navigationLabel;
@property(nonatomic, strong) UIButton *leftBarItemButton;
@property(nonatomic, strong) WFRefreshView *refreshView;

@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) NIMutableTableViewModel *model;
@property(nonatomic, strong) NITableViewActions *action;

- (void)setTableData:(NSArray *)tableCells;

/**
 *  请求新数据
 */
- (void)requestNewData;

/**
 *  请求旧数据
 */
- (void)requestOldData;

/**
 *  打开左抽屉
 */
- (void)openLeftDrawer;
@end
