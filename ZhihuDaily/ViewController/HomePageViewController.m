//
//  HomeViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "HomePageViewController.h"
#import "NewsItemCell.h"
#import "WFAutoLoopView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DetailViewController.h"

@interface HomePageViewController ()
@property(nonatomic, strong) WFAutoLoopView *autoLoopView;
@property(nonatomic, strong) NSMutableArray *contents;
@property(nonatomic, strong) NSArray<StoryDataModel> *todayStories;
@property(nonatomic, strong) NSArray<BannerStoryDataModel> *top_stories;

@property(nonatomic, strong) NSDate *fetchDate;
@property(nonatomic, strong) NSDateFormatter *formatter;
@property(nonatomic, assign) NSInteger totalCount;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.channleModel.channelName;
  self.navigationBar.alpha = 0.f;
  self.statusBar.alpha = 0.f;
  _totalCount = 0;
  _formatter = [[NSDateFormatter alloc] init];
  _formatter.dateFormat = @"yyyy年MM月dd";
  _fetchDate = [NSDate date];
  _contents = [NSMutableArray array];
  self.navigationTitle = @"今日要闻";
  [self requestNewData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)requestNewData {
  _fetchDate = [NSDate date];
  [[ZhihuDataManager shardInstance]
      requestLatestNews:^(StoryListDataModel *json) {
        [_contents removeAllObjects];
        //[_contents addObject:_fetchDate];
        [_contents addObject:json.stories];
        _todayStories = json.stories;
        _totalCount = json.stories.count;
        _top_stories = json.top_stories;

        self.isLoading = NO;
        [self.refreshView stopAnimation];
        [self refreshUI];
      }
      failed:^(NSError *error){
      }];
}

- (void)requestOldData {
  _fetchDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:_fetchDate];
  [[ZhihuDataManager shardInstance] requestOldNews:_fetchDate
      successBlock:^(StoryListDataModel *json) {
        [_contents addObject:json.date];
        [_contents addObject:json.stories];
        _totalCount += json.stories.count;
        self.isLoading = NO;
        [self.refreshView stopAnimation];
        [self refreshUI];
      }
      failed:^(NSError *error){
      }];
}

- (void)refreshUI {
  [self addTopView];
  NSMutableArray *tableContents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.contents) {
    for (id item in self.contents) {
      if ([item isKindOfClass:[NSDate class]]) {
        [tableContents addObject:[_formatter stringFromDate:item]];
      } else {
        for (id subItem in item) {
          NewsItemCellUserData *userData = [[NewsItemCellUserData alloc] init];
          userData.storyItem = subItem;
          [tableContents
              addObject:
                  [self.action
                      attachToObject:[[NICellObject alloc]
                                         initWithCellClass:[NewsItemCell class]
                                                  userInfo:userData]
                         tapSelector:@selector(itemClicked:)]];
        }
      }
    }
  }

  self.mainTableView.delegate = [self.action forwardingTo:self];
  [self setTableData:tableContents];
}

- (void)addTopView {

  if (_autoLoopView) {
    [_autoLoopView removeFromSuperview];
    [self.mainTableView setTableHeaderView:nil];
  }

  _autoLoopView = [[WFAutoLoopView alloc]
      initWithFrame:CGRectMake(0, 0, kScreenWidth, 200.f)];
  _autoLoopView.stretchAnimation = YES;
  _autoLoopView.banners = _top_stories;

  [self.mainTableView setTableHeaderView:_autoLoopView];
}

- (void)itemClicked:(NICellObject *)sender {
  NewsItemCellUserData *userData = sender.userInfo;
  StoryDataModel *item = userData.storyItem;
  DetailViewController *detailVC =
      [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  detailVC.storyDataModel = item;
	detailVC.isShowHeaderView = YES;
  [self.navigationController pushViewController:detailVC animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  }
  return 44;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UILabel *headerLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
  headerLabel.backgroundColor = RGBColor(5, 143, 214, 1.0f);
  headerLabel.font = Font_18_B;
  headerLabel.textAlignment = NSTextAlignmentCenter;
  NSString *sectiontext =
      [self.mainTableView.dataSource tableView:self.mainTableView
                       titleForHeaderInSection:section];
  headerLabel.text = sectiontext;
  return headerLabel;
}

#pragma mark - ScrollView Delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  [super scrollViewDidScroll:scrollView];

  if (scrollView == self.mainTableView) {

    CGFloat offSetY = scrollView.contentOffset.y;
    float h = offSetY / 200;
    self.navigationBar.alpha = (h > 1) ? 1 : h;
    self.statusBar.alpha = (h > 1) ? 1 : h;

    if ([self.mainTableView.tableHeaderView
            isKindOfClass:[WFAutoLoopView class]]) {
      [(WFAutoLoopView *)(self.mainTableView.tableHeaderView)
          wf_parallaxHeaderViewWithOffset:scrollView.contentOffset];
    }

    CGFloat dateHeaderHeight = 44;
    if (offSetY <= dateHeaderHeight && offSetY >= 0) {

      scrollView.contentInset = UIEdgeInsetsMake(-offSetY, 0, 0, 0);
    } else if (offSetY >= dateHeaderHeight) { //偏移20

      scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }

    if (offSetY >= 80.f * _todayStories.count +
                       180) { //第一个section到达后 隐藏navbar 和 标题
      self.navigationBar.alpha = 0.f;
      self.navigationTitle = @"";
    } else { //透明度变化上面已经设置完成
      self.navigationTitle = @"今日要闻";
                }
	}
	
}
@end
