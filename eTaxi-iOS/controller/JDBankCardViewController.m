//
//  JDBankCardViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDBankCardViewController.h"
#import "HeadFile.pch"
#import "JDBankCardCell.h"
#import "JDWriteCardInfoViewController.h"
#import "HeadFile.pch"
#import "MBProgressHUD.h"
#import "MyTool.h"
#import "UIViewController+CustomModelView.h"
#import "GetData.h"
#import "PersonalVC.h"
#import "MyData.h"
#import "MJRefresh.h"


@interface JDBankCardViewController ()

@end

@implementation JDBankCardViewController{
    NSString * _select;
    NSString * _type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self addNavigationBar:@"银行卡"];
    
    [self addRightBtnWithTitle:@"编辑" font:13 action:@selector(clickRightButton:)];
    
    self.tableView.separatorStyle = 0;
}
-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"type"] = @"0";
    [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyWallet.json"] params:params success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        JDLog(@"%@",response);
        int returnCode = [response[@"returnCode"] intValue];
        if (returnCode == 0) {
            _dataArr = response[@"accountArr"];
        [self.tableView reloadData];
        }else{//强制退出
            [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [GetData addAlertViewInView:self title:@"温馨提示" message:@"数据请求失败" count:0 doWhat:^{
            
        }];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}
-(void)getDataWithIndex:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"type"] = @"3";
    params[@"bankAccountId"] = _dataArr[indexPath.row][@"bankAccountId"];
    [GetData getDataWithUrl:[NSString urlWithApiName:@"getMyWallet.json"] params:params success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        JDLog(@"%@",response);
        int returnCode = [response[@"returnCode"] intValue];
        if (returnCode == 0) {
            [self getData];
        }else{//强制退出
            [GetData addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",response[@"msg"]] count:0 doWhat:^{
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [GetData addAlertViewInView:self title:@"温馨提示" message:@"数据请求失败" count:0 doWhat:^{
            
        }];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}


-(void)clickRightButton:(UIButton *)button
{
    
    button.selected = !button.selected;
    if (button.selected==YES) {
        [button setTitle:@"完成" forState:UIControlStateNormal];
        self.tableView.editing = YES;
        _select = @"0";
    }else{
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        self.tableView.editing = NO;
        _select = @"1";
    }
    [self.tableView reloadData];
}



#pragma mark table view datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_select isEqualToString:@"0"]) {
        return _dataArr.count;
    }else{
        return _dataArr.count+1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDBankCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell = [[NSBundle mainBundle] loadNibNamed:@"JDBankCardCell" owner:nil options:nil][0];
    
    if (indexPath.row==_dataArr.count) { // 3-1
        cell = [[NSBundle mainBundle] loadNibNamed:@"JDBankCardCell" owner:nil options:nil][1];
        [cell.addBankCardButton addTarget:self action:@selector(clickAddBankCard) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 66+16;
    }
    return 110;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        [self getDataWithIndex:indexPath];
    }];
    return @[deleteRoWAction];
}

-(void)clickAddBankCard
{
    if (_dataArr.count>=2) {
        [GetData addAlertViewInView:self title:@"温馨提示" message:@"暂时最多可添加两张银行卡" count:0 doWhat:^{
            
        }];

    }else{
    JDWriteCardInfoViewController *wcVc = [[JDWriteCardInfoViewController alloc] init];
    
        [self.navigationController pushViewController:wcVc animated:YES];}
    
}

@end
