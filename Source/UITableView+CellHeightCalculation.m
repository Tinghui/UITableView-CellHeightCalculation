//
//  UITableView+CellHeightCalculation.m
//
//
//  Created by ZhangTinghui on 16/5/25.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+CellHeightCalculation.h"

#if __has_include(<MFViewHeightCache/MFViewHeightCache.h>)
#import <MFViewHeightCache/MFViewHeightCache.h>
#else
#import "MFViewHeightCache.h"
#endif


@implementation UITableView (CellHeightCalculation)

#pragma mark - Height Cache
- (MFViewHeightCache *)_mf_heightCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MFViewHeightCache *cache = [[MFViewHeightCache alloc] init];
        objc_setAssociatedObject(self, @selector(_mf_heightCache), cache, OBJC_ASSOCIATION_RETAIN);
    });
    
    return objc_getAssociatedObject(self, @selector(_mf_heightCache));
}

- (void)mf_removeAllCachedHeight {
    [[self _mf_heightCache] removeAllCachedHeight];
}

- (void)mf_removeCachedHeightForKey:(nonnull NSString *)key {
    [[self _mf_heightCache] removeCachedHeightForKey:key];
}

#pragma mark - Cell Cache
- (NSMutableDictionary *)_mf_cellCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(_mf_cellCache), dict, OBJC_ASSOCIATION_RETAIN);
    });
    
    return objc_getAssociatedObject(self, @selector(_mf_cellCache));
}

#pragma mark - Height Calculation
- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration {
    return [self mf_heightForCellWithIdentifier:identifier
                                     cacheByKey:nil
                              cellConfiguration:configuration];
}

- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                               cacheByKey:(nullable NSString *)key
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration {
    //cache cell if first use.
    NSAssert(identifier != nil, @"cell identifier should not be nil.");
    if ([self _mf_cellCache][identifier] == nil) {
        UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
        NSAssert(cell != nil, @"Can't dequeue an cell with identifier: \"%@\", Please make sure the cell has been registered before you use it", identifier);
        if (cell != nil) {
            [self _mf_cellCache][identifier] = @YES;
        }
        [[self _mf_heightCache] cacheView:cell
                                  withKey:identifier
                   heightCalculatedByView:cell.contentView];
    }
    
    return [[self _mf_heightCache]
            heightForViewWithKey:identifier
            width:CGRectGetWidth(self.bounds)
            heightCacheKey:key
            viewConfiguration:^(__kindof UIView * _Nonnull view) {
                if (configuration) {
                    configuration((UITableViewCell *)view);
                }
            }] + 1.0;
}

@end



