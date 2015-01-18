//
//  STProjectNameSelectViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/15.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "STProjectNameSelectViewController.h"
#import "BQMemoTransmition.h"
#import "STUserSelectedViewController.h"
@interface STProjectNameSelectViewController ()
@property NSString * userID;
@property NSString * selectedProjectID;
@property BQMemoTransmition * delegate_displayProjectName;
@end

@implementation STProjectNameSelectViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    BQMemoTransmition * TR = [[BQMemoTransmition alloc]init];
    TR.delegate_Project=self;
    //传入userID
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    //NSLog(@"projectView :%@",writeData);
    self.userID = [writeData objectForKey:@"userID"];
    NSLog(@"%@",self.userID);
    [TR projectOfMeGet:self.userID];
    // Do any additional setup after loading the view from its nib.
}

-(void)printProject:(NSMutableDictionary *)dic{
    //得到所有的项目 全部是字典
    
    NSEnumerator * enumeratorobj = [dic objectEnumerator];
    int i=0;
    for (NSMutableDictionary * memo in enumeratorobj) {
        
        NSString * projectName = [memo valueForKey:@"projectName"];
        NSString * projectID = [memo valueForKey:@"projectID"];
        NSLog(@"%@",projectID);
        NSLog(@"%@",projectName);
        if (projectID==NULL) {
            break;
        }else
        {
            //显示
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 55 +10, 300, 50)];
            view.backgroundColor = [UIColor redColor];
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 280, 40)];
            btn.backgroundColor=[UIColor whiteColor];
            //btn.backgroundColor = [UIColor blueColor];
            
            [btn setTitle:projectName forState:UIControlStateNormal];
            [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            
            
            btn.tag = projectID.intValue;
            [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            //添加到滑动视图
            [self.Scro addSubview:view];
            i++;
        }
    }
    /*NSArray * users = [dic allValues];
    NSLog(@"324");
    NSArray * projects=[[NSArray alloc] init];
    
    NSMutableDictionary *p1 = [NSMutableDictionary dictionary];
    [p1 setObject:@"123" forKey:@"projectID"];
    [p1 setObject:@"diaoni" forKey:@"projectName"];
    
    NSMutableDictionary *p2 = [NSMutableDictionary dictionary];
    [p2 setObject:@"ddfff" forKey:@"projectID"];
    [p2 setObject:@"ddd" forKey:@"projectName"];
    
    
    NSMutableDictionary *test = [NSMutableDictionary dictionary];
    [test setObject:p1 forKey:@"1"];
    [test setObject:p2 forKey:@"2"];
    
    projects = [test allValues];
    
    //NSEnumerator * enumeratorobj = [dic objectEnumerator];
    for (int i = 0; i < projects.count; i++) {
        //取到值并且显示
        NSMutableDictionary * dic2 = projects[i];
        NSString * projectName = [dic2 objectForKey:@"projectName"];
        NSString * projectID = [dic2 objectForKey:@"projectID"];
        
        //显示
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 55 +10, 300, 50)];
        view.backgroundColor = [UIColor redColor];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 280, 40)];
        btn.backgroundColor=[UIColor whiteColor];
        //btn.backgroundColor = [UIColor blueColor];
        
        [btn setTitle:projectName forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        
        
        btn.tag = projectID.intValue;
        [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        //添加到滑动视图
        [self.Scro addSubview:view];
        
    }*/

    
}
/*- (IBAction)test:(id)sender {
    //页面跳转
    STUserSelectedViewController * controller =[[STUserSelectedViewController alloc]initWithNibName:@"STUserSelectedViewController" bundle:nil];
    controller.taskView = self.taskView;
    [self presentViewController:controller animated:YES completion:nil];
}*/

//点击事件
-(void)onBtnClicked:(UIButton*)btn{
    //按钮被点击
    //找到tag
    NSString *projectID = [NSString stringWithFormat:@"%d",btn.tag];
    self.taskView.selectedProjectID = projectID;
    NSLog(@"---------------------------");
    NSLog(@"%@",self.taskView.selectedProjectID);
    //根据tag请求服务器数据
    BQMemoTransmition * TR = [[BQMemoTransmition alloc]init];
    
    //页面跳转
    STUserSelectedViewController * controller =[[STUserSelectedViewController alloc]init];
    controller.delegate_userSelected = self;
    
    TR.delegate_User = controller;
    [TR userOfProjectGet:projectID];
    controller.taskView = self.taskView;
    [self presentViewController:controller animated:YES completion:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)disMissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
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
