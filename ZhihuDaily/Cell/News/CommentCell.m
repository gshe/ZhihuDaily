//
//  CommentCell.m
//  ZhihuDaily
//
//  Created by George She on 16/2/29.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "CommentCell.h"
@implementation CommentCellUserData
@end

@interface CommentCell ()
@property(nonatomic, strong) UILabel *author;
@property(nonatomic, strong) UILabel *content;
@property(nonatomic, strong) UILabel *replayTo;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) UIImageView *votedImg;
@property(nonatomic, strong) UILabel *votedNumber;
@end

@implementation CommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    self.author = [UILabel new];
    self.author.font = Font_15;
    self.author.textColor = [UIColor ex_mainTextColor];
    self.author.textAlignment = NSTextAlignmentLeft;

    self.avatarImg = [[UIImageView alloc] init];
    self.avatarImg.layer.cornerRadius = 22;
    self.avatarImg.layer.borderWidth = 2;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImg.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImg.clipsToBounds = YES;

    self.votedImg = [[UIImageView alloc] init]; //
    self.votedImg.contentMode = UIViewContentModeScaleAspectFit;
    self.votedImg.clipsToBounds = YES;
    self.votedImg.image = [UIImage imageNamed:@"likeit"];

    self.votedNumber = [UILabel new];
    self.votedNumber.font = Font_12;
    self.votedNumber.textColor = [UIColor ex_subTextColor];
    self.votedNumber.textAlignment = NSTextAlignmentLeft;

    self.content = [UILabel new];
    self.content.font = Font_12;
    self.content.numberOfLines = 0;
    self.content.textColor = [UIColor ex_subTextColor];
    self.content.textAlignment = NSTextAlignmentLeft;

    self.replayTo = [UILabel new];
    self.replayTo.font = Font_12;
    self.replayTo.numberOfLines = 2;
    self.replayTo.textAlignment = NSTextAlignmentLeft;
    self.replayTo.textColor = [UIColor ex_subTextColor];

    self.timeLabel = [UILabel new];
    self.timeLabel.font = Font_12;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = [UIColor ex_subTextColor];

    self.clipsToBounds = YES;
    [self.contentView addSubview:self.author];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.avatarImg];
    [self.contentView addSubview:self.replayTo];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.votedNumber];
    [self.contentView addSubview:self.votedImg];
    [self makeConstraint];
  }
  return self;
}

- (void)makeConstraint {

  [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(15);
    make.top.equalTo(self.contentView).offset(15);
    make.height.mas_equalTo(44);
    make.width.mas_equalTo(44);
  }];

  [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.avatarImg);
    make.left.equalTo(self.avatarImg.mas_right).offset(5);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.votedNumber mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.author);
    make.right.equalTo(self.contentView).offset(-15);
  }];

  [self.votedImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.author);
    make.right.equalTo(self.votedNumber.mas_left).offset(-5);
    make.height.mas_equalTo(16);
    make.width.mas_equalTo(16);
  }];

  [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.author.mas_bottom).offset(5);
    make.left.equalTo(self.avatarImg.mas_right).offset(5);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];

  [self.replayTo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.content.mas_bottom).offset(5);
    make.left.equalTo(self.avatarImg.mas_right).offset(5);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];
  [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    make.left.equalTo(self.avatarImg.mas_right).offset(5);
    make.right.lessThanOrEqualTo(self.contentView).offset(-15);
  }];
}

- (void)dealloc {
  self.userData = nil;
  self.avatarImg.image = nil;
  self.content.text = nil;
  self.replayTo.text = nil;
  self.author.text = nil;
  self.timeLabel.text = nil;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.userData = nil;
  self.avatarImg.image = nil;
  self.content.text = nil;
  self.replayTo.text = nil;
  self.author.text = nil;
  self.timeLabel.text = nil;
  [self setNeedsLayout];
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
  NICellObject *obj = object;
  CommentCellUserData *userData = (CommentCellUserData *)obj.userInfo;
  CGFloat maxWidth = tableView.frame.size.width - 30 - 44 - 5;
  CGFloat height = 84;
  CGFloat contentHeight = [userData.commentItem.content
      lineBreakSizeOfStringwithFont:Font_12
                           maxwidth:maxWidth
                      lineBreakMode:NSLineBreakByWordWrapping];
  if (contentHeight > 30) {
    height += contentHeight;
  }

  if (userData.commentItem.reply_to && userData.commentItem.reply_to.content) {
    CGFloat replayToHeight =
        [[[self class] repleyToContent:userData.commentItem.reply_to]
            lineBreakSizeOfStringwithFont:Font_12
                                 maxwidth:maxWidth
                            lineBreakMode:NSLineBreakByWordWrapping];
    if (replayToHeight > 30) {
      height += 30 + 20;
    } else {
      height += replayToHeight + 20;
    }
  }

  return height;
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object {
  self.userData = (CommentCellUserData *)object.userInfo;
  self.author.text = self.userData.commentItem.author;
  self.content.text = self.userData.commentItem.content;
  self.timeLabel.text = self.userData.commentItem.timeStr;
  self.votedNumber.text =
      [NSString stringWithFormat:@"%ld", self.userData.commentItem.likes];
  if (self.userData.commentItem.reply_to) {
    self.replayTo.text =
        [[self class] repleyToContent:self.userData.commentItem.reply_to];
  }
  [self.avatarImg
      sd_setImageWithURL:[NSURL URLWithString:self.userData.commentItem.avatar]
        placeholderImage:Image(@"leftAvatar")];
  [self setNeedsLayout];
  return YES;
}

+ (NSString *)repleyToContent:(CommentDataModel *)repleyTo {
  return
      [NSString stringWithFormat:@"//%@ %@", repleyTo.author, repleyTo.content];
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData {
  CommentCellUserData *userData = [[CommentCellUserData alloc] init];
  NICellObject *cellObj =
      [[NICellObject alloc] initWithCellClass:[CommentCell class]
                                     userInfo:userData];
  return cellObj;
}

@end
