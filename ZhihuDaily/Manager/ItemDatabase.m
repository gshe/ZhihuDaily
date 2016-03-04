//
//  ItemDatabase.m
//  ZhihuDaily
//
//  Created by George She on 16/3/4.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "ItemDatabase.h"
#import "FMDB.h"

#define ITEM_DATABASE @"item.db"

@interface ItemDatabase ()
@property(nonatomic, strong) FMDatabase *database;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ItemDatabase
+ (instancetype)sharedInstance {
  static ItemDatabase *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ItemDatabase alloc] init];
  });
  return manager;
}

- (NSString *)databasePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  NSString *dbPath =
      [documentDirectory stringByAppendingPathComponent:ITEM_DATABASE];
  return dbPath;
}

- (void)dealloc {
  if (_database) {
    [_database close];
    _database = nil;
  }
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _database = [FMDatabase databaseWithPath:[self databasePath]];
    if ([_database open]) {
      if (![self isTableExisted]) {
        [self createTable];
      }
    } else {
      _database = nil;
    }
  }
  return self;
}

- (BOOL)isTableExisted {

  NSString *sql = @"SELECT COUNT(*) FROM sqlite_master where type='table' and "
      @"name='Item'";
  int nCount = 0;
  FMResultSet *rs = [_database executeQuery:sql];
  if ([rs next]) {
    nCount = [rs intForColumnIndex:0];
  }
  return nCount > 0;
}

- (BOOL)createTable {
  NSArray *sqlArr = @[
    @"CREATE TABLE IF NOT EXISTS Item (id INTEGER PRIMARY KEY \
						AUTOINCREMENT, itemId INTEGER, readDate TIMESTAMP)",
    @"CREATE INDEX ON Item(itemId)"
  ];

  for (NSString *sql in sqlArr) {
    [_database executeUpdate:sql];
  }
  return YES;
}

- (BOOL)isItemReadByUser:(long long)itemId {
  NSString *sql = [NSString
      stringWithFormat:@"SELECT id FROM Item WHERE itemId=%lld", itemId];
  FMResultSet *rs = [_database executeQuery:sql];
  if ([rs next]) {
    return YES;
  }
  return NO;
}

- (void)itemReadByUser:(long long)itemId {
  if ([self isItemReadByUser:itemId]) {
    return;
  }

  NSString *sql = @"INSERT INTO Item(itemId, readDate) VALUES(?, ?)";
  [_database executeUpdate:sql, @(itemId),
                           [_dateFormatter stringFromDate:[NSDate date]]];
}

@end
