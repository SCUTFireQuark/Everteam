//
//  STLoginViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "STLoginViewController.h"
#import "BQMemoTransmition.h"
#import "STTabBarViewController.h"
@interface STLoginViewController ()

@end

@implementation STLoginViewController

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
    self.userName.delegate=self;
    self.passWord.delegate=self;
    
    //显示上次登录的用户名
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    self.userName.text= [writeData objectForKey:@"userName"];
    self.passWord.text= [writeData objectForKey:@"password"];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)yanzheng:(NSString *)username password:(NSString*)password{
 BQMemoTransmition *TR = [[BQMemoTransmition alloc]init];
    [TR loginWithUserID:username withpassword:password];
    
    NSLog(@"%@",TR.judgeTag);
    return TR.judgeTag;
    
}
- (IBAction)Login:(UIButton *)sender {
    NSString * password = self.passWord.text;
    NSString * userName = self.userName.text;
    BQMemoTransmition *TR = [[BQMemoTransmition alloc]init];
    TR.delegate = self;
    
    [TR loginWithUserID:userName withpassword:password];
//    //写到本地数据库
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userIfo" ofType:@"plist"];
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:userName forKey:@"userName"];
//    [dic setObject:password forKey:@"password"];
//    [dic writeToFile:plistPath atomically:YES];
    
}

-(void)dataStore:(NSString *)userName :(NSString * )password :(NSString *) UserID{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    //创建一个dic，写到plist文件里
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userName forKey:@"userName"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:UserID forKey:@"userID"];
    
    //写入数据
    [dic writeToFile:fileName atomically:YES];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    NSLog(@"write data is :%@",writeData);
}


-(void)popView{
    [self performSegueWithIdentifier:@"login" sender:nil];

}

- (IBAction)keyboardMissBoth:(id)sender
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
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
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
