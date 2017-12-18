//
//  JDCallCarListViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/4/22.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDCallCarListViewController.h"

#import "JDOrderListCell.h"

#import "JDCallCarListViewModel.h"
#import "JDCallCarData.h"
#import "JDCallCarTool.h"

#import "JDOrderListImageView.h"
#import "JDOrderListBottomView.h"

#import "HeadFile.pch"

#import "MJRefresh.h"

#import "JDNoMessageView.h"

#define NowUseCarImage [UIImage imageNamed:@"现在用车_list"]
#define FeaUseCarImage [UIImage imageNamed:@"预约用车_list"]

@interface JDCallCarListViewController () <UITableViewDelegate,UITableViewDataSource,JDOrderListDetegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, weak) UIControl *mengc;


@end

@implementation JDCallCarListViewController{
    NSInteger _index;
    NSString *_type;
    int index;

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
    
    [self setUpTableView];
    self.view.backgroundColor = COLORWITHRGB(216, 216, 216, 1);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelOlder) name:@"取消订单" object:nil];
}
- (void)cancelOlder
{
    [GetData addAlertViewInView:self title:@"温馨提示：" message:@"您有一条订单已取消！" count:0 doWhat:^{
        [self.tableView.mj_header beginRefreshing];
    }];
}
- (void)setUpTableView
{
    self.tableView.rowHeight = [NowUseCarImage size].height + 12 + 9;
    self.tableView.separatorStyle = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.tableView.mj_header beginRefreshing];
}

