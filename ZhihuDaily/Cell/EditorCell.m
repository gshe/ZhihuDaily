//
//  EditorCell.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "EditorCell.h"

@implementation EditorCellUserData
@end

@interface EditorCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *desc;
@property(nonatomic, strong) UIImageView *thumbImg;
@end

@implementation EditorCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title = [UILabel new];
    self.title.font = Font_15_B;
    self.title.numberOfLines = 3;
    self.title.textColor = [UIColor ex_mainTextColor];
    self.title.textAlignment = NSTextAlignmentLeft;

    self.desc = [UILabel new];
    self.desc.font = Font_12;
    self.desc.numberOfLines = 3;
    self.desc.textColor = [UIColor ex_subTextColor];
    self.desc.textAlignment = NSTextAlignmentLeft;

    self.thumbImg = [[UIImageView alloc] init];
    self.thumbImg.layer.cornerRadius = 22;
    self.thumbImg.layer.borderWidth = 2;
    self.thumbImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thumbImg.clipsToBounds = YES;

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.desc];
    [self.contentView addSubview:self.thumbImg];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(10);
    make.left.equalTo(self.thumbImg.mas_right).offset(15);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    make.left.equalTo(self.thumbImg.mas_right).offset(15);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.centerY.equalTo(self.contentView);
    make.height.mas_equalTo(44);
    make.width.mas_equalTo(44);
  }];
}

- (void)dealloc {
  self.userData = nil;
  self.thumbImg.image = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.title.text = nil;
  self.desc.text = nil;
  self.thumbImg.image = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  return 56;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (EditorCellUserData *)object.userInfo;
  self.title.text = self.userData.editor.name;
  self.desc.text = self.userData.editor.bio;
  if (self.userData.editor.avatar) {
    [self.thumbImg
        sd_setImageWithURL:[NSURL URLWithString:self.userData.editor.avatar]
          placeholderImage:nil];
  }
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  EditorCellUserData *userData = [[EditorCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[EditorCell class]
                                     userInfo:userData];
  return cellObj;
}
@end