//
//  EmptySeatsCell.m
//  ZhihuDaily
//
//  Created by George She on 16/3/1.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "EmptySeatsCell.h"

@implementation EmptySeatsCellUserData
@end

@interface EmptySeatsCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *thumbImg;
@end

@implementation EmptySeatsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title = [UILabel new];
    self.title.font = Font_15_B;
    self.title.numberOfLines = 3;
    self.title.textColor = [UIColor ex_subTextColor];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.text = @"深度长评论虚席以待";

    self.thumbImg = [[UIImageView alloc] init];
    self.thumbImg.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbImg.clipsToBounds = YES;
    self.thumbImg.image = [UIImage imageNamed:@"seat"];
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.thumbImg];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.thumbImg.mas_bottom).offset(10);
    make.centerX.equalTo(self.contentView);
  }];

  [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.contentView);
    make.height.mas_equalTo(135);
    make.width.mas_equalTo(88);
  }];
}

- (void)dealloc {
  self.userData = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  CGFloat height = kScreenHeight - 64 - 44 - 44 - 44;
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (EmptySeatsCellUserData *)object.userInfo;
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  EmptySeatsCellUserData *userData = [[EmptySeatsCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[EmptySeatsCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
