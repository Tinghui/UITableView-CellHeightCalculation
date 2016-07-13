//
//  BookCell.h
//  Demo
//
//  Created by ZhangTinghui on 16/7/12.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
@property (nonatomic, strong) IBOutlet UILabel *introLabel;

@property (nonatomic, copy) void(^showMoreButtonDidPressed)(void);

@end
