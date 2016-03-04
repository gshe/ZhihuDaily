//
//  DetailViewController.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDViewController.h"
#import "StoryDataModel.h"
@protocol DetailViewControllerDelegate <NSObject>
- (void)itemReadNotify:(StoryDataModel *)item;
@end

@interface DetailViewController : FDViewController
@property(nonatomic, strong) StoryDataModel *storyDataModel;
@property(nonatomic, strong) NSArray *storyDataList;
@property(nonatomic, assign) BOOL isShowHeaderView;
@property(nonatomic, weak) id<DetailViewControllerDelegate> delegate;
@end
