# Purpose

The basic idea is from this stackoverflow question: [http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights](http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights) ([in Chinese](http://codingobjc.com/blog/2014/10/15/shi-yong-autolayoutshi-xian-uitableviewde-celldong-tai-bu-ju-he-ke-bian-xing-gao/)). 

So this library is designed to simplifies the height calculation and cache for auto layout views. And we provide two components in this library: [MFViewHeightCache](#jump_to_0) and [UITableView+CellHeightCalculation](#jump_to_1).

# <span id="jump_to_0">MFViewHeightCache</span> 

MFViewHeightCache provides a simple way to calculate and cache the height of any kinds of auto layout views.

It basically adds a category method on UIView to calculates view's height, and then builds a cache on top of this method. 

```objc
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
```

#### Basically useage

The basically usage is cache the view first, then call the height calcualtion methods. For example:

```objc
// Let's say you have a heightCache property in your view controller.
@property (nonatomic, strong) MFViewHeightCache *heightCache;

// Cache view first.
- (MFViewHeightCache *)heightCache {
    if (_heightCache == nil) {
        _heightCache = [[MFViewHeightCache alloc] init];
        
        BookCell *cell = (BookCell *)[[[NSBundle mainBundle]
                                       loadNibNamed:NSStringFromClass([BookCell class])
                                       owner:nil
                                       options:nil]
                                      firstObject];
        [_heightCache cacheView:cell
                        withKey:NSStringFromClass([BookCell class])
         heightCalculatedByView:cell.contentView];
    }
    
    return _heightCache;
}

// Then use heightCache to calculate and cache view's height.
__weak typeof(self) weakSelf = self;
const CGFloat height = [self.heightCache
                        heightForViewWithKey:NSStringFromClass([BookCell class])
                        width:CGRectGetWidth(tableView.bounds)
                        heightCacheKey:dataDict[@"ISBN"]
                        viewConfiguration:^(__kindof UIView * _Nonnull view) {
                            [weakSelf _configureCell:(BookCell *)view
                                            withDict:dataDict];
                        }] + 1.0;
```

Or if you don't need the cache, you can just use one of these UIView's category methods to calculate view's height:

```objc
- (CGFloat)mf_heightForWidth:(CGFloat)width;
- (CGFloat)mf_heightForWidth:(CGFloat)width
               configuration:(nullable void(^)(void))configuration;
- (CGFloat)mf_heightForWidth:(CGFloat)width
   withHeightCalculationView:(nullable UIView *)view
               configuration:(nullable void(^)(void))configuration;
```

#### Installation by CocoaPods

To integrate MFViewHeightCache into your Xcode project using CocoaPods, specify it in your `Podfile`:

```objc
pod 'MFViewHeightCache', '~> 1.0.2'
```
	
# <span id="jump_to_1">UITableView+CellHeightCalculation</span> 


UITableView+CellHeightCalculation is an UITableView category that builds on top of MFViewHeightCache.

The APIs are very simple, basically all you have to do is in UITableViewDelegate `-tableView:heightForRowAtIndexPath:` method:

```objc
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView mf_heightForCellWithIdentifier:@"cell reuse identifer" cellConfiguration:^(__kindof UITableViewCell * _Nonnull cell) {
        //Configure cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
    }];
}
```

#### Installation by CocoaPods

To integrate UITableView+CellHeightCalculation into your Xcode project using CocoaPods, specify it in your `Podfile`:

```objc
pod 'UITableView+CellHeightCalculation', '~> 1.0.3'
```

# License
UITableView+CellHeightCalculation is distributed under an [MIT License](http://opensource.org/licenses/MIT).

> The MIT License (MIT)

> Copyright (c) 2016 Tinghui

> Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

> The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


