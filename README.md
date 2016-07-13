# Purpose

UITableView+CellHeightCalculation is an UITableView category that simplifies the height calculation of auto layout cells.

For how to using auto layout in UITableView for dynamic cell layouts & variable row heights, see this stackoverflow question: [http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights](http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights), or [this article in Chinese](http://codingobjc.com/blog/2014/10/15/shi-yong-autolayoutshi-xian-uitableviewde-celldong-tai-bu-ju-he-ke-bian-xing-gao/).

The APIs are very simple, basically all you have to do is in UITableViewDelegate `-tableView:heightForRowAtIndexPath:` method:

```objc
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView mf_heightForCellWithIdentifier:@"cell reuse identifer" cellConfiguration:^(__kindof UITableViewCell * _Nonnull cell) {
        //Configure cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
    }];
}
```

#### Height Caching

If you want to cache the height, you can use the similar method which has a `cacheByKey:(nonnull id<NSCopying>)key` parameter and provide a key to cache the height:

```objc
- (CGFloat)mf_heightForCellWithIdentifier:(nonnull NSString *)identifier
                               cacheByKey:(nonnull id<NSCopying>)key
                        cellConfiguration:(nonnull void (^)(__kindof UITableViewCell * _Nonnull cell))configuration;
```

For removing the cached height, there are two APIs, one for removing all, one for removing specified one:

```objc
- (void)mf_removeAllCachedHeight;
- (void)mf_removeCachedHeightForKey:(nonnull id<NSCopying>)key;
```

For more details, please checkout the demo project in this repository.



# Installation by CocoaPods

1. Add `pod 'UITableView+CellHeightCalculation', '~> 1.0.0'` to your Podfile.
2. Install by running `pod install` .
3. Include it wherever you need with `#import <UITableView+CellHeightCalculation/UITableView+CellHeightCalculation.h>` .

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
