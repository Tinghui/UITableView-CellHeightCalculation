//
//  MFViewHeightCache.h
//  
//
//  Created by ZhangTinghui on 2017/3/7.
//  Copyright © 2017年 www.morefun.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - UIView (MFViewHeightCache)

@interface UIView (MFViewHeightCache)

/**
 Use autolayout to calculate height.
 
 Same as: `[self mf_heightForWidth:width configuration:nil]`

 @param width View's max width.
 @return View's height for the width.
 */
- (CGFloat)mf_heightForWidth:(CGFloat)width;

/**
 Use autolayout to calculate height.

 Same as: `[self mf_heightForWidth:width withHeightCalculationView::self configuration:configuration]`
 
 @param width View's max width.
 @param configuration Configuration for the view before calculating height.
 @return View's height for the width.
 */
- (CGFloat)mf_heightForWidth:(CGFloat)width
               configuration:(nullable void(^)(void))configuration;

/**
 Use autolayout to calculate height.

 @param width View's max width.
 @param view View which used to calculate height.
 @param configuration Configuration for the view before calculating height.
 @return View's height for the width.
 */
- (CGFloat)mf_heightForWidth:(CGFloat)width
   withHeightCalculationView:(nullable UIView *)view
               configuration:(nullable void(^)(void))configuration;

@end





#pragma mark - MFViewHeightCache

@interface MFViewHeightCache : NSObject

/**
 Cache view for later calcualtion.

 @param view The view will be cached and configurated before calculate height.
 @param key The key for cache the `view`.
 @param heightCalculatedByView The view which will be use to calculate height. It should be the cached `view` or one of its subview which is response for perform layouts and calculate height (ex. the contentView of UITableViewCell/UICollectionViewCell). If this parameter is unspecified, the cached `view` will be use to perform layouts and calculate height.
 */
- (void)cacheView:(nonnull UIView *)view
          withKey:(nonnull NSString *)key
    heightCalculatedByView:(nullable UIView *)heightCalculatedByView;

/**
 Get height for view.
 
 If `heightCacheKey` is specified, the calculated height will be cached. 
 And if `width` is changed, height will be recalculated.
 

 @param viewKey Key for the cached view. @see also -cacheView:withKey:heightCalculatedByView
 @param width View's width for calculate height.
 @param heightCacheKey Key for cache the calculated height.
 @param configuration Configuration for the view.
 @return The height for the view with specified width.
 */
- (CGFloat)heightForViewWithKey:(nonnull NSString *)viewKey
                          width:(CGFloat)width
                 heightCacheKey:(nullable NSString *)heightCacheKey
              viewConfiguration:(nullable void (^)(__kindof UIView * _Nonnull view))configuration;

/**
 Remove all cached height.
 */
- (void)removeAllCachedHeight;

/**
 Remove cached height for specified key.

 @param key Key for cache height.
 */
- (void)removeCachedHeightForKey:(nonnull NSString *)key;

@end


