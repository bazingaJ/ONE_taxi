//
//  JDPhoneVerifyViewController.h
//  eTaxi-iOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetData.h"
#import "JDMyMoneyBagViewController.h"

@interface JDPhoneVerifyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumL;
@property (weak, nonatomic) IBOutlet UITextField *inPutTF;

@end
