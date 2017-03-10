//
//  MFViewHeightCache.m
//
//
//  Created by ZhangTinghui on 2017/3/7.
//  Copyright © 2017年 www.morefun.mobi. All rights reserved.
//

#import "MFViewHeightCache.h"

#pragma mark - UIView (MFViewHeightCache)

@implementation UIView (MFViewHeightCache)

- (CGFloat)mf_heightForWidth:(CGFloat)width {
    return [self mf_heightForWidth:width configuration:nil];
}

- (CGFloat)mf_heightForWidth:(CGFloat)width configuration:(nullable void(^)(void))configuration {
    return [self mf_heightForWidth:width withHeightCalculationView:self configuration:configuration];
}

- (CGFloat)mf_heightForWidth:(CGFloat)width
   withHeightCalculationView:(nullable UIView *)view
               configuration:(nullable void(^)(void))configuration {
    NSAssert(self.translatesAutoresizingMaskIntoConstraints, @"View must be auto layout enabled.");

    if (configuration != nil) {
        configuration();
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setBounds:CGRectMake(0.0, 0.0, width, CGFLOAT_MAX)];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return ceil([(view ?: self) systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
}

@end





#pragma mark - MFViewHeightCachedView

@interface MFViewHeightCachedView : NSObject
@property (nonatomic, strong, nonnull) UIView *view;
@property (nonatomic, strong, nonnull) UIView *heightCalculationView;
@end

@implementation MFViewHeightCachedView
@end





#pragma mark - MFViewHeightCachedHeight

@interface MFViewHeightCachedHeight : NSObject
@property (nonatomic, assign) CGFloat calculationWidth;
@property (nonatomic, assign) CGFloat calculatedHeight;
@end

@implementation MFViewHeightCachedHeight
@end





#pragma mark - MFViewHeightCache

@interface MFViewHeightCache ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, MFViewHeightCachedView *> *viewCache;
@property (nonatomic, strong) NSMutableDictionary<NSString *, MFViewHeightCachedHeight *> *heightCache;
@end

@implementation MFViewHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewCache = [NSMutableDictionary dictionary];
        self.heightCache = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark View Cache

- (void)cacheView:(nonnull UIView *)view
          withKey:(nonnull NSString *)key
    heightCalculatedByView:(nullable UIView *)heightCalculatedByView {
    
    NSParameterAssert(view != nil && key != nil);
    MFViewHeightCachedView *cachedView = [[MFViewHeightCachedView alloc] init];
    cachedView.view = view;
    cachedView.heightCalculationView = (heightCalculatedByView ?: view);
    self.viewCache[key] = cachedView;
}

#pragma mark Height Cache

- (CGFloat)heightForViewWithKey:(nonnull NSString *)viewKey
                          width:(CGFloat)width
                 heightCacheKey:(nullable NSString *)heightCacheKey
              viewConfiguration:(nullable void (^)(__kindof UIView * _Nonnull view))configuration {
    NSParameterAssert(viewKey != nil && width > 0.000001);
    
    //hit cached height
    if (heightCacheKey != nil) {
        MFViewHeightCachedHeight *cache = self.heightCache[heightCacheKey];
        if (cache != nil && fabs(cache.calculationWidth - width) < 0.000001) {
            return cache.calculatedHeight;
        }
    }
    
    //find the cached view for perform view configuration
    MFViewHeightCachedView *cachedView = self.viewCache[viewKey];
    NSAssert(cachedView != nil, @"Can't find the cached view, you need call method -cacheView:withKey:heightCalculatedByView: first.");
    
    //calculate height
    const CGFloat height = [cachedView.view
                            mf_heightForWidth:width
                            withHeightCalculationView:cachedView.heightCalculationView
                            configuration:^{
                                if (configuration) {
                                    configuration(cachedView.view);
                                }
                            }];
    
    //cache height
    if (heightCacheKey != nil) {
        MFViewHeightCachedHeight *cache = [[MFViewHeightCachedHeight alloc] init];
        cache.calculationWidth = width;
        cache.calculatedHeight = height;
        self.heightCache[heightCacheKey] = cache;
    }
    
    return height;
}

- (void)removeAllCachedHeight {
    [self.heightCache removeAllObjects];
}

- (void)removeCachedHeightForKey:(nonnull NSString *)key {
    NSParameterAssert(key != nil);
    [self.heightCache removeObjectForKey:key];
}

@end


