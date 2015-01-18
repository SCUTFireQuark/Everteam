//
//  STRegisterViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "STRegisterViewController.h"
#import "BQMemoTransmition.h"
@interface STRegisterViewController ()

@end

@implementation STRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardMissBoth:)];
    [self.view addGestureRecognizer:tap];
    
    //为textfield添加代理
    self.account.delegate=self;
    self.password1.delegate=self;
    self.password2.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)register:(id)sender {
    BQMemoTransmition * TR = [[BQMemoTransmition alloc]init];
    TR.delegate_Register = self;
    if([self.password1.text isEqual:self.password2.text]){
    [TR accountVery:self.account.text withpassword:self.password1.text withnickname:self.password2.text withimage:nil];
    }else{
        //密码不一样
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
}

- (IBAction)keyboardMissBoth:(id)sender
{
    [self.account resignFirstResponder];
    [self.password1 resignFirstResponder];
    [self.password2 resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    [self animateTextField: textField up: YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
    [self animateTextField: textField up: NO];
    
}



- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    
    const int movementDistance = 80; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
