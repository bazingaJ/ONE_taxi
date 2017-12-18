//
//  JDBankCardCell.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDBankCardCell.h"

@implementation JDBankCardCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.addBankCardButton.layer.cornerRadius = 5.0;
    [self.bankCardButton setBackgroundImage:[UIImage imageNamed:@"中国银行"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
