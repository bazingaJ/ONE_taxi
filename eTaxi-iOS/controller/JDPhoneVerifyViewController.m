//
//  JDPhoneVerifyViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPhoneVerifyViewController.h"
#import "MyData.h"
#import "AFNetworking.h"
#import "MyTool.h"
#import "NSString+StringForUrl.h"

#import "RSA.h"
#import "HeadFile.pch"

@interface JDPhoneVerifyViewController ()

@end

@implementation JDPhoneVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addNavigationBar:@"手机验证"];
    [self getaData];
    [self.completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchDown];
    
}
-(void)getaData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
    params[@"loginTime"] = LOGINTIME;
    params[@"type"] = @"0";
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSString * str =[NSString urlWithApiName:@"getSmsVaildCode.json"];
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        JDLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
     {
         
     }];

}

-(void)completeBtnClick{
    [GetData addAlertViewInView:self title:@"上传成功!" message:@"您的信息已上传成功" count:0 doWhat:^{
        
        
        [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    }];
    
}



@end
