//
//  BQRelatedViewController.m
//  PersonalMemo
//
//  Created by st2 on 15/1/10.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "BQRelatedViewController.h"
#import "STMemoView.h"
#import "ProjectLeftSideView.h"
#import "STTeamMemo.h"
#import "BQMemoTransmition.h"
@interface BQRelatedViewController ()
@property BQMemoTransmition *TR;
@property (weak,nonatomic )ProjectLeftSideView *leftSideView;
@end

@implementation BQRelatedViewController

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
    //初始化操作
    self.TR = [[BQMemoTransmition alloc]init];
    self.TR.delegate_Related = self;
   
    self.MemoScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(25, 57, 295, 462)];
    
    self.MemoScrollView.userInteractionEnabled=YES;
    self.MemoScrollView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.MemoScrollView];
    
    NSArray *arr = [[NSArray alloc]initWithObjects:@"我的任务",@"我的讨论",@"我发出的",nil];
    self.selectMemoKindBar=[[UISegmentedControl alloc]initWithItems:arr ];
    self.selectMemoKindBar.Frame=CGRectMake(25, 20, 287, 29);
    
    self.selectMemoKindBar.userInteractionEnabled=YES;
    [self.view addSubview:self.selectMemoKindBar];
    
    [self.selectMemoKindBar addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    self.memosArray = [NSMutableArray array];
    self.memos = [NSMutableArray array];
    
    //生成左边栏
    self.leftSideView = [[NSBundle mainBundle]loadNibNamed:@"ProjectLeftSideDisplayView" owner:self options:nil].lastObject;
    self.leftSideView.delegate= self;
    
    //测试用
    //NSArray *projectArray=[[NSArray alloc]initWithObjects:@"project1",@"project2",@"project3", nil];
    
    self.TR.delegate_leftSideView=self.leftSideView;
    
    
    //读取userID
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    NSString * userId = [writeData objectForKey:@"userID"];
    //左边栏获得用户的所有项目
    [self.TR projectOfMeGet:userId];
    
    //获取用户所有项目同时获取我的任务便签
    //以此初始化selectMemoKindBar选中的是“我的任务”
    self.selectMemoKindBar.selectedSegmentIndex=0;
    [self LoadMyTaskMemo];
    
    [self.view addSubview:self.leftSideView];
    
    //测试用
    //请求服务器便签
    
    
    
   
    
    
    
    /* **********************
     测试用
     
     
       **********************
     */
    
    /*                        测试用                          */
    /*
    NSMutableArray * testdata = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        STTeamMemo * memo = [[STTeamMemo alloc]init];
        memo.summary = [NSString stringWithFormat:@"%d",i];
        memo.detail = @"dasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfadasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfa";
        memo.deadline = @"2016-1-1";
        
        [testdata addObject:memo];
    }
    
    [self data2memo:testdata];
    */
    
    /*
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * memo1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * memo2 = [[NSMutableDictionary alloc]init];
    [memo1 setObject:@"summary1" forKey:@"memoSummary"];
    [memo2 setObject:@"summary2" forKey:@"memoSummary"];
    
    [memo1 setObject:@"dasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfadasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfa" forKey:@"memoDetail"];
    [memo2 setObject:@"dasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfadasnjasfbasiofnasiofnasoifnasionfasiofnabjdasbdaoibfioasbfaosifboasbfaosbfasoifbasiofbasiofbaiosfbasiofbasoifbasiofbasofbasiofabsfa" forKey:@"memoDetail"];
    
    
    
    [dic1 setObject:memo1 forKey:@"1"];
    [dic1 setObject:memo2 forKey:@"2"];
    //NSLog(@"%@",dic1);
    
    [self inputADicWithMemoData:dic1];
    */
    
    
    /*                        测试用                          */

    
    
    
    

}

//显示出选中项目的“我的任务”便签
-(void)LoadMyTaskMemo{
  
    //读取userID
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    NSString * userId = [writeData objectForKey:@"userID"];
    
    [self.TR myTaskMemoGet:userId project:self.leftSideView.projectSelectedID];
    
}

