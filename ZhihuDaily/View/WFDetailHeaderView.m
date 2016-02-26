//
//  WFDetailHeaderView.m
//  WFZhihuDaily
//
//  Created by xiupintech on 16/1/6.
//  Copyright © 2016年 xiupintech. All rights reserved.
//

#import "WFDetailHeaderView.h"
#import "UIImageView+WFImg.h"

@implementation WFDetailHeaderView

- (id)initWithFrame:(CGRect)frame {

  if (self == [super initWithFrame:frame]) {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    [self configUI];
  }
  return self;
}

- (void)configUI {

  _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self addSubview:_imageView];

  _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
  _titleLab.numberOfLines = 0;
  [self addSubview:_titleLab];

  _imgSourceLab = [[UILabel alloc] initWithFrame:CGRectZero];
  _imgSourceLab.textAlignment = NSTextAlignmentRight;
  _imgSourceLab.font = [UIFont systemFontOfSize:12];
  _imgSourceLab.textColor = [UIColor whiteColor];
  [self addSubview:_imgSourceLab];

  [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self);
    make.right.equalTo(self);
    make.top.equalTo(self);
    make.height.mas_equalTo(300);
  }];
  [_imgSourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self).offset(-15);
    make.bottom.equalTo(self).offset(-15);
  }];
  [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(15);
    make.right.lessThanOrEqualTo(self).offset(-15);
    make.bottom.equalTo(_imgSourceLab.mas_top).offset(-15);
  }];
}

- (void)refreshHeaderView:(StoryDetailDataModel *)storyDetail {
  NSDictionary *attributesDic = @{
    NSFontAttributeName : [UIFont boldSystemFontOfSize:21],
    NSForegroundColorAttributeName : [UIColor whiteColor]
  };

  NSAttributedString *titleLblString =
      [[NSAttributedString alloc] initWithString:storyDetail.title
                                      attributes:attributesDic];
  [_imageView wf_setImageWithUrlString:storyDetail.image
                      placeholderImage:Image(@"tags_selected.png")];
  _titleLab.attributedText = titleLblString;
  _imgSourceLab.text = storyDetail.image_source;
}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//  if (event.type == UIEventTypeTouches) {
//
//    NSSet *touches = [event touchesForView:self];
//    UITouch *touch = [touches anyObject];
//
//    if (touch.phase == UITouchPhaseBegan) {
//      [self addGestureRecognizer:_webView.scrollView.panGestureRecognizer];
//    }
//  }
//  return [super hitTest:point withEvent:event];
//}

- (void)wf_parallaxHeaderViewWithOffset:(CGFloat)offset {

  self.frame = CGRectMake(0, -40 - offset / 2, kScreenWidth, 260 - offset / 2);

  [_imgSourceLab setTop:240 - offset / 2];
  [_titleLab setBottom:_imgSourceLab.bottom - 20];
}

@end
