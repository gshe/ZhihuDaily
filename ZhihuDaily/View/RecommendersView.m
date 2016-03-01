//
//  RecommendersView.m
//  ZhihuDaily
//
//  Created by George She on 16/2/26.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "RecommendersView.h"
@interface RecommendersView ()
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation RecommendersView
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    _nameLabel = [UILabel new];
    _nameLabel.text = @"推荐者";
    _nameLabel.textColor = [UIColor ex_subTextColor];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(15);
      make.centerY.equalTo(self);
    }];
  }
  return self;
}

- (void)setRecommenders:(NSArray *)recommenders {
  _recommenders = recommenders;
  [self configUI];
}

- (void)configUI {
  for (UIView *v in self.subviews) {
    if ([v isKindOfClass:[UIImageView class]]) {
      [v removeFromSuperview];
    }
  }

  UIView *firstView = _nameLabel;
  for (NSDictionary *url in _recommenders) {
    UIImageView *img = [[UIImageView alloc] init];
    [img sd_setImageWithURL:[NSURL URLWithString:url[@"avatar"]]];
    img.layer.cornerRadius = 22;
    img.clipsToBounds = YES;
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(firstView.mas_right).offset(15);
      make.centerY.equalTo(self);
      make.width.mas_equalTo(44);
      make.height.mas_equalTo(44);
    }];
    firstView = img;
  }
}

@end
