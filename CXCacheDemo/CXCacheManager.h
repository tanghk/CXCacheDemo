//
//  CXCacheManager.h
//  CXCacheDemo
//
//  Created by ChengxuZheng on 15/12/8.
//  Copyright © 2015年 ChengxuZheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXCacheManager : NSObject {
    FMDatabase *_db;        
    NSString *_tableName;
}

+ (instancetype)sharedManager;

- (void)openDatabaseWithTableName:(NSString *)name;

- (void)closeDatabase;

- (void)cacheData:(id)data;

- (id)accessCacheData;


@end
