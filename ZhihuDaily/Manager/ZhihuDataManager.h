//
//  ZhihuDataManager.h
//  ZhihuDaily
//
//  Created by George She on 16/2/24.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HttpRequestSuccessBlock)(id json);
typedef void (^HttpRequestFailureBlock)(NSError *error);

@interface ZhihuDataManager : NSObject

+ (instancetype)shardInstance;

- (void)requestLaunchImage:(HttpRequestSuccessBlock)successBlock
                    failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestLatestNews:(HttpRequestSuccessBlock)successBlock
                   failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestOldNews:(NSDate *)date
          successBlock:(HttpRequestSuccessBlock)successBlock
                failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestNewsDetail:(long long)newsId
             successBlock:(HttpRequestSuccessBlock)successBlock
                   failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestNewsDetailExtra:(long long)newsId
                  successBlock:(HttpRequestSuccessBlock)successBlock
                        failed:(HttpRequestFailureBlock)faildBlock;

-(void)requestChannelsWithSuccessBlock:(HttpRequestSuccessBlock)successBlock
								failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestChannelNewsWithChannelId:(NSInteger)channelId
                           beforStoryId:(long long)storyId
                           successBlock:(HttpRequestSuccessBlock)successBlock
                                 failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestNewsLongComments:(long long)newsId
                         before:(long long)commentId
                   successBlock:(HttpRequestSuccessBlock)successBlock
                         failed:(HttpRequestFailureBlock)faildBlock;

- (void)requestNewsShortComments:(long long)newsId
                          before:(long long)commentId
                    successBlock:(HttpRequestSuccessBlock)successBlock
                          failed:(HttpRequestFailureBlock)faildBlock;

- (void)voteNews:(long long)newsId
    successBlock:(HttpRequestSuccessBlock)successBlock
          failed:(HttpRequestFailureBlock)faildBlock;
@end
