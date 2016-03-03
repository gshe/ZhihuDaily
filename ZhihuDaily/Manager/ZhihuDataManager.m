//
//  ZhihuDataManager.m
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ZhihuDataManager.h"
#import "AFNetworking.h"
#import "LaunchDataModel.h"
#import "StoryListDataModel.h"
#import "StoryDetailExtraDataModel.h"
#import "StoryDetailDataModel.h"
#import "StoryDetailExtraDataModel.h"
#import "CommentsListDataModel.h"
#import "ThemeListDataModel.h"

#define kBaseUrl @"http://news-at.zhihu.com/api/4/"
#define APIDateFormat @"yyyyMMdd"

@interface ZhihuDataManager ()
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation ZhihuDataManager

+ (instancetype)shardInstance {
  static ZhihuDataManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ZhihuDataManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _sessionManager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:APIDateFormat];
  }
  return self;
}

- (void)requestLaunchImage:(HttpRequestSuccessBlock)successBlock
                    failed:(HttpRequestFailureBlock)faildBlock {
  [_sessionManager GET:@"start-image/720*1124"
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        LaunchDataModel *data =
            [[LaunchDataModel alloc] initWithDictionary:responseObject
                                                  error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestLatestNews:(HttpRequestSuccessBlock)successBlock
                   failed:(HttpRequestFailureBlock)faildBlock {
  [_sessionManager GET:@"news/latest"
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        StoryListDataModel *data =
            [[StoryListDataModel alloc] initWithDictionary:responseObject
                                                     error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestOldNews:(NSDate *)date
          successBlock:(HttpRequestSuccessBlock)successBlock
                failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = [NSString
      stringWithFormat:@"news/before/%@", [_formatter stringFromDate:date]];
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        StoryListDataModel *data =
            [[StoryListDataModel alloc] initWithDictionary:responseObject
                                                     error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestNewsDetail:(long long)newsId
             successBlock:(HttpRequestSuccessBlock)successBlock
                   failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = [NSString stringWithFormat:@"story/%lld", newsId];
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        StoryDetailDataModel *data =
            [[StoryDetailDataModel alloc] initWithDictionary:responseObject
                                                       error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestNewsDetailExtra:(long long)newsId
                  successBlock:(HttpRequestSuccessBlock)successBlock
                        failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = [NSString stringWithFormat:@"story-extra/%lld", newsId];
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        StoryDetailExtraDataModel *data =
            [[StoryDetailExtraDataModel alloc] initWithDictionary:responseObject
                                                            error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestChannelsWithSuccessBlock:(HttpRequestSuccessBlock)successBlock
                                 failed:(HttpRequestFailureBlock)faildBlock {
  [_sessionManager GET:@"themes"
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        ThemeListDataModel *data =
            [[ThemeListDataModel alloc] initWithDictionary:responseObject
                                                     error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestChannelNewsWithChannelId:(NSInteger)channelId
                           beforStoryId:(long long)storyId
                           successBlock:(HttpRequestSuccessBlock)successBlock
                                 failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = [NSString stringWithFormat:@"theme/%ld", channelId];
  if (storyId > 0) {
    urlStr = [NSString stringWithFormat:@"%@/before/%lld", urlStr, storyId];
  }

  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        StoryListDataModel *data =
            [[StoryListDataModel alloc] initWithDictionary:responseObject
                                                     error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestNewsLongComments:(long long)newsId
                         before:(long long)commentId
                   successBlock:(HttpRequestSuccessBlock)successBlock
                         failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = @"";
  if (commentId > 0) {
    urlStr = [NSString stringWithFormat:@"story/%lld/long-comments/before/%lld",
                                        newsId, commentId];
  } else {
    urlStr = [NSString stringWithFormat:@"story/%lld/long-comments", newsId];
  }
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        CommentsListDataModel *data =
            [[CommentsListDataModel alloc] initWithDictionary:responseObject
                                                        error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)requestNewsShortComments:(long long)newsId
                          before:(long long)commentId
                    successBlock:(HttpRequestSuccessBlock)successBlock
                          failed:(HttpRequestFailureBlock)faildBlock {
  NSString *urlStr = @"";
  if (commentId > 0) {
    urlStr =
        [NSString stringWithFormat:@"story/%lld/short-comments/before/%lld",
                                   newsId, commentId];
  } else {
    urlStr = [NSString stringWithFormat:@"story/%lld/short-comments", newsId];
  }
  [_sessionManager GET:urlStr
      parameters:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {
        NSError *error;
        CommentsListDataModel *data =
            [[CommentsListDataModel alloc] initWithDictionary:responseObject
                                                        error:&error];
        if (data) {
          if (successBlock) {
            successBlock(data);
          }
        } else {
          if (faildBlock) {
            faildBlock(error);
          }
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}

- (void)voteNews:(long long)newsId
    successBlock:(HttpRequestSuccessBlock)successBlock
          failed:(HttpRequestFailureBlock)faildBlock {
  NSArray *params = [NSArray arrayWithObjects:@(newsId), @(1), nil];
  [_sessionManager POST:@"vote/stories"
      parameters:params
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nonnull responseObject) {

        if (successBlock) {
          successBlock(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (faildBlock) {
          faildBlock(error);
        }
      }];
}
@end
