//
//  JDRevenueHistoryViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/8/1.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDRevenueHistoryViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
@interface JDRevenueHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tabelV;
@property(nonatomic,copy)NSMutableArray * modelArr;
@property(nonatomic,copy)NSMutableArray * modelArr2;
@end

@implementation JDRevenueHistoryViewController{
    //用来判断section是否为打开状态
BOOL flag[100];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildViews];
    flag[0]=NO;
    
    

    
}
//设置视图所有的子控件
-(void)setUpAllChildViews{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * arr = [NSArray arrayWithObjects:@"日期",@"金额",@"积分",@"单数", nil];
    for (int i=0; i<4; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*JDScreenSize.width/4, 64, JDScreenSize.width/4, 40)];
        label.text  = arr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    _tabelV  = [[UITableView alloc]initWithFrame:CGRectMake(0,104, JDScreenSize.width, JDScreenSize.height-104) style:UITableViewStyleGrouped];
    _tabelV.delegate = self;
    _tabelV.dataSource = self;
    _tabelV.backgroundColor = [UIColor whiteColor];
    _tabelV.separatorStyle = UITableViewCellSelectionStyleNone;
    _tabelV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [_tabelV.mj_header beginRefreshing];
    [self.view addSubview:_tabelV];
    
}

-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"type"] = @"1";
    [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyRevenue.json"] params:params success:^(id response) {
        
        [self.tabelV.mj_header endRefreshing];
        JDLog(@"%@",response);
        _modelArr = [[NSMutableArray alloc]init];
        _modelArr2 = [[NSMutableArray alloc]init];
        int returnCode = [response[@"returnCode"] intValue];
        NSArray * arr = response[@"MonthRevenueArr"];
        if (returnCode == 0) {
            for (NSDictionary *dict in arr) {
                JDRevenueData *data = [JDRevenueData revenueDataWithDict:dict];
                [_modelArr addObject:data];
            }
            [_tabelV reloadData];
            for (int i = 0; i<arr.count; i++) {
                JDRevenueData * data = _modelArr[i];
                NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
                params2[@"phoneNo"] = PHONENO;
                params2[@"loginTime"] = LOGINTIME;
                params2[@"month"] = data.payMonth;
                params2[@"type"] = @"2";
                JDLog(@"%@",data.payMonth);

                [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyRevenue.json"] params:params2 success:^(id response) {
                    [self.tabelV.mj_header endRefreshing];
                    JDLog(@"%@",response);
                    int returnCode = [response[@"returnCode"] intValue];
                    NSArray * arr = response[@"MonthRevenueDetailArr"];
                    if (returnCode == 0) {
                        [_modelArr2 addObject:arr];
                        JDLog(@"%@",_modelArr2);
                    }else{
                        [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
                            
                        }];
                    }
                    
                } failure:^(NSError *error) {
                }];

            }
                    }else{
            [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
            }];
        }
        
    } failure:^(NSError *error) {
    }];
    

}


