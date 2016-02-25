//
//  NewsItemCell.m
//  Floyd
//
//  Created by admin on 16/1/8.
//  Copyright © 2016年 George She. All rights reserved.
//

#import "NewsItemCell.h"
@implementation NewsItemCellUserData
@end

@interface NewsItemCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *thumbImg;
@end

@implementation NewsItemCell
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

    self.thumbImg = [[UIImageView alloc] init];
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.thumbImg];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {
  [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(10);
    make.left.equalTo(self.contentView).offset(15);
    make.right.lessThanOrEqualTo(self.thumbImg.mas_left).offset(-15);
  }];

  [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(-15);
    make.centerY.equalTo(self.contentView);
    make.height.mas_equalTo(56);
    make.width.mas_equalTo(86);
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
  CGFloat height = 80;
  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (NewsItemCellUserData *)object.userInfo;
  self.title.text = self.userData.storyItem.title;
  if (self.userData.storyItem.images.count > 0) {
    [self.thumbImg
        sd_setImageWithURL:[NSURL
                               URLWithString:self.userData.storyItem.images[0]]
          placeholderImage:nil];
  }
  return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  NewsItemCellUserData *userData = [[NewsItemCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[NewsItemCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
