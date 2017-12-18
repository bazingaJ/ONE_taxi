//
//  JDOutputViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDOutputViewController.h"

#import "HeadFile.pch"
#import "JDOutputCell.h"


@interface JDOutputViewController ()

@end

@implementation JDOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // 添加tableview
    [self addTableView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 68, 200, 20)];
    label.text = @"如需更换银行卡信息请与客服联系";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = COLORWITHRGB(66, 66, 66, 1);
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(JDScreenSize.width-50, 100, 50, 50)];
    label2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label2];
    
}

-(void)addTableView
{
    [self addNavigationBar:@"提现"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, JDScreenSize.width, JDScreenSize.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JDOutputCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell = [[NSBundle mainBundle] loadNibNamed:@"JDOutputCell" owner:nil options:nil][indexPath.section];
    cell.selectionStyle = 0;
    
    

    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 30;
    }else if(section==1){
        return 15;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 50;
    }
    return 56;
}

#pragma mark 让textfield失去第一响应并响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self textFieldResignFirstResponser];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self textFieldResignFirstResponser];
}

-(void)textFieldResignFirstResponser
{
    JDOutputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [cell.outMoneyTextfield resignFirstResponder];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