//显示出选中项目的“我发出的”便签
-(void)LoadMemoSendFromMe{
    
    //读取userID
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    NSString * userId = [writeData objectForKey:@"userID"];
    
    [self.TR memoFromMeGet: userId project:self.leftSideView.projectSelectedID];
    
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    switch (Index) {
            
        case 0:
            [self LoadMyTaskMemo];
            
            
            break;
            
        case 1:{
            NSArray *views = [self.MemoScrollView subviews];
            for(UIView * view in views)
            {
                [view removeFromSuperview];
            }
            
            break;
        }
        case 2:
            
            [self LoadMemoSendFromMe];
            
            break;
            

            
        default:
            
            break;
            
    }
    
}



//新建团队便签视图
-(void)data2memo:(NSMutableArray *)data{
    
    //把ScorllView原来的所有便签删除
    NSArray *views = [self.MemoScrollView subviews];
    for(UIView * view in views)
    {
        [view removeFromSuperview];
    }
    
    
    self.memosArray = [NSMutableArray array];
    
    NSLog(@"%ld",data.count);
    
    //服务器返回的空便签不显示
    for (int i = 0; i < data.count-1; i++) {
        
        STTeamMemo * memo = data[i];
        
        STMemoView *a = [[NSBundle mainBundle]loadNibNamed:@"STMemoDisplayView" owner:self options:nil].lastObject;
        
        a.center = CGPointMake(a.center.x+15, a.center.y + i*170+10);
        
        a.title.text = memo.summary;
        a.detail.text = memo.detail;
        a.deadline.text = memo.deadline;
        a.head.image = memo.head;
        a.order = i;
        a.delegate = self;
        
        
        a.memoID=memo.memoID;
        a.memoStateLabel.text=memo.state;
        
        //如果选择栏是“我的任务”时
        if(self.selectMemoKindBar.selectedSegmentIndex==0)
        {
            //如果便签状态是“待完成“，则memoView完成按钮可用
          if([memo.state isEqualToString:@"待完成"])
           {
           }
            
          //如果便签状态是”待审查“或“已通过”，则memoView完成按钮失效
           if([memo.state isEqualToString:@"待审查.."]||[memo.state isEqualToString:@"已通过"])
           {
            //button失效
            a.finishBtn.backgroundColor=[UIColor grayColor];
            a.finishBtn.enabled=NO;
           }
        }
            
        
        //如果选择栏是“我发出的”时
        if(self.selectMemoKindBar.selectedSegmentIndex==2)
      {
        //只要便签状态不是”待审查..“，memoView”通过“按钮都失效
        if(![memo.state isEqualToString:@"待审查.."])
        {
            //button失效
            a.finishBtn.backgroundColor=[UIColor grayColor];
                a.finishBtn.enabled=NO;
            [a.finishBtn setTitle:@"通过" forState:UIControlStateNormal];
               
        }
        //只要便签状态是"待审查"，memoView完成按钮title就变成”通过“且可用
        if([memo.state isEqualToString:@"待审查.."])
        {
           [a.finishBtn setTitle:@"通过" forState:UIControlStateNormal];
        }
            
            
      }
        
        a.tag = i;
        
        [self.memosArray addObject:a];
        [self.MemoScrollView addSubview:a];
        
    }
    
    self.MemoScrollView.contentSize=CGSizeMake(self.MemoScrollView.contentSize.width, 170 * data.count+20);
}


//delegate回调函数 便签放大
-(void)delegate_memoIsZoomUpWithOrder:(int)order fixed:(int)fix{
    NSLog(@"%d",order);
    
    self.MemoScrollView.contentSize=CGSizeMake(self.MemoScrollView.contentSize.width, self.MemoScrollView.contentSize.height + fix);
    
    //order以下的便签下移fix高度
    for (STMemoView * view in self.memosArray) {
        if (view.tag > order) {
            view.center = CGPointMake(view.center.x, view.center.y + fix);
        
        }
    }
    
    
}

