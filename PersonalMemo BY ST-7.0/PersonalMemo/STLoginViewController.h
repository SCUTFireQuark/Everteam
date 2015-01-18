//
//  STLoginViewController.h
//  PersonalMemo
//
//  Created by st2 on 15/1/11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
-(void)popView;
-(void)dataStore:(NSString *)userName :(NSString * )password :(NSString *) UserID;
@end
