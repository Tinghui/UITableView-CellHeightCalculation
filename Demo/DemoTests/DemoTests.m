//
//  DemoTests.m
//  DemoTests
//
//  Created by ZhangTinghui on 16/7/12.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BookCell.h"
#import "MFViewHeightCache.h"


@interface DemoTests : XCTestCase
@property (nonatomic, strong) MFViewHeightCache *heightCache;
@property (nonatomic, strong) NSArray<NSMutableDictionary *> *books;
@end

@implementation DemoTests

- (void)setUp {
    [super setUp];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *books = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [books addObject:[obj mutableCopy]];
    }];
    self.books = books;
    
    
    BookCell *cell = (BookCell *)[[[NSBundle mainBundle]
                                   loadNibNamed:NSStringFromClass([BookCell class])
                                   owner:nil
                                   options:nil]
                                  firstObject];
    self.heightCache = [[MFViewHeightCache alloc] init];
    [self.heightCache cacheView:cell
                        withKey:NSStringFromClass([BookCell class])
         heightCalculatedByView:cell.contentView];
}

- (void)_configureCell:(BookCell *)cell withDict:(NSDictionary *)dict {
    cell.nameLabel.text = dict[@"Name"];
    cell.priceLabel.text = dict[@"Price"];
    cell.authorLabel.text = dict[@"Author"];
    cell.introLabel.text = ([dict[@"ShowMore"] boolValue] ? dict[@"Intro"] : nil);
}

- (void)testUnExpandCellHeightCalculation {
    __weak typeof(self) weakSelf = self;
    CGFloat height = [self.heightCache
                      heightForViewWithKey:NSStringFromClass([BookCell class])
                      width:375.0
                      heightCacheKey:nil
                      viewConfiguration:^(__kindof UIView * _Nonnull view) {
                          [weakSelf _configureCell:(BookCell *)view
                                          withDict:weakSelf.books[0]];
                      }] + 1.0;
    XCTAssertEqual(height, 123.00);
}

- (void)testExpandCellHeightCalculation {
    __weak typeof(self) weakSelf = self;
    NSArray *heights = @[@355.00, @570.00, @426.00, @373.00, @373.00, @373.00, @373.00];
    NSArray<NSMutableDictionary *> *books = [self.books copy];
    [books enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj[@"ShowMore"] = @YES;
        const CGFloat height = [self.heightCache
                                heightForViewWithKey:NSStringFromClass([BookCell class])
                                width:375.0
                                heightCacheKey:nil
                                viewConfiguration:^(__kindof UIView * _Nonnull view) {
                                    [weakSelf _configureCell:(BookCell *)view
                                                    withDict:obj];
                                }] + 1.0;
        XCTAssertEqual(height, [heights[idx] doubleValue]);
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
