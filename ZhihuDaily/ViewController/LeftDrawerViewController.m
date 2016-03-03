//
//  LeftDrawerViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "ChannelItemCell.h"
#import "LoginViewController.h"

@interface LeftDrawerViewController () <NIMutableTableViewModelDelegate,
                                        UITableViewDelegate>
@property(nonatomic, strong) UITableView *channleTable;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic, strong) NIMutableTableViewModel *model;
@property(nonatomic, strong) NITableViewActions *action;
@end

@implementation LeftDrawerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configUI];
  [self configTopView];
  [self configBottomView];
  [self refreshUI];
}

- (void)setControllers:(NSArray *)controllers {
  _controllers = controllers;
  [self refreshUI];
}

- (void)configUI {
  _topView = [UIView new];
  _bottomView = [UIView new];
  _channleTable = [UITableView new];
  _channleTable.backgroundColor = RGBColor(35, 42, 48, 1);
  _channleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_topView];
  [self.view addSubview:_bottomView];
  [self.view addSubview:_channleTable];

  [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(20);
    make.height.mas_equalTo(88);
  }];

  [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(44);
  }];

  [_channleTable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(_topView.mas_bottom);
    make.bottom.equalTo(_bottomView.mas_top);
  }];
}

- (void)configTopView {
  UIImageView *avatarImg = [UIImageView new];
  avatarImg.image = Image(@"leftAvatar");
  [_topView addSubview:avatarImg];
  UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [loginBtn setTitle:@"请登录" forState:UIControlStateNormal];
  [loginBtn addTarget:self
                action:@selector(loginButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
  [_topView addSubview:loginBtn];

  UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [favBtn setTitle:@"收藏" forState:UIControlStateNormal];
  [favBtn setImage:Image(@"leftFavour") forState:UIControlStateNormal];
  [_topView addSubview:favBtn];
  [self dealwith:favBtn];

  UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [msgBtn setTitle:@"消息" forState:UIControlStateNormal];
  [msgBtn setImage:Image(@"leftMessage") forState:UIControlStateNormal];
  [_topView addSubview:msgBtn];
  [self dealwith:msgBtn];

  UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
  [settingBtn setImage:Image(@"leftSetting") forState:UIControlStateNormal];
  [_topView addSubview:settingBtn];
  [self dealwith:settingBtn];

  [avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_topView).offset(15);
    make.top.equalTo(_topView);
    make.width.mas_equalTo(44);
    make.height.mas_equalTo(44);
  }];

  [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(avatarImg.mas_right).offset(15);
    make.centerY.equalTo(avatarImg);
  }];

  [favBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_topView).offset(15);
    make.top.equalTo(avatarImg.mas_bottom).offset(25);
  }];

  [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(favBtn.mas_right).offset(5);
    make.top.equalTo(favBtn);
  }];

  [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(msgBtn.mas_right).offset(5);
    make.top.equalTo(favBtn);
  }];
}

- (void)configBottomView {
  UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [downloadBtn setTitle:@"离线" forState:UIControlStateNormal];
  [downloadBtn setImage:Image(@"leftDownload") forState:UIControlStateNormal];
  downloadBtn.titleLabel.font = Font_12;
  [downloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
  [_bottomView addSubview:downloadBtn];

  UIButton *nightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [nightBtn setTitle:@"夜间" forState:UIControlStateNormal];
  [nightBtn setImage:Image(@"leftNight") forState:UIControlStateNormal];
  nightBtn.titleLabel.font = Font_12;
  [nightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
  [_bottomView addSubview:nightBtn];

  [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_bottomView).offset(15);
    make.centerY.equalTo(_bottomView);
  }];

  [nightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(_bottomView).offset(-15);
    make.centerY.equalTo(_bottomView);
  }];
}

#pragma mark - Private methods -

- (void)loginButtonClicked:(id)sender {
  LoginViewController *loginVC =
      [[LoginViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *naviVC =
      [[UINavigationController alloc] initWithRootViewController:loginVC];
  [self presentViewController:naviVC
                     animated:YES
                   completion:^{

                   }];
}

- (void)dealwith:(UIButton *)dealBtn {
  dealBtn.titleLabel.font = Font_12;
  [dealBtn setImageEdgeInsets:UIEdgeInsetsMake(-40, 0.f, 0.f, 0.f)];
  [dealBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
}

- (void)refreshUI {
  NSMutableArray *contents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  for (BaseViewController *vc in _controllers) {
    ChannelItemCellUserData *userData = [[ChannelItemCellUserData alloc] init];
    userData.channelItem = vc.channleModel;
    [contents
        addObject:[self.action attachToObject:
                                   [[NICellObject alloc]
                                       initWithCellClass:[ChannelItemCell class]
                                                userInfo:userData]
                                  tapSelector:@selector(itemClicked:)]];
  }

  _channleTable.delegate = [self.action forwardingTo:self];
  [self setTableData:contents];
}

- (void)setTableData:(NSArray *)tableCells {
  NIDASSERT([NSThread isMainThread]);

  self.model =
      [[NIMutableTableViewModel alloc] initWithSectionedArray:tableCells
                                                     delegate:self];

  _channleTable.dataSource = _model;
  [_channleTable reloadData];
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

- (void)itemClicked:(NICellObject *)sender {
  ChannelItemCellUserData *userData = sender.userInfo;
  ChannelItemDataModel *item = userData.channelItem;
  for (BaseViewController *vc in _controllers) {
    if (vc.channleModel.isSelected) {
      vc.channleModel.isSelected = NO;
    }
  }

  item.isSelected = YES;

  if ([self.delegate respondsToSelector:@selector(channelSelected:)]) {
    [self.delegate channelSelected:item.channelVC];
        }
}

@end
