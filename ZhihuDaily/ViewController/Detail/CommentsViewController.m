//
//  CommentsViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsListDataModel.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "AddCommentViewController.h"
#import "EmptySeatsCell.h"

@interface CommentsViewController () <NIMutableTableViewModelDelegate,
                                      UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray *longComments;
@property(nonatomic, strong) NSMutableArray *shortComments;
@property(nonatomic, strong) NIMutableTableViewModel *model;
@property(nonatomic, strong) NITableViewActions *action;

@property(nonatomic, assign) BOOL isLongCommentLoading;
@property(nonatomic, assign) BOOL isShortCommentLoading;

@property(nonatomic, assign) BOOL isShortCommentExpanded;
@property(nonatomic, strong) UIView *writeNewComment;
@property(nonatomic, strong) UITableView *mainTableView;
@end

@implementation CommentsViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  _isShortCommentExpanded = NO;
  _longComments = [NSMutableArray array];
  _shortComments = [NSMutableArray array];
  [self configUI];
  [self requestData];
}

- (void)configUI {
  _writeNewComment = [UIView new];
  UILabel *addNewComment = [UILabel new];
  addNewComment.text = @"新评论";
  [_writeNewComment addSubview:addNewComment];
  [_writeNewComment
      addGestureRecognizer:[[UITapGestureRecognizer alloc]
                               initWithTarget:self
                                       action:@selector(addNewCommentTapped:)]];
  _writeNewComment.backgroundColor = [UIColor ex_orangeTextColor];
  [self.view addSubview:_writeNewComment];
  self.mainTableView = [UITableView new];
  self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter
      footerWithRefreshingTarget:self
                refreshingAction:@selector(loadMoreData)];
  [self.view addSubview:self.mainTableView];
  [addNewComment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(_writeNewComment);
  }];

  [_writeNewComment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(44);

  }];
  [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(_writeNewComment.mas_top);
    make.top.equalTo(self.view);
  }];
}

- (void)addNewCommentTapped:(id)sender {
  AddCommentViewController *addCommentVC =
      [[AddCommentViewController alloc] initWithNibName:nil bundle:nil];
  addCommentVC.storyItem = self.storyItem;
  [self.navigationController pushViewController:addCommentVC animated:YES];
}

- (void)requestData {
  [self requstLongComments:0];
  [self requstShortComments:0];
}

- (void)requstLongComments:(long long)beforeCommentId {
  FDWeakSelf;
  _isLongCommentLoading = YES;
  [[ZhihuDataManager shardInstance]
      requestNewsLongComments:self.storyItem.storyId
      before:beforeCommentId
      successBlock:^(CommentsListDataModel *json) {
        FDStrongSelf;
        if (json && json.comments) {
          [_longComments addObjectsFromArray:json.comments];
        }
        _isLongCommentLoading = NO;
        [self refreshUI];
      }
      failed:^(NSError *error) {
        _isLongCommentLoading = NO;
        [self refreshUI];
      }];
}

- (void)requstShortComments:(long long)beforeCommentId {
  FDWeakSelf;
  _isShortCommentLoading = YES;
  [[ZhihuDataManager shardInstance]
      requestNewsShortComments:self.storyItem.storyId
      before:beforeCommentId
      successBlock:^(CommentsListDataModel *json) {
        FDStrongSelf;
        if (json && json.comments) {
          [_shortComments addObjectsFromArray:json.comments];
          [self.mainTableView.mj_footer endRefreshing];
        } else {
          [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
        _isShortCommentLoading = NO;
        [self refreshUI];
      }
      failed:^(NSError *error) {
        _isShortCommentLoading = NO;
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        [self refreshUI];
      }];
}

- (void)loadMoreData {
  CommentDataModel *lastComment = [_shortComments lastObject];
  [self requstShortComments:lastComment.commentId];
}

- (void)refreshUI {
  if (_isLongCommentLoading || _isShortCommentLoading) {
    return;
  }

  if (_longComments.count < 2) {
    _isShortCommentExpanded = YES;
  }

  if (_isShortCommentExpanded) {
    self.mainTableView.mj_footer.hidden = NO;
  } else {
    self.mainTableView.mj_footer.hidden = YES;
  }

  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  NSString *longCommentTitle =
      [NSString stringWithFormat:@"%ld 条长评论", _longComments.count];
  [contents
      addObject:[[NITitleCellObject alloc] initWithTitle:longCommentTitle]];
  if (_longComments.count == 0) {
    EmptySeatsCellUserData *userData = [[EmptySeatsCellUserData alloc] init];
    [contents
        addObject:[[NICellObject alloc] initWithCellClass:[EmptySeatsCell class]
                                                 userInfo:userData]];
  } else {
    for (CommentDataModel *comment in _longComments) {
      CommentCellUserData *userData = [[CommentCellUserData alloc] init];
      userData.commentItem = comment;
      [contents
          addObject:[self.action
                        attachToObject:[[NICellObject alloc]
                                           initWithCellClass:[CommentCell class]
                                                    userInfo:userData]
                           tapSelector:@selector(itemClicked:)]];
    }
  }

  NSString *shortCommentTitle =
      [NSString stringWithFormat:@"%ld 条短评论", _shortComments.count];
  UIImage *img = Image(@"detail_Next");
  [contents
      addObject:[self.action attachToObject:[[NISubtitleCellObject alloc]
                                                initWithTitle:shortCommentTitle
                                                     subtitle:@"点击查看"
                                                        image:img]
                                tapSelector:@selector(expandShortComment:)]];

  if (_isShortCommentExpanded) {
    for (CommentDataModel *comment in _shortComments) {

      CommentCellUserData *userData = [[CommentCellUserData alloc] init];
      userData.commentItem = comment;
      [contents
          addObject:[self.action
                        attachToObject:[[NICellObject alloc]
                                           initWithCellClass:[CommentCell class]
                                                    userInfo:userData]
                           tapSelector:@selector(itemClicked:)]];
    }
  }
  self.mainTableView.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)itemClicked:(NICellObject *)sender {
}

- (void)expandShortComment:(NICellObject *)sender {
  if (!_isShortCommentExpanded) {
    _isShortCommentExpanded = YES;

    [self refreshUI];
  }
}

- (void)setTableData:(NSArray *)tableCells {
  NIDASSERT([NSThread isMainThread]);

  self.model =
      [[NIMutableTableViewModel alloc] initWithSectionedArray:tableCells
                                                     delegate:self];

  self.mainTableView.dataSource = _model;
  [self.mainTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [NICellFactory tableView:aTableView
          heightForRowAtIndexPath:indexPath
                            model:(NITableViewModel *)aTableView.dataSource];
}

#pragma mark - NIMutableTableViewModelDelegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
  return [NICellFactory tableViewModel:tableViewModel
                      cellForTableView:tableView
                           atIndexPath:indexPath
                            withObject:object];
}
@end
