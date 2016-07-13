//
//  BookCell.m
//  Demo
//
//  Created by ZhangTinghui on 16/7/12.
//  Copyright © 2016年 www.morefun.mobi. All rights reserved.
//

#import "BookCell.h"

@implementation BookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)_buttonPressed:(id)sender {
    if (self.showMoreButtonDidPressed) {
        self.showMoreButtonDidPressed();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.introLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.authorLabel.bounds);
}

@end
