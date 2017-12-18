//
//  JDRevenueData.h
//  eTaxi-iOS
//
//  Created by jeader on 16/8/1.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDRevenueData : NSObject
//总钱数
@property(nonatomic,copy)NSString *allMoney;
//支付方式
@property(nonatomic,copy)NSString *payWay;
//所有积分
@property(nonatomic,copy)NSString *allIntegrate;
//现金支付钱数
@property(nonatomic,copy)NSString *cashPayMoney;
//在线支付钱数
@property(nonatomic,copy)NSString *onlinPayMoney;
//营收明细数组
@property(nonatomic,copy)NSArray *revenueDetailArr;
//支付时间
@property(nonatomic,copy)NSString *payTime;
//支付钱数
@property(nonatomic,copy)NSString *money;
//积分抵扣
@property(nonatomic,copy)NSString *integrate;

@property(nonatomic,copy)NSString *allList;

@property(nonnull,copy)NSString *allCount;

@property(nonnull,copy)NSString *payMonth;

@property(nonnull,copy)NSString *count;

@property(nonnull,copy)NSString *integral;



+(instancetype)revenueDataWithDict:(NSDictionary *)dict;
@end
