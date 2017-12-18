//
//  JDWriteCardInfoCell.m
//  eTaxi-iOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDWriteCardInfoCell.h"

@implementation JDWriteCardInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.nextButton.layer.cornerRadius = 3.0;
    self.nextButton.layer.masksToBounds = YES;
    self.detailTextField.delegate = self;
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.tag ==0) {
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"depositBank"];
    }else if(self.tag==1){
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"accountNumber"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"phoneOfBank"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

@end
