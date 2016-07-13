//
//  UITableView+CellHeightCalculation.m
//
//
//  Created by ZhangTinghui on 16/5/25.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+CellHeightCalculation.h"


@implementation UITableView (CellHeightCalculation)

#pragma mark - Height Cache
- (NSMutableDictionary *)_mf_heightCache {
    id dict = objc_getAssociatedObject(self, @selector(_mf_heightCache));
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(_mf_heightCache), dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (void)mf_removeAllCachedHeight {
    [[self _mf_heightCache] removeAllObjects];
}

- (void)mf_removeCachedHeightForKey:(nonnull id<NSCopying>)key {
    [[self _mf_heightCache] removeObjectForKey:key];
}

#pragma mark - Cell Cache
- (NSMutableDictionary *)_mf_cellCache {
    id dict = objc_getAssociatedObject(self, @selector(_mf_cellCache));
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(_mf_cellCache), dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (UITableViewCell *)_mf_cellForIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return nil;
    }
    
    UITableViewCell *cell = [self _mf_cellCache][identifier];
    if (cell == nil) {
        cell = [self dequeueReusableCellWithIdentifier:identifier];
        
        NSAssert(cell != nil, @"Can't dequeue an cell with identifier: \"%@\", Please make sure the cell has been registered before you use it", identifier);
        
        if (cell != nil) {
            [self _mf_cellCache][identifier] = cell;
        }
    }
    
    return cell;
}

#pragma mark - Height Calculation
- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                               cacheByKey:(nonnull id<NSCopying>)key
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration {
    
    if (identifier == nil || key == nil) {
        return 0.0;
    }
    
    NSNumber *cachedHeightNumber = [self _mf_heightCache][key];
    if (cachedHeightNumber != nil) {
        return cachedHeightNumber.doubleValue;
    }
    
    CGFloat height = [self mf_heightForCellWithIdentifier:identifier cellConfiguration:configuration];
    [self _mf_heightCache][key] = [NSNumber numberWithDouble:height];
    return height;
}

- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration {
    if (identifier == nil) {
        return 0.0;
    }
    
    UITableViewCell *cell = [self _mf_cellForIdentifier:identifier];
    if (cell == nil) {
        return 0.0;
    }
    
    /*
     * Idea is from => http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
     * In Chinese => http://codingobjc.com/blog/2014/10/15/shi-yong-autolayoutshi-xian-uitableviewde-celldong-tai-bu-ju-he-ke-bian-xing-gao/
     */
    if (configuration) {
        configuration(cell);
    }
    
    NSAssert(CGRectGetWidth(self.bounds) > 0.0, @"TableView's width is 0.0, it may lead the calculation wrong. \n \
             May be tableView's frame is initialized CGRectZero and layout has not updated.");
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setBounds:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(cell.bounds))];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return ceil(height + 1.0);
}

@end



