//
//  JDRevenueViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/7/27.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDRevenueViewController.h"
#import "HeadFile.pch"
#import "MBProgressHUD.h"
#import "MyTool.h"
#import "UIViewController+CustomModelView.h"
#import "GetData.h"
#import "PersonalVC.h"
#import "MyData.h"
#import "MJRefresh.h"
#import "HeadFile.pch"
#import "JDRevenueData.h"
#import "JDRevenueTableViewCell.h"
#import "JDRevenueHistoryViewController.h"

@interface JDRevenueViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *backGroudView;

@property(nonatomic,strong)UIImageView *backGroundImageV;

@property(nonnull,strong)UITableView *tableView;

@property(nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,strong)UILabel *integralLabel;

@property(nonatomic,strong)UILabel *onlinePayLabel;

@property(nonatomic,strong)UILabel *cashPayLabel;

@property(nonatomic,strong)UILabel *allList;

@property(nonatomic,copy)NSMutableArray * modelArr;

@property(nonatomic,copy)NSMutableArray * modelArr2;
@end

@implementation JDRevenueViewController{
    CGSize _y3;
    CGSize _y4;

}
-(NSMutableArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViews];
    [self addNavigationBar:@"我的营收"];
    [self addRightBtnWithTitle:@"营收历史" font:12 action:@selector(clickRightItem)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//获取数据
-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"type"] = @"0";
    [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyRevenue.json"] params:params success:^(id response) {
        
        [self.tableView.mj_header endRefreshing];
        JDLog(@"%@",response);
        int returnCode = [response[@"returnCode"] intValue];
        if (returnCode == 0) {
            
            NSArray *arr = [NSArray arrayWithObject:response];
            
            _modelArr = [[NSMutableArray alloc]init];
            _modelArr2 = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in arr) {
                
                
                JDRevenueData *data = [JDRevenueData revenueDataWithDict:dict];
                
                JDLog(@"%@",data.allList);
                [_modelArr2 addObject:data];
                
                for (NSDictionary *dict in data.revenueDetailArr) {
                    JDRevenueData * data = [JDRevenueData revenueDataWithDict:dict];
                    [_modelArr addObject:data];
                    
                }
                if (_modelArr.count==0) {
                    JDNoMessageView *noMessView = [[JDNoMessageView alloc] initWithFrame:CGRectMake(0, 150, JDScreenSize.width, self.tableView.bounds.size.height)];
                    noMessView.message = @"当前没有营收记录";
                    [self.tableView addSubview:noMessView];
                }

                
                [_tableView reloadData];
                JDLog(@"%lu",(unsigned long)_modelArr.count);
            }
            
            
            
        }else{//强制退出
            
            [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
                
               }];
            
        }
        
        
        
    } failure:^(NSError *error) {
    }];
    
    
}

