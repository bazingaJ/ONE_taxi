//
//  JDRevenueData.m
//  eTaxi-iOS
//
//  Created by jeader on 16/8/1.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDRevenueData.h"
#import "MJExtension.h"
@implementation JDRevenueData

+(instancetype)revenueDataWithDict:(NSDictionary *)dict{
    JDRevenueData *data = [[JDRevenueData alloc]init];
    if (dict[@"allIntegrate"]!=nil) {
         data.allIntegrate = dict[@"allIntegrate"];
    }
    if (dict[@"allList"]) {
        data.allList = dict[@"allList"];
    }
    if ( dict[@"allMoney"]) {
        data.allMoney = dict[@"allMoney"];
    }
    if (dict[@"cashPayMoney"]) {
        data.cashPayMoney = dict[@"cashPayMoney"];
    }
    if (dict[@"onlinPayMoney"]) {
        data.onlinPayMoney = dict[@"onlinPayMoney"];
    }
    if (dict[@"revenueDetailArr"]) {
        data.revenueDetailArr = dict[@"revenueDetailArr"];
    }
    if (dict[@"revenueDetailArr"]) {
        data.revenueDetailArr = dict[@"revenueDetailArr"];
    }
    if (dict[@"integrate"]) {
        data.integrate = dict[@"integrate"];
    }
    if (dict[@"money"]) {
        data.money = dict[@"money"];
    }
    if (dict[@"payTime"]) {
        data.payTime = dict[@"payTime"];
    }
    if (dict[@"payTime"]) {
        data.payTime = dict[@"payTime"];

    }
    if (dict[@"payWay"]) {
        data.payWay = dict[@"payWay"];
    }
    if (dict[@"allCount"]) {
        data.allCount = dict[@"allCount"];
    }
    if (dict[@"payMonth"]) {
        data.payMonth = dict[@"payMonth"];
    }
    if (dict[@"count"]) {
        data.count = dict[@"count"];
    }
    if (dict[@"money"]) {
        data.money = dict[@"money"];
    }
    if (dict[@"integral"]) {
        data.integral = dict[@"integral"];
    }
    
    
    return data;
}


@end
