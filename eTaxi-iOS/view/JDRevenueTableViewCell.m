//
//  JDRevenueTableViewCell.m
//  eTaxi-iOS
//
//  Created by jeader on 16/8/1.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDRevenueTableViewCell.h"

@implementation JDRevenueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSInteger i;
    CGFloat width=(JDScreenSize.width-40)/4;
    if (JDScreenSize.width ==320) {
        i = 18;
    }else if(JDScreenSize.width==375){
    
        i = 0;
    }else{
        i = -5;
    }
    JDLog(@"%ld",(long)i);
    _payTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 0,width+10, 20)];
    _payTime.textAlignment = NSTextAlignmentLeft;
    _payTime.font = [UIFont systemFontOfSize:12];
    [self addSubview:_payTime];
    
    
    _payWay = [[UILabel alloc]initWithFrame:CGRectMake(width+20, 0, width+i, 20)];
    _payWay.textAlignment = NSTextAlignmentCenter;
    _payWay.font = [UIFont systemFontOfSize:12];
    [self addSubview:_payWay];
    
    
    _money = [[UILabel alloc]initWithFrame:CGRectMake(width*2+20, 0, width+i, 20)];
    _money.textAlignment = NSTextAlignmentCenter;
    _money.font = [UIFont systemFontOfSize:12];
    [self addSubview:_money];
    
    _integrate = [[UILabel alloc]initWithFrame:CGRectMake(width*3+20, 0, width+i, 20)];
    _integrate.textAlignment = NSTextAlignmentCenter;
    _integrate.font = [UIFont systemFontOfSize:12];
    [self addSubview:_integrate];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
