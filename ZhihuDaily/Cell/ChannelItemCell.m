//
//  ChannelItemCell.m
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ChannelItemCell.h"
@implementation ChannelItemCellUserData

@end

@interface ChannelItemCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *thumbImg;
@end

@implementation ChannelItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    self.title = [UILabel new];
    self.title.font = Font_15;
    self.title.numberOfLines = 3;
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentLeft;

    self.thumbImg = [[UIImageView alloc] init];
    self.thumbImg.image = Image(@"leftEnter");
    self.thumbImg.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.thumbImg];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.left.equalTo(self.contentView).offset(15);
    make.right.lessThanOrEqualTo(self.thumbImg.mas_left).offset(-15);
  }];

  [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(-15);
    make.centerY.equalTo(self.contentView);
    make.height.mas_equalTo(22);
    make.width.mas_equalTo(22);
  }];
}

- (void)dealloc {
  self.userData = nil;
  self.thumbImg.image = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.title.text = nil;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  CGFloat height = 44;
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (ChannelItemCellUserData *)object.userInfo;
  self.title.text = self.userData.channelItem.channelName;
  if (self.userData.channelItem.isSelected) {
    self.title.font = Font_18_B;
  } else {
    self.title.font = Font_15;
  }
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  ChannelItemCellUserData *userData = [[ChannelItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[ChannelItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