-(void)getData
{
    _index = 0;
    // 移除没有消息时的界面
    for (UIView *view in self.tableView.subviews) {
        if ([view isKindOfClass:[JDNoMessageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [JDCallCarTool getCallCarListWithType:@"2" inVC:self Success:^(NSMutableArray *modelArr, int orderCount) {
        
        // 结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        
        // 给模型数组赋值
        self.modelArr = modelArr;
        // 刷新单元格
        [self.tableView reloadData];
        
        if (modelArr.count==0) {
            
//            [GetData addMBProgressWithView:self.view style:1];
//            [GetData showMBWithTitle:@"当前没有接单!"];
//            [GetData hiddenMB];
            
            // 添加没有召车信息的界面
            JDNoMessageView *noMessView = [[JDNoMessageView alloc] initWithFrame:CGRectMake(0, 0, JDScreenSize.width, self.tableView.bounds.size.height*2/3)];
            noMessView.message = @"当前没有接单";
            [self.tableView addSubview:noMessView];
        
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - tableView delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JDOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" indexPath:indexPath];
        cell.selectionStyle = 0;
    }
    JDCallCarData *data = self.modelArr[_index];

    JDCallCarListViewModel *viewModel = [[JDCallCarListViewModel alloc] init];
    
    viewModel.callCarData = data;
    
    cell.viewModel = viewModel;
    
    cell.orderBottomView.delegate = self;
    
    JDLog(@"%@",data.orderStatus);
    if ([data.orderStatus isEqualToString:@"5"]) {
        [cell.orderBottomView showWaitPayView];
    }
    if ([data.orderStatus isEqualToString:@"2"]) {
        [cell.orderBottomView showPayStyleView];
    }
    
    
//    if ([data.useType intValue]==0) { // 现在用车
//        
//        cell.orderImageView.image = NowUseCarImage;
//        
//    }else{ // 预约用车
//        
//        cell.orderImageView.image = FeaUseCarImage;
//        
//    }
    _index++;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDCallCarData *data = self.modelArr[indexPath.section];
    
    JDCallCarListViewModel *viewModel = [[JDCallCarListViewModel alloc] init];
    
    viewModel.callCarData = data;
    
    return viewModel.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark order bottom view delegate
// 点击乘客已上车
-(void)orderListClickOnCarAtIndexPath:(NSIndexPath *)indexPath
{
    JDCallCarData *data = self.modelArr[indexPath.section];
    JDOrderListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
//[cell.orderBottomView showPayStyleView];
    [JDCallCarTool getCallCarInfoWithType:@"4" inVC:self orderId:data.orderId Success:^(NSMutableArray *modelArr, int status) {
        
        [cell.orderBottomView showPayStyleView];
        
    } failure:^(NSError *error) {
        
       
    }];
    
}
// 点击现金支付
-(void)orderListClickMoneyPayAtIndexPath:(NSIndexPath *)indexPath
{
//    JDLog(@"%ld",(long)indexPath.section);
    JDCallCarData *data = self.modelArr[indexPath.section];
    index = (int)indexPath.section;
    _type = @"0";
    NSString *onLinePay = [[NSUserDefaults standardUserDefaults]objectForKey:@"onLinePay"];
    if ([onLinePay isEqualToString:@"1"]) {
        [JDCallCarTool getCompleteOrderWithType:_type orderId:data.orderId money:[[NSUserDefaults standardUserDefaults] objectForKey:@"Paymoney"] inVc:self success:^{
            [GetData addAlertViewInView:self title:@"温馨提示" message:@"订单已完成！" count:0 doWhat:^{
                //[self.modelArr removeObjectAtIndex:_index];
                //            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"onLinePay"];
                [self getData];
            }];
        } failure:^(NSError *error) {
            
        }];
        [self getData];
    }else{
        
    [self createPayView];
    
    }
    
}
// 点击在线支付
-(void)orderListClickOnlinePayAtIndexPath:(NSIndexPath *)indexPath
{
    _type = @"1";
    
    [self createPayView];
//    JDCallCarData *data = self.modelArr[indexPath.section];
////    JDLog(@"click online pay!--%ld",(long)indexPath.section);
//    JDLog(@"%@",data.orderId);
//    // 请求在线支付接口
//    [JDCallCarTool getCompleteOrderWithType:@"1" orderId:data.orderId inVc:self success:^{
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
////        JDLog(@"在线支付成功!");
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
//支付窗口创建
-(void)createPayView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.tag = 1;
    [self.view addSubview:view];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake((JDScreenSize.width-252)/2, 150, 252, 206)];
    [self.view addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    view1.tag = 2;
    view1.layer.cornerRadius = 10;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 252,53)];
    label.text = @"请输出此单金额";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = COLORWITHRGB(3,163, 255, 1);
    label.font = [UIFont systemFontOfSize:16];
    label.layer.cornerRadius = 10;
    label.clipsToBounds = YES;
    [view1 addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 252, 18)];
    label1.backgroundColor = COLORWITHRGB(3,163, 255, 1);
    [view1 addSubview:label1];
    
    UIButton * cancelButton = [[UIButton alloc]init];
    cancelButton.frame = CGRectMake(14/1.5, 238/1.5, 163/1.5, 56/1.5);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:COLORWITHRGB(147, 147, 147, 1)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.layer.cornerRadius = 5;
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchDown];
    [view1 addSubview:cancelButton];
    
    
    UIButton * okButton = [[UIButton alloc]init];
    okButton.frame = CGRectMake(195/1.5+3, 238/1.5, 163/1.5, 56/1.5);
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setBackgroundColor:COLORWITHRGB(3, 163, 255, 1)];
    okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    okButton.layer.cornerRadius = 5;
    [okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchDown];
    [view1 addSubview:okButton];
    
    UITextField * moneyFiled = [[UITextField alloc]initWithFrame:CGRectMake(194/2, 100/1.5, 150, 70)];
    [moneyFiled setFont:[UIFont systemFontOfSize:53]];
    moneyFiled.delegate  = self;
    moneyFiled.tag = 3;
    moneyFiled.tintColor = [UIColor blackColor];
    moneyFiled.adjustsFontSizeToFitWidth = YES;
    moneyFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [view1 addSubview:moneyFiled];
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(194/2-30, 100/1.5+15, 50, 50)];
    moneyLabel.text = @"¥";
    moneyLabel.font = [UIFont systemFontOfSize:29];
    [view1 addSubview:moneyLabel];
    


}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIView * view =[self.view viewWithTag:2];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-100, view.frame.size.width, view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    UIView * view =[self.view viewWithTag:2];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    view.frame = CGRectMake((JDScreenSize.width-252)/2, 150, 252, 206);
    [UIView commitAnimations];
}
-(void)okButtonClick{
    UITextField *moneyTextField = [self.view viewWithTag:3];
    NSString *money = moneyTextField.text;
    JDCallCarData *data = self.modelArr[index];
    if ([_type isEqualToString:@"0"]) {
        [JDCallCarTool getCompleteOrderWithType:_type orderId:data.orderId money:money inVc:self success:^{
            [GetData addAlertViewInView:self title:@"温馨提示" message:@"订单已完成！" count:0 doWhat:^{
                //[self.modelArr removeObjectAtIndex:_index];
                //            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                [self getData];
            }];
        } failure:^(NSError *error) {
            
        }];
    }
    else{
    [JDCallCarTool getCompleteOrderWithType:_type orderId:data.orderId money:money inVc:self success:^{
        [GetData addAlertViewInView:self title:@"温馨提示" message:@"订单等待支付中！" count:0 doWhat:^{
                        //[self.modelArr removeObjectAtIndex:_index];
            //            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [[NSUserDefaults standardUserDefaults]setObject:money forKey:@"Paymoney"];
            NSString *onLinePay = @"1";
            [[NSUserDefaults standardUserDefaults]setObject:onLinePay forKey:@"onLinePay"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"onLinePay"]);
            [self getData];
        }];
    } failure:^(NSError *error) {
        
    }];
    }
    UIView * view = [self.view viewWithTag:1];
    [view removeFromSuperview];
    UIView *view2 = [self.view viewWithTag:2];
    [view2 removeFromSuperview];
    
    

}
-(void)cancelButtonClick{
    NSString *cancelClick = 0;
    [[NSUserDefaults standardUserDefaults]setObject:cancelClick forKey:@"cancelClick"];
    UIView * view = [self.view viewWithTag:1];
    [view removeFromSuperview];
    UIView *view2 = [self.view viewWithTag:2];
    [view2 removeFromSuperview];
}
@end
