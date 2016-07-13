//
//  UITableView+CellHeightCalculation.h
//
//
//  Created by ZhangTinghui on 16/5/25.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CellHeightCalculation)

/**
 *  Remove all cached height.
 */
- (void)mf_removeAllCachedHeight;

/**
 *  Remove cached height for the specified key.
 *  @param key Key for the cached height.
 */
- (void)mf_removeCachedHeightForKey:(nonnull id<NSCopying>)key;

/**
 *  Calculate height for cell.
 *
 *  The height will not be cached, each time you call this method, height will be recalculated.
 *  If you want to cache the calculated height, please checkout the method:
 *  `mf_heightForCellWithIdentifier:cacheByKey:cellConfiguration:`
 *
 *  @param identifier    Reuse identifier for the cell, will be use to dequeue and cache the cell.
 *  @param configuration Configuration for the cell, in which let you to configure the cell.
 *  @return The height for the cell.
 */
- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration;

/**
 *  Calculate height for cell
 *
 *  The height will be cached with the `key`, so it will not be recalculated, unless it's be removed.
 *
 *  @param identifier    Reuse identifier for the cell, will be use to dequeue and cache the cell.
 *  @param key           Key for the cached height, will be use to cache the calculated height.
 *  @param configuration Configuration for the cell, in which let you to configure the cell.
 *  @return The height for the cell.
 */
- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                               cacheByKey:(nonnull id<NSCopying>)key
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration;

@end


