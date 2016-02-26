//
//  EditorListViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "EditorListViewController.h"
#import "EditorCell.h"
#import "FDWebViewController.h"

@interface EditorListViewController ()
@property(nonatomic, strong) NITableViewActions *action;
@end

@implementation EditorListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"编辑列表";
  [self configUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)configUI {
  NSMutableArray *tableContents = [@[] mutableCopy];
  self.action = [[NITableViewActions alloc] initWithTarget:self];
  if (self.editors) {
    for (id item in self.editors) {

      EditorCellUserData *userData = [[EditorCellUserData alloc] init];
      userData.editor = item;
      [tableContents
          addObject:[self.action
                        attachToObject:[[NICellObject alloc]
                                           initWithCellClass:[EditorCell class]
                                                    userInfo:userData]
                           tapSelector:@selector(itemClicked:)]];
    }
  }

  self.tableView.delegate = [self.action forwardingTo:self];
  [self setTableData:tableContents];
}

- (void)itemClicked:(NICellObject *)sender {
  EditorCellUserData *userData = sender.userInfo;
  FDWebViewController *webVC =
      [[FDWebViewController alloc] initWithNibName:nil bundle:nil];
  webVC.urlString = [NSString
      stringWithFormat:
          @"http://news-at.zhihu.com/api/4/editor/%lld/profile-page/ios",
          userData.editor.editorId];
  [self.navigationController pushViewController:webVC animated:YES];
}

@end