//便签缩小
-(void)delegate_memoIsZoomDownWithOrder:(int)order fixed:(int)fix{
    NSLog(@"%d",order);
    self.MemoScrollView.contentSize=CGSizeMake(self.MemoScrollView.contentSize.width, self.MemoScrollView.contentSize.height - fix);
    for (STMemoView * view in self.memosArray) {
        if (view.tag > order) {
            view.center = CGPointMake(view.center.x, view.center.y - fix);
        
        }
    }
}




    //更换项目
-(void)delegate_changeProject:(NSString*)projectID{
    
    //请求服务器数据
    self.selectMemoKindBar.selectedSegmentIndex=0;
    
    //读取userID
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    NSString * userId = [writeData objectForKey:@"userID"];
    
    //显示出选中项目的所有便签
    [self.TR myTaskMemoGet:userId project:projectID];
    
}
    //便签右移动
-(void)delegate_memo2Right:(int)pix{
    
    //scrollview移动
    CGRect newPos=CGRectMake(self.MemoScrollView.frame.origin.x+pix, self.MemoScrollView.frame.origin.y, self.MemoScrollView.frame.size.width, self.MemoScrollView.frame.size.height);
    [self memoMovement:self.MemoScrollView initialFrame:self.MemoScrollView.frame FinalFrame:newPos];
    
    //选择栏移动
    CGRect newPos2=CGRectMake(self.selectMemoKindBar.frame.origin.x+pix, self.selectMemoKindBar.frame.origin.y, self.selectMemoKindBar.frame.size.width, self.selectMemoKindBar.frame.size.height);
    [self memoMovement:(UIView *)self.selectMemoKindBar initialFrame:self.selectMemoKindBar.frame FinalFrame:newPos2];
     
    //self.MemoScrollView.center = CGPointMake(self.MemoScrollView.center.x + pix, self.MemoScrollView.center.y);
}

    //便签左移动
-(void)delegate_memo2Left:(int)pix{
    
    //scrollview移动
    CGRect newPos=CGRectMake(self.MemoScrollView.frame.origin.x-pix, self.MemoScrollView.frame.origin.y, self.MemoScrollView.frame.size.width, self.MemoScrollView.frame.size.height);
    [self memoMovement:self.MemoScrollView initialFrame:self.MemoScrollView.frame FinalFrame:newPos];
    
    //选择栏移动
    CGRect newPos2=CGRectMake(self.selectMemoKindBar.frame.origin.x-pix, self.selectMemoKindBar.frame.origin.y, self.selectMemoKindBar.frame.size.width, self.selectMemoKindBar.frame.size.height);
    [self memoMovement:(UIView *)self.selectMemoKindBar initialFrame:self.selectMemoKindBar.frame FinalFrame:newPos2];
     
    //self.MemoScrollView.center = CGPointMake(self.MemoScrollView.center.x - pix, self.MemoScrollView.center.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)inputADicWithMemoData:(NSMutableDictionary *)dic{
    //数组里面是字典
    //self.memos = nil;
    
    NSMutableArray * ms = [[NSMutableArray alloc]init];
   NSEnumerator * enumeratorobj = [dic objectEnumerator];
    int i=0;
    for (NSMutableDictionary * memo in enumeratorobj) {
        STTeamMemo * m = [[STTeamMemo alloc]init];
        m.summary = [memo valueForKey:@"memoSummary"];
        m.detail = [memo valueForKey:@"memoDetail"];
        m.deadline = [memo valueForKey:@"memoRemindTime"];
        m.createTime = [memo valueForKey:@"memoCreateTime"];
        //m.head = [memo valueForKey:@""];
        m.state = [memo valueForKey:@"memoState"];
        m.memoID=[memo valueForKey:@"memoID"];
        
        
        //[self.memos addObject:m];
        [ms addObject:m];
        i++;
    }
    
    NSLog(@"Memo i:%i",i);
   // NSLog(@"%@",self.memos);
    //[self data2memo:self.memos];
    [self data2memo:ms];
    
}

//动画函数
- (void)memoMovement:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
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
