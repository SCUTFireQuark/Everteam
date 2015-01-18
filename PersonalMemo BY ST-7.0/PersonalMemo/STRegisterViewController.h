//
//  STRegisterViewController.h
//  PersonalMemo
//
//  Created by st2 on 15/1/11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRegisterViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end
