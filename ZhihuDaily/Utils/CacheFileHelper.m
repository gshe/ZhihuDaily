//
//  FDCacheHelper.m
//  SinaNews
//
//  Created by George She on 16/2/22.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "CacheFileHelper.h"

@implementation CacheFileHelper

- (NSString *)getCachesPath {
  // 获取Caches目录路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                       NSUserDomainMask, YES);
  NSString *cachesDir = [paths objectAtIndex:0];
  return cachesDir;
}

- (long long)fileSizeAtPath:(NSString *)filePath {
  NSFileManager *manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:filePath]) {
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
  }
  return 0;
}

- (float)getCacheSize {
  NSString *folderPath = [self getCachesPath];
  NSFileManager *manager = [NSFileManager defaultManager];
  if (![manager fileExistsAtPath:folderPath])
    return 0;
  NSEnumerator *childFilesEnumerator =
      [[manager subpathsAtPath:folderPath] objectEnumerator]; //从前向后枚举器
  NSString *fileName;
  long long folderSize = 0;
  while ((fileName = [childFilesEnumerator nextObject]) != nil) {
    NSLog(@"fileName ==== %@", fileName);
    NSString *fileAbsolutePath =
        [folderPath stringByAppendingPathComponent:fileName];
    NSLog(@"fileAbsolutePath ==== %@", fileAbsolutePath);
    folderSize += [self fileSizeAtPath:fileAbsolutePath];
  }
  NSLog(@"folderSize ==== %lld", folderSize);
  return folderSize / (1024.0 * 1024.0);
}

- (void)clearCache {
  NSString *folderPath = [self getCachesPath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:folderPath]) {
    NSArray *childerFiles = [fileManager subpathsAtPath:folderPath];
    for (NSString *fileName in childerFiles) {
      //如有需要，加入条件，过滤掉不想删除的文件
      NSString *absolutePath =
          [folderPath stringByAppendingPathComponent:fileName];
      [fileManager removeItemAtPath:absolutePath error:nil];
                }
	}
}
@end
