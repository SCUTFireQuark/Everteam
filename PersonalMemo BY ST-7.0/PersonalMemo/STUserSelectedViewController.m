//
//  STUserSelectedViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/15.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "STUserSelectedViewController.h"
#import "STAppDelegate.h"

@interface STUserSelectedViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *Scor;
@property NSMutableArray * selectedUserID;
@end

@implementation STUserSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedUserID = [NSMutableArray array];
    
    
}
-(void)printUser:(NSMutableDictionary *)dic{
    NSEnumerator * enumeratorobj = [dic objectEnumerator];
    int i=0;
    for (NSMutableDictionary * memo in enumeratorobj) {
        
        NSString * userNickname = [memo valueForKey:@"userNickname"];
        NSString * userID = [memo valueForKey:@"userID"];
        NSLog(@"%@",userID);
        NSLog(@"%@",userNickname);
        if (userID==NULL) {
            break;
        }else
        {
            //显示
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 55 +10, 300, 50)];
            view.backgroundColor = [UIColor redColor];
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 280, 40)];
            btn.backgroundColor=[UIColor whiteColor];
            //btn.backgroundColor = [UIColor blueColor];
            
            [btn setTitle:userNickname forState:UIControlStateNormal];
            [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            
            
            btn.tag = userID.intValue;
            [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            //添加到滑动视图
            [self.Scor addSubview:view];
            i++;
        }
    }
    

}

-(void)onBtnClicked:(UIButton*)btn{
    NSString * userID = [NSString stringWithFormat:@"%d",btn.tag];
    
    //验证数组中有没有这个ID
    BOOL ishave = false;
    for (NSString * str in self.selectedUserID) {
        if ([str isEqualToString:userID]) {
            ishave = true;
            
        }else{
            ishave = false;
        }
    }
        //有就删除
    if (ishave == true) {
        btn.backgroundColor =[UIColor whiteColor];
        [self.selectedUserID removeObject:userID];
    }else{//没有就加入
        btn.backgroundColor =[UIColor grayColor];
        [self.selectedUserID addObject:userID];
    }
    
    
}
- (IBAction)finish:(UIButton *)sender {
    //保存userID这个数组到写便签的页面
    /*
    TaskMemoViewController * controller = [[TaskMemoViewController alloc]initWithNibName:@"TaskMemoViewController" bundle:nil];
    //controller.summaryTextField.text = self.taskView.summaryTextField.text;
    controller.selectedUserID = self.selectedUserID;
     
     */
    
    self.taskView.selectedUserID = self.selectedUserID;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate_userSelected disMissSelf];
    }];
    
}

/*- (IBAction)finish:(UIButton *)sender {
    
    //保存userID这个数组到写便签的页面
    TaskMemoViewController * controller = [[TaskMemoViewController alloc]initWithNibName:@"TaskMemoViewController" bundle:nil];
    //controller.summaryTextField.text = self.taskView.summaryTextField.text;
    controller.selectedUserID = self.selectedUserID;
    [self presentViewController:controller animated:YES completion:nil];
    
}*/

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
