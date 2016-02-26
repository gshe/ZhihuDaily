//
//  ChannelCommonViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ChannelCommonViewController.h"
#import "NewsItemCell.h"
#import "WFEditorView.h"
#import "AppDelegate.h"
#import "UIImageView+WFImg.h"
#import "EditorListViewController.h"
#import "DetailViewController.h"
#import "WFThemeNavBar.h"
@interface ChannelCommonViewController ()
@property(nonatomic, strong) StoryListDataModel *storyList;
@property(nonatomic, strong) WFEditorView *editorView;
@property(nonatomic, strong) WFThemeNavBar *themeNavBar;
@end

@implementation ChannelCommonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.channleModel.channelName;

  self.statusBar.hidden = YES;
  self.navigationBar.hidden = YES;
  self.navigationTitle = self.channleModel.channelName;
  [self.leftBarItemButton setImage:Image(@"detail_NavBack.png") forState:0];
  self.mainTableView.tableHeaderView = nil;
  self.mainTableView.frame =
      CGRectMake(0.f, 64.f, kScreenWidth, kScreenHeight - 64);
  [self.view insertSubview:self.themeNavBar
              belowSubview:self.leftBarItemButton];

  _editorView =
      [[WFEditorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(editViewTapped:)];
  [_editorView addGestureRecognizer:tapGesture];
  self.mainTableView.tableHeaderView = _editorView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self requestData];
}

- (void)requestData {
  [[ZhihuDataManager shardInstance]
      requestChannelNewsWithChannelId:self.channleModel.channleId
      successBlock:^(StoryListDataModel *json) {
        self.storyList = json;
        [self refreshUI];
      }
      failed:^(NSError *error){

      }];
}

- (void)refreshUI {
  [self refreshNaviBar];
  [self refreshEditorUI];
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.storyList.stories) {
    for (StoryDataModel *item in self.storyList.stories) {
      NewsItemCellUserData *userData = [[NewsItemCellUserData alloc] init];
      userData.storyItem = item;
      [contents
          addObject:[self.action attachToObject:
                                     [[NICellObject alloc]
                                         initWithCellClass:[NewsItemCell class]
                                                  userInfo:userData]
                                    tapSelector:@selector(itemClicked:)]];
    }
  }

  self.mainTableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)itemClicked:(NICellObject *)sender {
  NewsItemCellUserData *userData = sender.userInfo;
  StoryDataModel *item = userData.storyItem;
  DetailViewController *detailVC =
      [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.storyDataModel = item;
  detailVC.storyDataList = self.storyList.stories;
  detailVC.isShowHeaderView = NO;
  [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshNaviBar {
  [_themeNavBar wf_setImageWithUrlString:self.storyList.background
                        placeholderImage:nil
                               completed:^(UIImage *image) {
                                 _themeNavBar.blurImage = image;
                               }];
}

- (void)refreshEditorUI {
  self.editorView.avatarImageArr = self.storyList.editors;
}

#pragma mark - UIScrollView Delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGFloat offSetY = scrollView.contentOffset.y;

  if (-offSetY <= 74 && -offSetY >= 0) {

    [_themeNavBar wf_parallaxHeaderViewWithOffset:scrollView.contentOffset.y];
  }
  if (-offSetY > 74) { //到－74 让scrollview不再能被拉动

    self.mainTableView.contentOffset = CGPointMake(0, -74);
  }
}

- (WFThemeNavBar *)themeNavBar {
  if (!_themeNavBar) {
    _themeNavBar = [[WFThemeNavBar alloc]
        initWithFrame:CGRectMake(0, -74, kScreenWidth, 138)];
  }
  return _themeNavBar;
}

- (void)openLeftDrawer {

  AppDelegate *appDelegate =
      (AppDelegate *)[[UIApplication sharedApplication] delegate];
  if ([appDelegate.window.rootViewController
          isKindOfClass:[MMDrawerController class]]) {
    MMDrawerController *mainVc =
        (MMDrawerController *)appDelegate.window.rootViewController;
    if (mainVc.openSide == MMDrawerSideLeft) {
      [mainVc closeDrawerAnimated:YES completion:nil];
    } else {
      [mainVc openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
  }
}

- (void)editViewTapped:(UIGestureRecognizer *)ges {
  EditorListViewController *editListVC =
      [[EditorListViewController alloc] initWithNibName:nil bundle:nil];
  editListVC.editors = self.storyList.editors;
  [self.navigationController pushViewController:editListVC animated:YES];
}

@end
