//
//  AddCommentViewController.m
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()
@property(nonatomic, strong) UITextView *messageView;
@property(nonatomic, strong) UIView *bottomView;
@end

@implementation AddCommentViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(postPressed:)];
  [self configUI];
}

- (void)configUI {
  _messageView = [[UITextView alloc] init];
  _messageView.font = Font_15;
  _messageView.returnKeyType = UIReturnKeySend;
  [self.view addSubview:_messageView];
  _bottomView = [[UIView alloc] init];
  _bottomView.backgroundColor = [UIColor ex_separatorLineColor];
  UILabel *sharedTo = [UILabel new];
  sharedTo.text = @"同时分享到:";
  sharedTo.font = Font_12;
  [_bottomView addSubview:sharedTo];
  [self.view addSubview:_bottomView];
  [sharedTo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(_bottomView);
    make.left.equalTo(_bottomView).offset(15);
  }];

  UIImageView *weibo = [UIImageView new];
  weibo.image = [UIImage imageNamed:@"weibo"];
  [_bottomView addSubview:weibo];
  [weibo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(_bottomView);
    make.left.equalTo(sharedTo.mas_right).offset(5);
    make.height.mas_equalTo(16);
    make.width.mas_equalTo(16);
  }];

  [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(44);
  }];

  [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(_bottomView.mas_top);
  }];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillShow:)
             name:UIKeyboardWillShowNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillHide:)
             name:UIKeyboardWillHideNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillShow:)
             name:UIKeyboardWillChangeFrameNotification
           object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notif {
  NSDictionary *info = [notif userInfo];
  NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGSize keyboardSize = [value CGRectValue].size;
  CGFloat keyboardheight = MIN(keyboardSize.height, keyboardSize.width);
  if (keyboardheight > 0) {
    [self compressFrameHeight:keyboardheight];
  }
}

- (void)keyboardWillHide:(NSNotification *)notif {
  [self compressFrameHeight:0];
}

- (void)compressFrameHeight:(CGFloat)frameHeight {
  [UIView animateWithDuration:0.5
      animations:^{
        CGRect frame = self.view.frame;
        frame.size.height = kScreenHeight - 64 - frameHeight;
        self.view.frame = frame;
      }
      completion:^(BOOL finished){

      }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)postPressed:(id)sender {
  [self.messageView resignFirstResponder];
}

@end