#pragma Mark-----tableView delegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (flag[section]) {
        NSArray * arr = self.modelArr2[section];
        return arr.count;
    }else{
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JDRevenueData *data = _modelArr[section];
    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, JDScreenSize.width, 170/2);
    for (int i = 0; i<4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*JDScreenSize.width/4, 0, JDScreenSize.width/4, 170/2)];
        if (i==0) {
            NSString *str = data.payMonth;
            NSString *payMonth =[str substringFromIndex:4];
            if ([[payMonth substringToIndex:1]isEqualToString:@"0"]) {
                NSString *payM = [payMonth substringFromIndex:1];
                [label setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"%@月",payM] andFrontFont:40 andRange:NSMakeRange(0,1) andLastFont:14 andlastRange:NSMakeRange(1, 1)]];
            }else{
        [label setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"%@月",payMonth] andFrontFont:40 andRange:NSMakeRange(0, 2) andLastFont:14 andlastRange:NSMakeRange(2, 1)]];
            }
        }else if (i==1){
        label.text = [NSString stringWithFormat:@"%@",data.allMoney];
            label.font = [UIFont systemFontOfSize:20];
        }else if (i==2){
        label.text = [NSString stringWithFormat:@"%@",data.allIntegrate];
            label.font = [UIFont systemFontOfSize:20];
        }else{
        label.text = [NSString stringWithFormat:@"%@",data.allCount];
            label.font = [UIFont systemFontOfSize:20];
        }
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
    }
    
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    openBtn.frame =headerView.frame;
    openBtn.tag =section +10;
    [openBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:openBtn];
    
    CGSize size=[UIImage imageNamed:@"展开按钮"].size;
    UIImageView *imageV = [UIImageView new];
    imageV.frame = CGRectMake(JDScreenSize.width/2-size.width/2, 170/2-size.height, size.width, size.height);
    imageV.image = [UIImage imageNamed:@"展开按钮"];
    [headerView addSubview:imageV];
    //旋转展开，将图片旋转pi
    if (flag[section])
    {
        imageV.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else
    {
        imageV.transform =CGAffineTransformIdentity;
    }
    return headerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary *dict in _modelArr2[indexPath.section]) {
        JDRevenueData * data = [JDRevenueData revenueDataWithDict:dict];
        [arr addObject:data];
    }
    JDRevenueData * data  = arr[indexPath.row];
   static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    for (int i = 0; i<4; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*JDScreenSize.width/4, 0, JDScreenSize.width/4, 33)];
        if (i==0) {
            NSString * str = [data.payTime substringWithRange:NSMakeRange(4, 2)];
            NSString * str2 = [data.payTime substringWithRange:NSMakeRange(6, 2)];
            if ([[str substringToIndex:1] isEqualToString:@"0"]) {
                str = [str substringFromIndex:1];
            }
            if ([[str2 substringToIndex:1]isEqualToString:@"0"]) {
                str2 = [str2 substringFromIndex:1];
            }
            label.text = [NSString stringWithFormat:@"%@-%@",str,str2];
        }else if (i==1){
            label.text = [NSString stringWithFormat:@"%@",data.money];
        }else if (i==2){
            label.text =[NSString stringWithFormat:@"%@",data.integral];
        }else{
            label.text =[NSString stringWithFormat:@"%@",data.count];
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//展开按钮的触发事件
- (void)openOrClose:(UIButton *)button
{
    
    int section =(int)button.tag -10;
    flag[section] = !flag[section];

    JDRevenueData *data = _modelArr[section];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"month"] = data.payMonth;
    params[@"type"] = @"2";
    
    [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyRevenue.json"] params:params success:^(id response) {
        
        [self.tabelV.mj_header endRefreshing];
//      _modelArr2 = [[NSMutableArray alloc]init];
        int returnCode = [response[@"returnCode"] intValue];
        NSArray * arr = response[@"MonthRevenueDetailArr"];
        if (returnCode == 0) {
//            for (NSDictionary *dict in arr) {
//                JDRevenueData *data = [JDRevenueData revenueDataWithDict:dict];
                [_modelArr2 replaceObjectAtIndex:section withObject:arr];
//
//            }
        [_tabelV reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
//
         //[_tabelV reloadData];
        }else{
            
            [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
                
            }];
        }
        
    } failure:^(NSError *error) {
    }];
}
//根据要求调整一个label里的字体大小
-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText andFrontFont:(CGFloat)frontFont andRange:(NSRange)range andLastFont:(CGFloat)lastFont andlastRange:(NSRange)lastRange
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:frontFont];
    [attrString addAttribute:NSFontAttributeName value:font range:range];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:lastFont] range:lastRange];
    
    return attrString;
}

- (void)didReceiveMemoryWarning { 
    [super didReceiveMemoryWarning];
    
}



@end
