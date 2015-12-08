//
//  ViewController.m
//  CXCacheDemo
//
//  Created by ChengxuZheng on 15/12/8.
//  Copyright © 2015年 ChengxuZheng. All rights reserved.
//

#import "ViewController.h"
#import "CXCacheManager.h"

@interface ViewController () {
    CXCacheManager *_manager;
}
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _manager = [CXCacheManager sharedManager];
    
    NSArray *arr = @[@"猴腮克诶",@"Super",@"一库",@"男人的浪漫",@"R闪"];
    
    [_manager openDatabaseWithTableName:@"ArrayData"];
    [_manager cacheData:arr];
    [_manager closeDatabase];
    
}


- (IBAction)buttonAction:(id)sender {
    [_manager openDatabaseWithTableName:@"ArrayData"];
    NSArray *arr = [_manager accessCacheData];
    [_manager closeDatabase];
    
    _textLabel.text = [NSString stringWithFormat:@"%@",arr[arc4random()%5]];
}

@end
