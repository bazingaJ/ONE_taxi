//
//  JDOutputCell.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDOutputCell.h"
#import "GetData.h"
#import "HeadFile.pch"
#include "JDOutputViewController.h"

@implementation JDOutputCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.sureButton.layer.cornerRadius = 3.0;
    self.sureButton.layer.masksToBounds = YES;
    [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchDown];
}

-(void)sureButtonClick{
    JDLog(@"1111");
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
