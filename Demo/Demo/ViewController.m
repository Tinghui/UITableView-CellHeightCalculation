//
//  ViewController.m
//  Demo
//
//  Created by ZhangTinghui on 16/7/12.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import "ViewController.h"
#import "BookCell.h"
#import "UITableView+CellHeightCalculation.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSMutableDictionary *> *books;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _configureTableView];
    [self _loadBooksDataAndReloadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)_loadBooksDataAndReloadTableView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *books = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [books addObject:[obj mutableCopy]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.books = books;
            [self.tableView reloadData];
        });
    });
}

- (NSMutableDictionary *)_bookDictAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.books.count) {
        return nil;
    }
    
    return self.books[index];
}

#pragma mark - TableView 
- (void)_configureTableView {
    NSArray *cellNames = @[NSStringFromClass([BookCell class])];
    for (NSString *name in cellNames) {
        [self.tableView registerNib:[UINib nibWithNibName:name bundle:nil]
             forCellReuseIdentifier:name];
    }
}

- (void)_configureCell:(BookCell *)cell atIndex:(NSInteger)index {
    NSMutableDictionary *dict = [self _bookDictAtIndex:index];
    cell.nameLabel.text = dict[@"Name"];
    cell.priceLabel.text = dict[@"Price"];
    cell.authorLabel.text = dict[@"Author"];
    
    const BOOL showMore = [dict[@"ShowMore"] boolValue];
    cell.introLabel.text = (showMore? dict[@"Intro"]: nil);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const kIdentifier = NSStringFromClass([BookCell class]);
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    [self _configureCell:cell atIndex:indexPath.row];
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    [cell setShowMoreButtonDidPressed:^{
        NSMutableDictionary *dict = [self _bookDictAtIndex:indexPath.row];
        dict[@"ShowMore"] = @(![dict[@"ShowMore"] boolValue]);
        [weakSelf.tableView mf_removeCachedHeightForKey:dict[@"ISBN"]];
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            [weakCell layoutIfNeeded];
        }];
    }];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *dict = [self _bookDictAtIndex:indexPath.row];
    return [tableView mf_heightForCellWithIdentifier:NSStringFromClass([BookCell class])
                                          cacheByKey:dict[@"ISBN"]
                                   cellConfiguration:^(__kindof UITableViewCell * _Nonnull cell) {
                                       [weakSelf _configureCell:cell atIndex:indexPath.row];
                                   }];
}


@end


