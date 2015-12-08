//
//  CXCacheManager.m
//  CXCacheDemo
//
//  Created by ChengxuZheng on 15/12/8.
//  Copyright © 2015年 ChengxuZheng. All rights reserved.
//

#import "CXCacheManager.h"

@implementation CXCacheManager
+ (instancetype)sharedManager {
    static CXCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CXCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self database];
    }
    return self;
}


- (NSString *)databasePath {
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Cache.sqlite"];
}


- (void)database {
    _db = [FMDatabase databaseWithPath:[self databasePath]];
}


- (void)openDatabaseWithTableName:(NSString *)name {
    _tableName = name;
    [_db open];
}


- (void)closeDatabase {
    [_db close];
}

- (void)cacheData:(id)data {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TableState"] isEqualToString:@"TableYES"]) {
        NSString *dropSqlStr = [NSString stringWithFormat:@"DROP TABLE %@",_tableName];
        [_db executeUpdate:dropSqlStr];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TableState"];
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, jsonData text NOT NULL);",_tableName];
    [_db executeUpdate:sqlStr];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"INSERT INTO %@ (jsonData) VALUES (?);",_tableName];
    [_db executeUpdate:path,dataStr];
    [[NSUserDefaults standardUserDefaults] setObject:@"TableYES" forKey:@"TableState"];

}


- (id)returnData {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT jsonData FROM %@",_tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    while ([set next]) {
        NSString *dataStr  = [set stringForColumn:@"jsonData"];
        return [dataStr objectFromJSONString];
    }
    return nil;
}


- (id)accessCacheData {
    if ([[[self returnData] class] isSubclassOfClass:[NSArray class]]) {
        return (NSArray *)[self returnData];
    }
    if ([[[self returnData] class] isSubclassOfClass:[NSDictionary class]]) {
        return (NSDictionary *)[self returnData];
    }
    return nil;
}

@end