//创建视图上的子控件
-(void)setUpAllChildViews{
    _y3 = [self sizeWithText:@"" font:[UIFont systemFontOfSize:15]];
    _y4 = [self sizeWithText:@"" font:[UIFont systemFontOfSize:12]];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, JDScreenSize.width, 312+_y3.height+_y4.height)];
    view.backgroundColor = [UIColor whiteColor];
    _backGroudView = view;
    [self.view addSubview:view];
    
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"上半部渐变背景"];
    imageV.frame = CGRectMake(0, 0, JDScreenSize.width, 560/2);
    _backGroundImageV = imageV;
    [view addSubview:_backGroundImageV];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, JDScreenSize.width, 20)];
    label.text = @"今日营收";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_backGroundImageV addSubview:label];
    
    CGSize y = [self sizeWithText:@"" font:[UIFont systemFontOfSize:66]];
    UILabel * moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 166/2, JDScreenSize.width/2, y.height)];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    [moneyLabel setAttributedText:[self changeLabelWithText:@"¥0 " andFrontFont:33 andRange:NSMakeRange(0, 1) andLastFont:66 andlastRange:NSMakeRange(1, 2)]];
    _moneyLabel = moneyLabel;
    [_backGroundImageV addSubview:_moneyLabel];
    
    
    UILabel * integralLabel =[[UILabel alloc]initWithFrame:CGRectMake(JDScreenSize.width/2, 166/2, JDScreenSize.width/2, y.height)];
    integralLabel.textColor = [UIColor whiteColor];
    integralLabel.textAlignment = NSTextAlignmentCenter;
    [integralLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"0积分"] andFrontFont:66 andRange:NSMakeRange(0, 1) andLastFont:24 andlastRange:NSMakeRange(1, 2)]];
    _integralLabel = integralLabel;
    [_backGroundImageV addSubview:_integralLabel];
    
    CGSize y2 = [self sizeWithText:@"111" font:[UIFont systemFontOfSize:19]];
    UILabel * onlinPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, 166/2+y.height+51, JDScreenSize.width/3, y2.height)];
    onlinPayMoney.textAlignment = NSTextAlignmentCenter;
    onlinPayMoney.textColor = [UIColor whiteColor];
    onlinPayMoney.text = @"¥0";
    _onlinePayLabel = onlinPayMoney;
    [_backGroundImageV addSubview:_onlinePayLabel];
    
    
    UILabel *cashPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(JDScreenSize.width/3, 166/2+y.height+51, JDScreenSize.width/3, y2.height)];
    cashPayMoney.textAlignment = NSTextAlignmentCenter;
    cashPayMoney.textColor = [UIColor whiteColor];
    cashPayMoney.text = @"¥0";
    _cashPayLabel = cashPayMoney;
    [_backGroundImageV addSubview:_cashPayLabel];
    
    
    UILabel *overallLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*JDScreenSize.width/3, 166/2+y.height+51, JDScreenSize.width/3, y2.height)];
    overallLabel.textAlignment = NSTextAlignmentCenter;
    overallLabel.textColor = [UIColor whiteColor];
    overallLabel.text = @"0";
    _allList = overallLabel;
    [_backGroundImageV addSubview:_allList];
    
    
    NSArray * arr = [[NSArray alloc]initWithObjects:@"在线支付",@"现金支付",@"总单数", nil];
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*JDScreenSize.width/3, 166/2+y.height+51+y2.width, JDScreenSize.width/3,y2.height)];
        label.text = arr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_backGroundImageV addSubview:label];
        
        
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(JDScreenSize.width/2, 114/2+28, 1, 148/2)];
    line.backgroundColor = COLORWITHRGB(139, 192, 255, 1);
    [_backGroundImageV addSubview:line];
    
    for (int i = 1; i<3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*JDScreenSize.width/3, 166/2+y.height+51, 1, 98/2)];
        label.backgroundColor = COLORWITHRGB(30, 120, 228, 1);
        [_backGroundImageV addSubview:label];
    }
    CGSize size=[UIImage imageNamed:@"account_balance"].size;
    UIImageView *revenueP = [[UIImageView alloc]initWithFrame:CGRectMake(36/2, 16/2+_backGroundImageV.frame.size.height, size.width, size.height)];
    revenueP.image = [UIImage imageNamed:@"account_balance"];
    [view addSubview:revenueP];
    
    UILabel *revenueL = [[UILabel alloc]initWithFrame:CGRectMake(36/2+size.width+5, 16/2+_backGroundImageV.frame.size.height-2, 100, _y3.height)];
    revenueL.text = @"营收明细";
    revenueL.font =[UIFont systemFontOfSize:15];
    revenueL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:revenueL];
    
    NSArray *arr2 = [NSArray arrayWithObjects:@"付款时间",@"结算方式",@"实收",@"积分", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"时间",@"付款方式",@"实收",@"积分", nil];
    CGFloat leftX=18;
    CGFloat width=(JDScreenSize.width-18)/4;
    CGSize ss=[UIImage imageNamed:@"时间"].size;
    for (int i=0; i<4; i++) {
        UIView * vc=[[UIView alloc]init];
        [view addSubview:vc];
        vc.frame=CGRectMake(leftX+i*width,16/2+_backGroundImageV.frame.size.height+13+size.height , width, _y4.height);
        UIImageView * img=[[UIImageView alloc]init];
        [vc addSubview:img];
        if (i==1) {
            img.frame=CGRectMake(6,0, ss.width, ss.height);
        }else if (i==2){
            img.frame=CGRectMake(12,0, ss.width, ss.height);
        }else if (i==3){
            img.frame=CGRectMake(9,0, ss.width, ss.height);
        }else{
            img.frame=CGRectMake(0,0, ss.width, ss.height);
        }
        img.image=[UIImage imageNamed:arr3[i]];
        UILabel * lb=[[UILabel alloc]init];
        [vc addSubview:lb];
        lb.frame=CGRectMake(CGRectGetMaxX(img.frame)+5, 0, width-1-ss.width, ss.height);
        lb.text=arr2[i];
        lb.font=[UIFont systemFontOfSize:12];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, JDScreenSize.width, JDScreenSize.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
}
//营收历史按钮事件
-(void)clickRightItem{
    JDRevenueHistoryViewController *vc = [[JDRevenueHistoryViewController alloc]init];
    [vc addNavigationBar:@"营收历史"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark----tabelView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDRevenueTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"JDRevenueTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JDRevenueData *data = _modelArr[indexPath.row];
        NSString *time = data.payTime;
        NSRange M = NSMakeRange(4, 2);
        NSRange D = NSMakeRange(6, 2);
        NSRange H = NSMakeRange(8, 2);
        NSRange F = NSMakeRange(10, 2);
        NSString * paytime = [NSString stringWithFormat:@"%@"@"."@"%@"@"/"@"%@"@":"@"%@",[time substringWithRange:M],[time substringWithRange:D],[time substringWithRange:H],[time substringWithRange:F]];
        cell.payTime.text = [NSString stringWithFormat:@"%@",paytime];
        NSString * payWay = [NSString stringWithFormat:@"%@",data.payWay];
        if ([payWay isEqual:@"1"]) {
            cell.payWay.text = @"现金支付";
        }else{
            cell.payWay.text = @"在线支付";
        }
        cell.money.text  = [NSString stringWithFormat:@"%@",data.money];
        cell.integrate.text = [NSString stringWithFormat:@"%@",data.integrate];
        [self setDate];
    }
    
    
    
    return cell;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _backGroudView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 312+_y3.height+11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

//设置上半部数据
-(void)setDate{
    JDRevenueData *data = _modelArr2[0];
    NSString * allMoney =[NSString stringWithFormat:@"%@",data.allMoney];
    [_moneyLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"¥%@ ",allMoney] andFrontFont:33 andRange:NSMakeRange(0, 1) andLastFont:66 andlastRange:NSMakeRange(1, allMoney.length+1)]];
    NSString * allintegral = [NSString stringWithFormat:@"%@",data.allIntegrate];
    NSString * allintrgral2 = [NSString stringWithFormat:@"%@积分 ",allintegral];
    NSRange Q = NSMakeRange(0, allintegral.length);
    NSRange L = NSMakeRange(allintegral.length, allintrgral2.length-1);
    [_integralLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"%@积分 ",allintegral] andFrontFont:66 andRange:Q andLastFont:24 andlastRange:L]];
    NSString *onlinePay = [NSString stringWithFormat:@"¥%@",data.onlinPayMoney];
    _onlinePayLabel.text = onlinePay;
    
    NSString *cashPay = [NSString stringWithFormat:@"¥%@",data.cashPayMoney];
    _cashPayLabel.text = cashPay;
    
    NSString *allList = [NSString stringWithFormat:@"%@",data.allList];
    _allList.text = allList;

    
}
//根据字体大小设置label的长宽
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
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
