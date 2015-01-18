//
//  STSettingViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/17.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "STSettingViewController.h"

@interface STSettingViewController ()

@end

@implementation STSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jump:(UIButton *)sender {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    //创建一个dic，写到plist文件里
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"userName"];
    [dic setObject:@"" forKey:@"password"];
    [dic setObject:@"" forKey:@"userID"];
    
    //写入数据
    [dic writeToFile:fileName atomically:YES];
    
    [self performSegueWithIdentifier:@"jump" sender:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
