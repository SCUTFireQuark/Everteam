//
//  STMemoDisplayViewController.m
//  PersonalMemo
//
//  Created by st on 14-7-14.
//  Copyright (c) 2014年 st. All rights reserved.
//
#define default 默认
#import "STMemoDisplayViewController.h"
#import "Memo.h"
#import "Theme.h"
#import "STAppDelegate.h"
#import "MemoXMLParser.h"
#import "STMemo.h"

@interface STMemoDisplayViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addNewMemoBtn;
@property (weak, nonatomic) IBOutlet UIButton *editOverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *scrollView1;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIView *createThemeView;
@property (weak, nonatomic) IBOutlet UITextField *createThemeTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *UIMemoIV;
@property (nonatomic)int from;
@property (nonatomic)int to;
@property UIImageView *ivvvv;
@property UIImageView *dele;
@property BOOL pressDown;

@property (strong,nonatomic)NSMutableArray *displays;
@property (strong,nonatomic)NSMutableArray *themes;
@property (strong,nonatomic)NSMutableArray *memos;
@property (strong,nonatomic)NSMutableArray *btns;
@property (strong,nonatomic)NSMutableArray *memoBtns;
@property (strong,nonatomic)NSMutableArray *deletebtns;
@property (strong,nonatomic)NSMutableArray *ivs;
@property (strong,nonatomic)NSMutableArray *memodeletebtns;
@property (strong,nonatomic)NSString *currentTheme;
@property UITextField *summaryTextField;
@property UITextView * detailsTextView;
@property UIButton *pigeon;
@property (nonatomic)  UIButton *clock;


@property Memo * memoSave;
@property Memo *memoInDataBase;

@property BOOL isClock;
@property (strong,nonatomic) NSMutableData *datas;
@property (strong,nonatomic) NSMutableArray *MemoList;
@property (nonatomic) BOOL isStartRequest;
@property BOOL isForSend;
@property STMemo *memoSEND;
@end

@implementation STMemoDisplayViewController

@synthesize pigeon;
@synthesize clock;
@synthesize pressDown;

const CGFloat IV_HEIGHT = 90;
const CGFloat SUMMARY_HEIGHT = 30;
const CGFloat DETAIL_HEIGHT = 20;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view bringSubviewToFront:self.createThemeView];

    self.memoInDataBase=[[Memo alloc] init];
    pressDown = NO;
    [super viewDidLoad];
    self.memoSEND = [[STMemo alloc]init];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    self.displays = [NSMutableArray array];
    self.ivs=[NSMutableArray array];
    self.memodeletebtns=[NSMutableArray array];
    self.btns = [NSMutableArray array];
    self.memoBtns = [NSMutableArray array];
    self.themes = [NSMutableArray array];
    self.memos = [NSMutableArray array];
    self.createThemeView.hidden = YES;
    self.scrollView1.userInteractionEnabled = NO;
    self.UIMemoIV.userInteractionEnabled = YES;
    self.deletebtns = [NSMutableArray array];
    self.editOverBtn.hidden=YES;
    self.currentTheme=@"默认";
    
    STAppDelegate *app = [UIApplication sharedApplication].delegate;

    NSFetchRequest *request1 = [[NSFetchRequest alloc]initWithEntityName:@"Theme"];
    NSArray *themes = [app.managedObjectContext executeFetchRequest:request1 error:Nil];
    NSFetchRequest *request2 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memos = [app.managedObjectContext executeFetchRequest:request2 error:Nil];
    for (Theme * theme in themes) {
        [self.themes addObject:theme];
    }
    
    for (Memo *memo in memos) {
        [self.memos addObject:memo];
    }
    int has = 0;
    for (Theme * theme in themes) {
        if ([theme.name isEqualToString:@"默认"]) {
            has = 1;
        }
    }
    if (has == 0) {
        Theme *t = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:app.managedObjectContext];
        t.name = @"默认";
        [app saveContext];
        [self.themes removeAllObjects];
        themes = [app.managedObjectContext executeFetchRequest:request1 error:Nil];
        for (Theme * theme in themes) {
            
            [self.themes addObject:theme];
        }
        
    }
    //绘制主题界面
    for (int i=0; i<self.themes.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(3, i*60+10, 50, 50)];
        //设置图片
        NSString *name = [NSString stringWithFormat:@"1%d.png",1+arc4random()%4];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        Theme * theme = (Theme *)self.themes[i];
        [btn setTitle:theme.name forState:UIControlStateNormal];
        [self.scrollView1 addSubview:btn];
        [btn addTarget:self action:@selector(jumpTheme:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.btns addObject:btn];
        
        //删除主题按钮
        UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.backgroundColor = [UIColor whiteColor];
    
        deletebtn.frame = CGRectMake(5, 0, 10,10);
        [deletebtn setTitle:@"X" forState:UIControlStateNormal];
        [deletebtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        //执行删除操作
        [deletebtn addTarget:self action:@selector(deleteTheme:) forControlEvents:UIControlEventTouchUpInside];
        deletebtn.tag = btn.tag;
        [self.deletebtns addObject:deletebtn];
        [btn addSubview:deletebtn];
        deletebtn.hidden = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteBtn:)];
        longPress.minimumPressDuration = 1.0;
        [btn addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGestureInView:)];
        [self.scrollView1 addGestureRecognizer:tapGesture];
        
        
        
    }
    [self.deletebtns[0] removeFromSuperview];
    
    UIButton * newThemeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 400, 25, 25)];
    [newThemeBtn setBackgroundImage:[UIImage imageNamed:@"1 (1).png"] forState:UIControlStateNormal];
    [newThemeBtn addTarget:self action:@selector(neThemeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:newThemeBtn];
    
    //绘制便签界面
    UIImageView *imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    imv.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:imv];
    [self.view insertSubview:imv atIndex:0];
    
    
    
    [self loadMemoAction];
    
    //添加左划右划手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss)];
    [self.createThemeView addGestureRecognizer:tap];
    
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.UIMemoIV addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.UIMemoIV addGestureRecognizer:swipeGestureLeft];
    
    
    //增加观察者
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateMemoView) name:@"newMemo" object:nil];
}

//重新加载便签
- (void)loadMemoAction
{
    [self.view viewWithTag:5354].userInteractionEnabled=YES;
    STAppDelegate *app2 = [UIApplication sharedApplication].delegate;
    NSLog(@"%@",_currentTheme);
    NSLog(@"清空界面上的便签");
    [self.ivs removeAllObjects];
    [self.memodeletebtns removeAllObjects];
    [self.displays removeAllObjects];
    for (UIView *view in [self.UIMemoIV subviews]) {
        [view removeFromSuperview];
    }
    
    NSFetchRequest *request3 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    
    //读出所有的便签，存进memos3
    NSArray *memos3 = [app2.managedObjectContext executeFetchRequest:request3 error:Nil];
 /********************************************************/
    
    NSMutableArray *memos2 = [[NSMutableArray alloc] init];
  

    //把当前主题的便签存进memos2
    app2.presentThemeName = _currentTheme;
    for (Memo *memo in memos3) {
        if ([memo.theme isEqualToString:_currentTheme]) {
            [memos2 addObject:memo];
        }
    }
    
    self.displays = [[NSMutableArray alloc]initWithArray:memos2];
    for (int i = 0; i < memos2.count; i++) {
        Memo *memo = [memos2 objectAtIndex:i];
        self.displays[[memo.memoOrder intValue]]= memo;
    }
    
    
    self.UIMemoIV.contentSize = CGSizeMake(0, 160*self.displays.count+20);
    
    
    for (int i=0; i<self.displays.count; i++) {
        //一条便签
        UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(30,i*100+10, 270, 90)];
        Memo *memo1 = [self.displays objectAtIndex:i];
        iv.tag =[memo1.memoOrder intValue];
        NSLog(@"第%d条便签的tag为%dmemoOrder为%@ 概要为%@",i,iv.tag,memo1.memoOrder,memo1.summary);
        UILongPressGestureRecognizer * panG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [iv addGestureRecognizer:panG];
        
        iv.image = [UIImage imageNamed:@"5.png"];
        Memo *memo = self.displays[i];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 260, 30)];
        //自动折行设置
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, 260, 20)];
        //自动折行设置
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 130, 10)];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(135, 70, 130, 10)];
        label1.text = memo.summary;
        label1.font = [UIFont boldSystemFontOfSize:18];
        label2.text = memo.details;
        label2.font = [UIFont boldSystemFontOfSize:15];
        
        label1.numberOfLines = 1;
        label2.numberOfLines = 1;
        
        
        NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString1 = [dateFormat1 stringFromDate:memo.remindTime];
        label3.text=dateString1;
        label3.font=[UIFont boldSystemFontOfSize:10];
        
        
        label4.text=memo.createTime;
        label4.font=[UIFont boldSystemFontOfSize:10];
        [iv addSubview:label1];
        [iv addSubview:label2];
        [iv addSubview:label3];
        [iv addSubview:label4];
        //进入ivs数组
        [self.ivs addObject:iv];
        
        
        //在每个view上添加memodeletebtn
        UIButton *memodeletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        memodeletebtn.frame = CGRectMake(120, -8, 21, 42);
        [memodeletebtn setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        
        //执行删除操作
        [memodeletebtn addTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
        memodeletebtn.tag = iv.tag;
        [self.memodeletebtns addObject:memodeletebtn];
        [iv addSubview:memodeletebtn];
        
        
        //放大button
        UIButton *largebtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, 270, 90)];
        [largebtn setTitle:@" " forState:UIControlStateNormal];
        [self.memoBtns addObject:largebtn];
        [largebtn addTarget:self action:@selector(touchMemo:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:largebtn];
        
        
        iv.userInteractionEnabled = YES;
        [self.UIMemoIV addSubview:iv];
        
    }
}

- (void)removeGestureInView:(UITapGestureRecognizer *)sender
{
    [self.createButton setUserInteractionEnabled:YES];
    [self.addNewMemoBtn setUserInteractionEnabled:YES];
    _editOverBtn.hidden = YES;
    for (UIButton* Onedeletebtn in _deletebtns) {
        Onedeletebtn.hidden = YES;
    }
    for (UIButton* Onedeletebtn in _btns) {
        [Onedeletebtn.layer removeAnimationForKey:@"shakeAnimation"];
    }
}

-(void) panAction:(UILongPressGestureRecognizer *)longP{
    if (pressDown) {
        return ;
    }
    
    if(((UIImageView *)(longP.view)).frame.size.height==IV_HEIGHT){
        NSLog(@"hahahahhahaha");
        //取到长按的那一条标签
        UIImageView *dragView = (UIImageView*)longP.view;
        //记录手指移动到得点得坐标
        CGPoint p = [longP locationInView:self.UIMemoIV];
        //设置点中的那一条便签到手指移动地方
        dragView.center = p;
        //将该便签移动到最前端
        [self.UIMemoIV bringSubviewToFront:dragView];
        //该视图从便签视图数组中删除
        [self.ivs removeObject:dragView];
        //记录该便签从哪个位置来
        self.from = (int)dragView.tag;
        //遍历数组 看改便签在手指的操控下移动到哪个另外的便签上面
        for (UIImageView *iv in self.ivs) {
            //碰撞检测
            if (CGRectContainsPoint(iv.frame, p)) {
                //如果碰撞成功
                //记录被碰撞的视图的位置
                self.to = (int)iv.tag;
                //交换位置
                [self.ivs insertObject:dragView atIndex:self.to];
                //更新视图并且做动画
                [self updateUI];
                
                break;
            }
        }
        if (longP.state == UIGestureRecognizerStateEnded) {
            //松手时把当前拖动的图片添加到它该在的地方
            [self.ivs insertObject:dragView atIndex:dragView.tag];
            //松手时避免更新位置的时候仍然把当前拖动的图片过滤掉 所以让to=-1
            self.to = -1;
            [self updateUI];
        }
        
    }
    else {
        pressDown = YES;
        
        UIImageView *iv=(UIImageView *)longP.view;
        
        for (UIView *a in iv.subviews) {
            NSLog(@"%@",a);
        }

        UILabel *label1=(UILabel *)iv.subviews[0];
        UILabel *label2=(UILabel *)iv.subviews[1];
        UILabel *label3=(UILabel *)iv.subviews[2];
        UILabel *label4=(UILabel *)iv.subviews[3];

        UIButton *btn = (UIButton *)iv.subviews[5];
        //不能点击放大缩小
        [btn setUserInteractionEnabled:NO];
        
        
        UITextField *summaryTextField=[[UITextField alloc ] initWithFrame:CGRectMake(5, 25, 250, label1.frame.size.height)] ;
        
        UITextView *detailsTextView =[[UITextView alloc] initWithFrame:CGRectMake(5, summaryTextField.frame.origin.x+label1.frame.size.height+30, 250, label2.frame.size.height+20)];
        summaryTextField.backgroundColor=[UIColor lightTextColor];
        summaryTextField.alpha=1.0;
        detailsTextView.backgroundColor=[UIColor lightTextColor];
        detailsTextView.alpha=1.0;
        summaryTextField.font = [UIFont boldSystemFontOfSize:18];
        detailsTextView.font = [UIFont boldSystemFontOfSize:15];
        
        summaryTextField.tag=1414;
        detailsTextView.tag=1515;
        
                
        summaryTextField.text=label1.text;
        detailsTextView.text=label2.text;
        //把原来的4个label去掉
        [label1 setHidden:YES];
        [label2 setHidden:YES];
        [label3 setHidden:YES];
        [label4 setHidden:YES];
        
        UIButton *deleteButton=((UIButton*)iv.subviews[4]);
        deleteButton.frame = CGRectMake(100, -8, 30, 30);
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
        
        //执行删除操作
        [deleteButton removeTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
        
        [deleteButton addTarget:self action:@selector(completeEditMemo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [summaryTextField addTarget:self action:@selector(keyboardMiss: ) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        self.summaryTextField=summaryTextField;
        self.detailsTextView=detailsTextView;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardMissBoth)];
        
        [self.UIMemoIV addGestureRecognizer:tap];
        
        [iv addSubview:self.summaryTextField];
        [iv addSubview:self.detailsTextView];
     
    }
    
}

-(void)updateUI{
    for (int i=0; i<self.ivs.count; i++) {
        UIImageView *iv = self.ivs[i];
        //更新自己最新的位置
        iv.tag = i;
        //从iv中找到子视图 summary 中的text对应数据中的那一条数据
         UILabel *label = iv.subviews[0];
        NSString *str = label.text;
        
        STAppDelegate *app = [UIApplication sharedApplication].delegate;
        
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
        NSArray *persons = [app.managedObjectContext executeFetchRequest:request error:Nil];
        for (Memo *m in persons) {
            if([m.summary isEqualToString:str])
            {   //iv.tag 设置为这一个数据中的memoorder的值
                m.memoOrder = [NSString stringWithFormat:@"%d",iv.tag];
                NSLog(@"概要为%@的便签在第%@个位置上",m.summary,m.memoOrder);
            }
        }
        [app saveContext];
        
        
        
        if (i==self.to) {
            //            如果是当前正在拖动的图片就不做动画
            continue;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            iv.frame = CGRectMake(30,10+i*100, 270, 90);
        }];
        
    }

}

- (void)updateMemoView
{
    [self loadMemoAction];
   
}

//显示删除按钮
-(void)showDeleteBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //抖动
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.1, 0, 0, 1)];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self.createButton setUserInteractionEnabled:NO];
        [self.addNewMemoBtn setUserInteractionEnabled:NO];
        _editOverBtn.hidden = NO;
        for (UIButton* Onedeletebtn in _deletebtns) {
            Onedeletebtn.hidden = NO;
        }
        for (UIButton* Onedeletebtn in _btns) {
            if ([_btns indexOfObject:Onedeletebtn] != 0) {
                [Onedeletebtn.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            }
            
        }
    
    }

}

//编辑主题结束
- (IBAction)editOver:(id)sender
{
    [self.createButton setUserInteractionEnabled:YES];
    [self.addNewMemoBtn setUserInteractionEnabled:YES];
    _editOverBtn.hidden = YES;
    for (UIButton* Onedeletebtn in _deletebtns) {
        Onedeletebtn.hidden = YES;
    }
    for (UIButton* Onedeletebtn in _btns) {
        [Onedeletebtn.layer removeAnimationForKey:@"shakeAnimation"];
    }

    
}

//删除便签操作
- (void)deleteMemo:(UIButton*)sender
{
    self.dele = (UIImageView*)sender.superview;
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲爱哒>_<" message:@"你要丢掉我嘛 555~" delegate:self cancelButtonTitle:@"怎么可能吶" otherButtonTitles:@"滚粗~", nil];
    [av show];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    //取到sender的父视图
    UIImageView * iv = self.dele;
    //取到父视图中summary的内容
    UILabel *label1 = (UILabel*)iv.subviews[0];
    NSString *str = label1.text;
    //用summary的内容找到数据库中对应的那条便签删除之
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *persons = [app.managedObjectContext executeFetchRequest:request error:Nil];
    int deleOr = 0;
    for (Memo *m in persons) {
        if([m.summary isEqualToString:str])
        {   deleOr = [m.memoOrder intValue];
            [app.managedObjectContext deleteObject:m];
            
        }
    }
    for (Memo *m in persons) {
        if([m.memoOrder intValue] > deleOr)
        {
            //存进数据库
            m.memoOrder = [NSString stringWithFormat:@"%d",[m.memoOrder intValue]-1 ];
            
        }
    }
    

    [app saveContext];
    [self.ivs removeObject:iv];
    //初始化垃圾桶
    UIImageView *ljt1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt1-1.png"]];
    UIImageView *ljt2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt2-2.png"]];
    ljt1.frame = CGRectMake(10, 568, 300,150 );
    ljt2.frame = CGRectMake(10, 568, 300,150 );
    [self.UIMemoIV addSubview:ljt1];
    [self.UIMemoIV addSubview:ljt2];
    [self.UIMemoIV bringSubviewToFront:ljt1];
    [self.UIMemoIV bringSubviewToFront:iv];
    [self.UIMemoIV bringSubviewToFront:ljt2];
    
    [UIView animateWithDuration:1 animations:^{
        //垃圾桶出来
        ljt1.center = CGPointMake(ljt1.center.x, 500);
        ljt2.center = CGPointMake(ljt2.center.x, 500);
        
    } completion:^(BOOL finished) {
        //字不要了
        for (UIView *v in iv.subviews) {
            [v removeFromSuperview];
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            //纸掉下去
            //的同时大小改变
            iv.frame = CGRectMake(iv.frame.origin.x+100, 600, 30, 30);
        } completion:^(BOOL finished) {
            [iv removeFromSuperview];
            [UIView animateWithDuration:1.5 animations:^{
                //垃圾桶上来
                ljt1.center = CGPointMake(ljt1.center.x, 700);
                ljt2.center = CGPointMake(ljt2.center.x, 700);
                //其余的纸正确排队
                
                
            } completion:^(BOOL finished) {
                [ljt1 removeFromSuperview];
                [ljt2 removeFromSuperview];
            }];
            
        }];
        
    }];
    self.ivvvv = iv;
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paiwei) userInfo:nil repeats:NO];
    
    
}

-(void)paiwei{
    for (NSInteger i=0; i<self.memoBtns.count; i++) {
        UIButton *btn = [self.memoBtns objectAtIndex:i];
        UIImageView *iv2 = (UIImageView *)btn.superview;
        if (iv2.frame.origin.y > self.ivvvv.frame.origin.y) {
            CGRect newPos = CGRectMake(iv2.frame.origin.x, iv2.frame.origin.y-100, iv2.frame.size.width, iv2.frame.size.height);
            [self moveMent:iv2 initialFrame:iv2.frame FinalFrame:newPos];
        }

    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadMemoAction) userInfo:nil repeats:NO];
    
    self.ivvvv = nil;
}

- (void)deleteComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue] == YES) {
        label1.numberOfLines = 0;
        label2.numberOfLines = 0;
    }
}

- (void)deleteTheme:(UIButton*)sender
{
    NSLog(@"Function used!");
    for (int i=sender.tag; i<= self.btns.count; i++) {
        if (i == sender.tag) {
            //UI删除操作
            UIButton* obj = [self.btns objectAtIndex:i];
            [obj removeFromSuperview];
            [self.btns removeObjectAtIndex:i];
            [self.deletebtns removeObjectAtIndex:i];
            //数据库记录删除theme操作
            STAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Theme"];
            NSError *error;
            NSArray *records = [context executeFetchRequest:request error:&error];
            for (Theme* oneObject in records) {
                if ([oneObject.name isEqualToString:obj.titleLabel.text]) {
                    [context deleteObject:oneObject];}
            }
            
            //数据库记录删除memo操作
            NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
            NSError *error2;
            NSArray *records2 = [context executeFetchRequest:request2 error:&error2];
            for (Memo* oneObject in records2) {
                if ([oneObject.theme isEqualToString:obj.titleLabel.text]) {
                    [context deleteObject:oneObject];}
            }
            
            for (UIImageView *image in [self.UIMemoIV subviews]) {
                [image removeFromSuperview ];
            }
            [appDelegate saveContext];
            
        } else{
            UIButton* obj = [self.btns objectAtIndex:i-1];
            UIButton* deleteObj = [self.deletebtns objectAtIndex:i-1];
            obj.tag = obj.tag - 1;
            deleteObj.tag = deleteObj.tag - 1;
            CGRect newPos = CGRectMake(3, 10+(i-1)*60, obj.frame.size.width,obj.frame.size.height);
            [self moveMent:obj initialFrame:obj.frame FinalFrame:newPos];
        }
    }
    
}

-(void)jumpTheme:(UIButton *)sender
{
    _currentTheme = [sender titleForState:UIControlStateNormal];
    [self loadMemoAction];
}

UILabel *label1;
UILabel *label2;
UILabel *label3;
UILabel *label4;

- (void)touchMemo:(UIButton *)sender
{
    
    UIImageView *iv = (UIImageView *)sender.superview;
    UIScrollView *scoller = (UIScrollView *)iv.superview;
    label1 = (UILabel *)iv.subviews[0];
    label2 = (UILabel *)iv.subviews[1];
    label3 = (UILabel *)iv.subviews[2];
    label4 = (UILabel *)iv.subviews[3];
    
    NSLog(@"label1.text%@",label1.text);
    NSString * summary = label1.text;
    
    NSString * detail = label2.text;
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:25]};
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    CGSize summarySize = [summary boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute1 context:nil].size;
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil].size;
    CGSize titleSize = CGSizeMake(detailSize.width,summarySize.height+detailSize.height+25);
    
    
    if (iv.frame.size.height == IV_HEIGHT) {
        if (titleSize.height < IV_HEIGHT + 60) titleSize.height = IV_HEIGHT + 60;
        else titleSize.height += 60;
        CGRect newPos = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, titleSize.height);
        [self moveMent:iv initialFrame:iv.frame FinalFrame:newPos];
        newPos =  CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, titleSize.height);
        [self moveMent:sender initialFrame:sender.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, label1.frame.size.width, summarySize.height);
        [self moveMentBig:label1 initialFrame:label1.frame FinalFrame:newPos];
        
        [label2 setHidden:YES];
        newPos = CGRectMake(label2.frame.origin.x, summarySize.height+20, label2.frame.size.width, detailSize.height);
        
        [self moveMentBig:label2 initialFrame:label2.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label3.frame.origin.x, titleSize.height-55, label3.frame.size.width, label3.frame.size.height);
        
        [self moveMent:label3 initialFrame:label3.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label4.frame.origin.x, titleSize.height-55, label4.frame.size.width, label4.frame.size.height);
        [self moveMent:label4 initialFrame:label4.frame FinalFrame:newPos];

        
        [scoller setContentSize:CGSizeMake(scoller.contentSize.width, scoller.contentSize.height+titleSize.height-IV_HEIGHT)];
        
        
        for (NSInteger i=0; i<self.memoBtns.count; i++) {
            UIButton *btn = [self.memoBtns objectAtIndex:i];
            UIImageView *iv2 = (UIImageView *)btn.superview;
            if (iv2.frame.origin.y > iv.frame.origin.y) {
                newPos = CGRectMake(iv2.frame.origin.x, iv2.frame.origin.y+titleSize.height-IV_HEIGHT, iv2.frame.size.width, iv2.frame.size.height);
                [self moveMent:iv2 initialFrame:iv2.frame FinalFrame:newPos];
            }
        }
        
    } else{
        CGFloat shrink = sender.frame.size.height - IV_HEIGHT;
        
        CGRect newPos = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, IV_HEIGHT);
        [self moveMent:iv initialFrame:iv.frame FinalFrame:newPos];
        
        newPos = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, IV_HEIGHT);
        [self moveMent:sender initialFrame:sender.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, label1.frame.size.width, SUMMARY_HEIGHT);
        [self moveMent:label1 initialFrame:label1.frame FinalFrame:newPos];
        [label2 setHidden:YES];
        newPos = CGRectMake(label2.frame.origin.x, 45, label2.frame.size.width, DETAIL_HEIGHT);
        [self moveMentBig:label2 initialFrame:label2.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label3.frame.origin.x, 70, label3.frame.size.width, label3.frame.size.height);
        
        [self moveMent:label3 initialFrame:label3.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label4.frame.origin.x, 70, label4.frame.size.width, label4.frame.size.height);
        [self moveMent:label4 initialFrame:label4.frame FinalFrame:newPos];
        
        [scoller setContentSize:CGSizeMake(scoller.contentSize.width, scoller.contentSize.height-shrink)];
        
        label1.numberOfLines = 1;
        label2.numberOfLines = 1;
        
        
        for (NSInteger i=0; i<self.memoBtns.count; i++) {
            UIButton *btn = [self.memoBtns objectAtIndex:i];
            UIImageView *iv2 = (UIImageView *)btn.superview;
            
            if (iv2.frame.origin.y > iv.frame.origin.y) {
                newPos = CGRectMake(iv2.frame.origin.x, iv2.frame.origin.y-shrink, iv2.frame.size.width, iv2.frame.size.height);
                [self moveMent:iv2 initialFrame:iv2.frame FinalFrame:newPos];
            }
        }
    }
    
    
}
    
- (void)moveMent:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
    [UIView commitAnimations];
}

- (void)moveMentBig:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue] == YES) {
        if (label1.numberOfLines == 1) {
            label1.numberOfLines = 0;
            label2.numberOfLines = 0;
            
        } 
        [label2 setHidden:NO];

    }
}

- (IBAction)neThemeClicked:(UIButton *)sender
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request2 = [[NSFetchRequest alloc]initWithEntityName:@"Theme"];
    NSArray *themes = [app.managedObjectContext executeFetchRequest:request2 error:Nil];
    if (themes.count == 6) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！我只容得下六个主题~" message:@"先整理一下嘛>_<!" delegate:self cancelButtonTitle:@"听你的~" otherButtonTitles: nil];
        [av show];
        return;    }
    for (Theme *theme in themes) {
        NSString * themeName = theme.name;
        if ([themeName isEqualToString:self.createThemeTextField.text]) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！主题重复了哦~" message:@"改一下嘛>_<!" delegate:self cancelButtonTitle:@"呵呵~" otherButtonTitles: nil];
            [av show];
            return;
        }
    }
    
    //限制主题字数
    if (self.createThemeTextField.text.length == 0) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"矮油，主题填点东西啦~" message:@">_<" delegate:self cancelButtonTitle:@"好哒~" otherButtonTitles: nil];
        [av show];
        
    }else if (self.createThemeTextField.text.length > 2) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"雅蠛蝶，你好暴力，填两个字就行啦~" message:@">_<" delegate:self cancelButtonTitle:@"辣我温油一点~" otherButtonTitles: nil];
        [av show];
    }else {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(3, [self.btns count]*60+10, 50, 50)];
        //设置图片
        NSString *name = [NSString stringWithFormat:@"1%d.png",1+arc4random()%4];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
        //把Button的title设成每个主题的名字
        [btn setTitle:self.createThemeTextField.text forState:UIControlStateNormal];
        
        //把每个button加入到侧边栏底视图（scrollView1）
        [self.scrollView1 addSubview:btn];
        
        //每个button响应jumpTheme函数
        [btn addTarget:self action:@selector(jumpTheme:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=[self.btns count];
        
        //把每个btn加入btns数组
        [self.btns addObject:btn];
        
        
        UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.backgroundColor=[UIColor whiteColor];
        deletebtn.frame = CGRectMake(0, 0, 10,10);
        [deletebtn setTitle:@"X" forState:UIControlStateNormal];
        [deletebtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        
        //每个button响应deleteTheme函数
        [deletebtn addTarget:self action:@selector(deleteTheme:) forControlEvents:UIControlEventTouchUpInside];
        deletebtn.tag=btn.tag;
        [self.deletebtns addObject:deletebtn];
        [btn addSubview:deletebtn];
        
        //长按手势
        deletebtn.hidden = YES;
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteBtn:)];
        longPress.minimumPressDuration=1.0;
        [btn addGestureRecognizer:longPress];
        
        //数据库操作
        STAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context=[appDelegate managedObjectContext];
        NSManagedObject* newObject;
        newObject=[NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:context];
        [newObject setValue:self.createThemeTextField.text forKey:@"name"];
        [appDelegate saveContext];
        
        
        [self.createThemeTextField resignFirstResponder];
        self.createThemeTextField.text = @"";
        self.scrollView1.userInteractionEnabled = YES;
        self.createThemeView.hidden = YES;
        
        [self jumpTheme:btn];
    }
    
}

- (IBAction)neThemeCancel:(UIButton *)sender

{
    self.createThemeView.hidden = YES;
    [self.createThemeTextField resignFirstResponder];
}

- (IBAction)neThemeAction:(UIButton *)sender
{
    self.createThemeView.hidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self.scrollView1 setUserInteractionEnabled:YES];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        if (self.UIMemoIV.center.x <= self.view.center.x+5) {
            [self.UIMemoIV setCenter:CGPointMake(self.UIMemoIV.center.x+80, self.UIMemoIV.center.y)];
            [self.createButton setHidden:NO];
            //让self.scrollerView1 右移
            self.scrollView1.center = CGPointMake(self.scrollView1.center.x+65, self.scrollView1.center.y);
        }
        
        
        [UIView commitAnimations];
    }
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self.scrollView1 setUserInteractionEnabled:NO];
        [self.createButton setHidden:YES];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if (self.UIMemoIV.center.x > self.view.center.x+30) {
            [self.UIMemoIV setCenter:CGPointMake(self.UIMemoIV.center.x-80, self.UIMemoIV.center.y)];
            //让self.scrollerView1 左移
            self.scrollView1.center = CGPointMake(self.scrollView1.center.x-65, self.scrollView1.center.y);
        }
        
        [UIView commitAnimations];
    }

}

//点击新建便签按钮（加号）触发函数
- (IBAction)neMemoButton:(id)sender {
    //默认新建标签是不开闹钟的
    self.isClock=false;
    self.isForSend=false;
    NSLog(@"newMemo");
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
    target:self selector:@selector(newMemo) userInfo:nil repeats:NO];
    
    [ self moveAllMemosForDistance:310];
       //不能再点新建按钮
    [self.view viewWithTag:5354].userInteractionEnabled=NO;

    
    }

//新建一条空白便签的view
-(void) newMemo{
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 270, 300)];
    iv.image = [UIImage imageNamed:@"5.png"];
    
    
    self.summaryTextField=[[UITextField alloc] initWithFrame:CGRectMake(5, 55, 250,20)];
    self.summaryTextField.placeholder=@"summary:(14 words limited)";
    self.detailsTextView.text=@"detail:";
    self.detailsTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, 85, 250,150)];
    self.summaryTextField.backgroundColor=[UIColor whiteColor];
    self.summaryTextField.alpha=0.5;
    self.detailsTextView.backgroundColor=[UIColor whiteColor];
    self.detailsTextView.alpha=0.5;
    
    self.summaryTextField.font = [UIFont boldSystemFontOfSize:18];
    self.detailsTextView.font = [UIFont boldSystemFontOfSize:15];

    
    [self.summaryTextField addTarget:self action:@selector(keyboardMiss: ) forControlEvents:UIControlEventEditingDidEndOnExit];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardMissBoth)];
    [self.UIMemoIV addGestureRecognizer:tap];
    
    
    [iv addSubview:self.summaryTextField];
    [iv addSubview:self.detailsTextView];
    
    
    //加闹钟
    clock = [UIButton buttonWithType:UIButtonTypeCustom];
    //tag为0表示禁止提醒
    clock.tag=0;
    clock.frame = CGRectMake(160, 15, 30, 30);
    [clock setBackgroundImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];
    [clock addTarget:self action:@selector(setClock:) forControlEvents:UIControlEventTouchUpInside];
    clock.tag = iv.tag;
    [self.memodeletebtns addObject:clock];
    [iv addSubview:clock];
    
    
    //加帅气的信鸽
    pigeon = [UIButton buttonWithType:UIButtonTypeCustom];
    //tag为0表示禁止提醒
    pigeon.tag=0;
    pigeon.frame = CGRectMake(200, 15, 30, 30);
    [pigeon setBackgroundImage:[UIImage imageNamed:@"信鸽.png"] forState:UIControlStateNormal];
    [pigeon addTarget:self action:@selector(sendMemo:) forControlEvents:UIControlEventTouchUpInside];
    pigeon.tag = iv.tag;
    [self.memodeletebtns addObject:pigeon ];
    [iv addSubview:pigeon ];
    
    
    // DatePicker
    UIDatePicker *remindTimeDatePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 580, 320, 150)];
    
    remindTimeDatePicker.tag=199;
    remindTimeDatePicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:remindTimeDatePicker];
    [self.view bringSubviewToFront:remindTimeDatePicker];
    
    //在每个view上添加memodeletebtn
    UIButton *memodeletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    memodeletebtn.frame = CGRectMake(110, -3, 30, 30);
    [memodeletebtn setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
    
    //执行删除操作
    [memodeletebtn addTarget:self action:@selector(completeNewMemo:) forControlEvents:UIControlEventTouchUpInside];
    memodeletebtn.tag = iv.tag;
    
    [iv addSubview:memodeletebtn];
    
    iv.userInteractionEnabled = YES;
    [self.UIMemoIV addSubview:iv];
    [self.ivs insertObject:iv atIndex:0];
    NSLog(@"newMemo");
    
}

//新建便签编辑完成后点击钉子按钮触发函数（把便签存入本地数据库）
-(void) completeNewMemo:(UIButton *)sender{
    //判断是否相同
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request2 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memos = [app.managedObjectContext executeFetchRequest:request2 error:Nil];
    
     for (Memo *memo in memos) {
         NSString * summ = memo.summary;
         if ([summ isEqualToString:self.summaryTextField.text]) {
             UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！标题长一样了哦~" message:@"改一下嘛>_<!" delegate:self cancelButtonTitle:@"呵呵~" otherButtonTitles: nil];
             [av show];
             return;
         }
    }

 
     if (self.summaryTextField.text.length == 0) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！标题不填人家会桑心的~" message:@">_<" delegate:self cancelButtonTitle:@"呵呵~" otherButtonTitles: nil];
        [av show];

    }else if (self.summaryTextField.text.length > 14) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！标题太长会爆炸哒~" message:@">_<" delegate:self cancelButtonTitle:@"呵呵~" otherButtonTitles: nil];
        [av show];
    }else if ( self.detailsTextView.text.length > 200) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"亲！内容太长就要报警了~" message:@">_<" delegate:self cancelButtonTitle:@"呵呵~" otherButtonTitles: nil];
        [av show];
    }else{
        
        self.isStartRequest=false;
        UIImageView *iv = (UIImageView *)[sender superview];
        
        //把数据库当前主题的所有便签读取出来memoOrder+1；
        STAppDelegate *app2 = [UIApplication sharedApplication].delegate;
        NSFetchRequest *request3 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
        NSArray *memos2 = [app2.managedObjectContext executeFetchRequest:request3 error:Nil];
        app2.presentThemeName = _currentTheme;
        for (Memo *memo in memos2) {
            if ([memo.theme isEqualToString:_currentTheme]){
                NSInteger a=[memo.memoOrder intValue];
                a++;
                memo.memoOrder=[[NSString alloc]initWithFormat:@"%i",a ];
            }
            
        }
        [app2 saveContext];
        
        //把便签存入数据库
        STAppDelegate * app = [UIApplication sharedApplication].delegate;
        app.presentThemeName=_currentTheme;
        Memo * memoSave = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:app.managedObjectContext];
        
        memoSave.summary = self.summaryTextField.text;
        self.memoSEND.summary = self.summaryTextField.text;
        memoSave.details = self.detailsTextView.text;
        self.memoSEND.details = self.detailsTextView.text;
        memoSave.theme = app.presentThemeName;
        self.memoSEND.theme = app.presentThemeName;
        memoSave.memoOrder=@"0";
        self.memoSEND.memoOrder =@"0";
        
        [self.memos insertObject:memoSave atIndex:0];
        
        //创建时间
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str=[dateFormatter stringFromDate:[NSDate date]];
        memoSave.createTime = str;
        //设置要发送到服务器的便签的创建时间
        self.memoSEND.createTime = str;
        
      
        //保存好写入数据库
        [app saveContext];
        
        //DatePicker下移
        CGRect newPos = CGRectMake([self.view viewWithTag:199].frame.origin.x, [self.view viewWithTag:199].frame.origin.y+200, [self.view viewWithTag:199].frame.size.width, [self.view viewWithTag:199].frame.size.height);
        [self moveMent:[self.view viewWithTag:199] initialFrame:[self.view viewWithTag:199].frame FinalFrame:newPos];
        
        //如果设置了闹钟
        if (self.isClock) {
            self.memoSave.remindTime =((UIDatePicker *)[self.view viewWithTag:199]).date;
            self.memoSEND.remindTime =((UIDatePicker *)[self.view viewWithTag:199]).date;
            //设置便签通知时间
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            
            //得到当前日期
            NSDate *pickerDate = ((UIDatePicker *)[self.view viewWithTag:199]).date;
            
            // Break the date up into components
            NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                           fromDate:pickerDate];
            NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                           fromDate:pickerDate];
            
            // Set up the fire time
            NSDateComponents *dateComps = [[NSDateComponents alloc] init];
            [dateComps setDay:[dateComponents day]];
            [dateComps setMonth:[dateComponents month]];
            [dateComps setYear:[dateComponents year]];
            [dateComps setHour:[timeComponents hour]];
            // Notification will fire in one minute
            [dateComps setMinute:[timeComponents minute]];
            NSDate *itemDate = [calendar dateFromComponents:dateComps];
            UILocalNotification *localNotif=[[UILocalNotification alloc] init];
            
            if (localNotif!=nil) {
                localNotif.fireDate = itemDate;
                
                localNotif.timeZone=[NSTimeZone defaultTimeZone];
                localNotif.applicationIconBadgeNumber=1; //应用的红色数字
                localNotif.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
                //去掉下面2行就不会弹出提示框
                localNotif.alertBody=self.summaryTextField.text;//提示信息 弹出提示框
                localNotif.alertAction = @"打开";  //提示框按钮
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
            
        }
        
        //移除DatePicker
        [[self.view viewWithTag:199] removeFromSuperview];
        
        //判断是否要发送
        if (self.isForSend) {
            
            [self startRequest:self.memoSEND];//发送self.memoSave到服务器
        }
        
        NSLog(@"newMemo 完成");
        
        //把东西移除
        [self.summaryTextField removeFromSuperview];
        [self.detailsTextView removeFromSuperview];
        [pigeon removeFromSuperview];
        [clock removeFromSuperview];
        [sender removeFromSuperview];
        
        //添加长按手势
        UILongPressGestureRecognizer * panG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [iv addGestureRecognizer:panG];
        
        
        iv.image = [UIImage imageNamed:@"5.png"];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 260, 30)];
        //自动折行设置
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, 260, 20)];
        //自动折行设置
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 130, 10)];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(135, 70, 130, 10)];
        label1.text = self.summaryTextField.text;
        label1.font = [UIFont boldSystemFontOfSize:18];
        label2.text = self.detailsTextView.text;
        label2.font = [UIFont boldSystemFontOfSize:15];
        
        label1.numberOfLines = 1;
        label2.numberOfLines = 1;
        
        
        NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString1 = [dateFormat1 stringFromDate:memoSave.remindTime];
        label3.text=dateString1;
        label3.font=[UIFont boldSystemFontOfSize:10];
        label4.text=memoSave.createTime;
        label4.font=[UIFont boldSystemFontOfSize:10];
        [iv addSubview:label1];
        [iv addSubview:label2];
        [iv addSubview:label3];
        [iv addSubview:label4];
        
        
        UIButton *largebtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, 270, 90)];
        [largebtn setTitle:@" " forState:UIControlStateNormal];
        [largebtn addTarget:self action:@selector(touchMemo:) forControlEvents:UIControlEventTouchUpInside];
        [self.memoBtns insertObject:largebtn atIndex:0];
        [iv addSubview:largebtn];
        iv.userInteractionEnabled = YES;
        
        
        //在每个view上添加memodeletebtn
        UIButton *memodeletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        memodeletebtn.frame = CGRectMake(120, -8, 21, 42);
        [memodeletebtn setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        
        //执行删除操作
        [memodeletebtn addTarget:self action:@selector(completeNewMemo:) forControlEvents:UIControlEventTouchUpInside];
        memodeletebtn.tag = iv.tag;
        
        [iv addSubview:memodeletebtn];
        
        //下面的便签向上移位
        CGFloat distance = IV_HEIGHT - iv.frame.size.height;
        newPos = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, IV_HEIGHT);
        [self moveMent:iv initialFrame:iv.frame FinalFrame:newPos];
        
        [self moveAllMemosForDistance:distance];
        
        
        
        [self.view viewWithTag:5354].userInteractionEnabled=YES;
        
        [self loadMemoAction];
    }
    
    
}

//编辑便签完成触发函数
- (void)completeEditMemo:(UIButton *)sender{
    
    UIImageView *iv = (UIImageView *)[sender superview];
    for (UIView *a in iv.subviews) {
        NSLog(@"%@",a);
    }
    
   //从数据库读取memoOrder=iv.tag的memo
    STAppDelegate *app2 = [UIApplication sharedApplication].delegate;
     
    NSFetchRequest *request3 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memos2 = [app2.managedObjectContext executeFetchRequest:request3 error:Nil];
    UITextField * summaryText = (UITextField *)iv.subviews[6] ;
    
    UITextView * detailsText= (UITextView *)iv.subviews[7];
    
    NSLog(@"**********iv.tag:%i",iv.tag);
    NSLog(@"_currentTheme:%@",self.currentTheme);
     app2.presentThemeName = self.currentTheme;
    NSDate *remindTime=[NSDate alloc];
     NSString *createTime=[NSString alloc];
    //创建时间
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str=[dateFormatter stringFromDate:[NSDate date]];
    
    for (Memo *memo in memos2) {
        NSLog(@"*****memoTheme:%@",memo.theme);
        NSLog(@"*****memoOrder:%@",memo.memoOrder );
        if ([memo.theme isEqualToString:self.currentTheme]&&[memo.memoOrder intValue] == iv.tag) {
            memo.summary = summaryText.text;
            memo.details = detailsText.text;
            memo.createTime = str;
            remindTime = memo.remindTime;
            createTime = str;
        }
    }
    [app2 saveContext];
    
    NSLog(@"edit Memo 完成");
    
    UILabel *label1 = (UILabel *)iv.subviews[0];
    UILabel *label2 = (UILabel *)iv.subviews[1];
    UILabel *label3 = (UILabel *)iv.subviews[2];
    UILabel *label4 = (UILabel *)iv.subviews[3];

    label1.text = summaryText.text;
    label1.font = [UIFont boldSystemFontOfSize:20];
    label2.text = detailsText.text;
    label2.font = [UIFont boldSystemFontOfSize:15];
    
    label1.numberOfLines = 1;
    label2.numberOfLines = 1;
    
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString1 = [dateFormat1 stringFromDate:remindTime];
    label3.text = dateString1;
    label3.font = [UIFont boldSystemFontOfSize:10];
    label4.text = createTime;
    label4.font = [UIFont boldSystemFontOfSize:10];

    [label1 setHidden:NO];
    [label2 setHidden:NO];
    [label3 setHidden:NO];
    [label4 setHidden:NO];
    
    [summaryText removeFromSuperview];
    [detailsText removeFromSuperview];
    
    
    for (UIView *a in iv.subviews) {
        NSLog(@"%@",a);
    }
    //设置点击放大缩小按钮
    UIButton *largebtn = (UIButton *)iv.subviews[5];
    largebtn.userInteractionEnabled = YES;
    
    
    //设置删除按钮
    UIButton *memodeletebtn = (UIButton *)iv.subviews[4];
    memodeletebtn.frame = CGRectMake(120, -8, 21, 42);
    [memodeletebtn setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    //更换方法
    [memodeletebtn removeTarget:self action:@selector(completeEditMemo:) forControlEvents:UIControlEventTouchUpInside];
    //执行删除操作
    [memodeletebtn addTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
    
    memodeletebtn.tag = iv.tag;
    
    
    
    pressDown = NO;
    
}
//键盘消失的代码

- (IBAction)keyboardMiss:(UITextField *)sender{
    [self.createThemeTextField resignFirstResponder];
}

- (void)miss {
    [self.createThemeTextField resignFirstResponder];
    
}

-(void)keyboardMissTextField:(UITextField *)sender {
    [self.summaryTextField resignFirstResponder];
}

-(void)keyboardMissTextView:(UITextView *)sender {
    [self.detailsTextView resignFirstResponder];
}

-(void)keyboardMissBoth {
    [self.summaryTextField resignFirstResponder];
    [self.detailsTextView resignFirstResponder];
}

//闹钟的DatePicker上移（出现）动画
-(void)DatePickerAppear{
    //DatePick向上移动动画
    CGRect newPos = CGRectMake([self.view viewWithTag:199].frame.origin.x, [self.view viewWithTag:199].frame.origin.y-200, [self.view viewWithTag:199].frame.size.width, [self.view viewWithTag:199].frame.size.height);
    [self moveMent:[self.view viewWithTag:199] initialFrame:[self.view viewWithTag:199].frame FinalFrame:newPos];
}

//闹钟的DatePicker下移（消失）动画
-(void)DatePickerDisappear{
    //DatePicker下移
    CGRect newPos = CGRectMake([self.view viewWithTag:199].frame.origin.x, [self.view viewWithTag:199].frame.origin.y+200, [self.view viewWithTag:199].frame.size.width, [self.view viewWithTag:199].frame.size.height);
    [self moveMent:[self.view viewWithTag:199] initialFrame:[self.view viewWithTag:199].frame FinalFrame:newPos];
    
}


//点击闹钟响应的函数
- (void)setClock:(UIButton *)sender{
    [self.summaryTextField resignFirstResponder];
    [self.detailsTextView resignFirstResponder];
    //要开闹钟
    if (sender.tag==0) {
        //DatePick向上移动动画
        [self DatePickerAppear];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
        sender.tag=1;
        self.isClock=true;
        
    }
    //要关闹钟
    else{
        //DatePicker下移
        [self DatePickerDisappear];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];
        sender.tag=0;
        self.isClock=false;
    }
  
}

//移动所有便签distance距离
-(void)moveAllMemosForDistance:(CGFloat)distance{
    if (distance>0) {
        for (NSInteger i=self.memoBtns.count-1; i>=0; i--) {
            UIButton *btn = [self.memoBtns objectAtIndex:i];
            UIImageView *iv2 = (UIImageView *)btn.superview;
            CGRect newPos = CGRectMake(iv2.frame.origin.x, iv2.frame.origin.y+distance, iv2.frame.size.width, iv2.frame.size.height);
            [self moveMent:iv2 initialFrame:iv2.frame FinalFrame:newPos];
            
        }
    }
    if (distance<0) {
        for (NSInteger i=1; i<self.memoBtns.count; i++) {
            UIButton *btn = [self.memoBtns objectAtIndex:i];
            UIImageView *iv2 = (UIImageView *)btn.superview;
            CGRect newPos = CGRectMake(iv2.frame.origin.x, iv2.frame.origin.y+distance, iv2.frame.size.width, iv2.frame.size.height);
            [self moveMent:iv2 initialFrame:iv2.frame FinalFrame:newPos];
            
        }
    }
    
    [self.UIMemoIV setContentSize:CGSizeMake(self.UIMemoIV.contentSize.width, self.UIMemoIV.contentSize.height+distance)];
    

}




//***********************以下是网络端
//信鸽按钮
-(void)sendMemo:(UIButton *)sender{
    [self.summaryTextField resignFirstResponder];
    [self.detailsTextView resignFirstResponder];
    
    //要发服务器
    if (sender.tag==0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"盖章的信鸽.png"] forState:UIControlStateNormal];
        sender.tag=1;
        self.isForSend=true;
        
    }
    
    //不要发服务器
    else{
        
        [sender setBackgroundImage:[UIImage imageNamed:@"信鸽.png"] forState:UIControlStateNormal];
        sender.tag=0;
        self.isForSend=false;
    }
    
}
//接收服务器数据库所有便签
-(void)getRequest
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebService.asmx/recordsInDataBase"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/x-www-form-urlencoded"
forHTTPHeaderField:@"Content-type"];
    [req setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn) {
        NSLog(@"success");
        _datas = [NSMutableData new];
    }
    
    
}

//发送一条便签到服务器端
-(void)startRequest:(STMemo *)MemoForSend
{
    self.isStartRequest=true;
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebService.asmx/createMemo"];
    
   
    
    NSString *summary = [[NSString alloc] init];
    summary = MemoForSend.summary;
    
    NSLog(@"******************************%@",MemoForSend.summary);
    NSString *details = [[NSString alloc] init];
    details = MemoForSend.details;
    
    NSString *memoOrder = [[NSString alloc] init];
    memoOrder = nil                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
   
    NSString *createTime = [[NSString alloc] init];
    createTime = MemoForSend.createTime;
    
    NSString *theme = [[NSString alloc] init];
    theme = MemoForSend.theme;
    
    NSString *remindTime = [[NSString alloc] init];
    NSString *date =[NSString stringWithFormat:@"%@",MemoForSend.remindTime];
    remindTime = date;
    
   
    NSString *isHighlight = [[NSString alloc] init];
    isHighlight = @" ";
    
    NSString *isRemind = [[NSString alloc] init];
    isRemind = @"1";
    NSLog(@"%@",createTime);
    NSString *jsonText = [NSString stringWithFormat:@"{\"summary\":\"%@\",\"details\":\"%@\",\"memoOrder\":\"%@\",\"createTime\":\"%@\",\"theme\":\"%@\",\"remindTime\":\"%@\",\"isHighlight\":\"%@\",\"isRemind\":\"%@\",}",summary,details,memoOrder,createTime,theme,remindTime,isHighlight,isRemind];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *postString=[NSString stringWithFormat:@"jsonText=%@",jsonText];
    
    
    NSData *postData=[postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *msgLength = [NSString stringWithFormat:@"%d",[postString length]];
    [req addValue:@"application/x-www-form-urlencoded"
forHTTPHeaderField:@"Content-type"];
    
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn) {
        _datas = [NSMutableData new];
        NSLog(@"success");
    }
    
    
    
}

//发送之后回调的方法
#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.datas appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",[error localizedDescription]);
    
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection{
    
    NSLog(@"请求完成！");
    NSString *result = [[NSString alloc] initWithData:self.datas encoding:NSUTF8StringEncoding];
    //如果是startRequest调用的
    if (self.isStartRequest) {
        self.isStartRequest=false;
        return;
    }
    NSLog(@"***********result:%@",result);
    MemoXMLParser *parser=[MemoXMLParser new];
    [parser start:result];
    
    NSString *jsonStr=[[NSString alloc] initWithString:parser.jsonString];
    NSLog(@"***********jsonStr:%@",jsonStr);
    
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData: jsonData options:
                        NSJSONReadingAllowFragments error:nil];
    self.MemoList=[dict objectForKey:@"Memo"];
    NSLog(@"memolist.count:%d",self.MemoList.count);
    NSMutableDictionary *memo=[self.MemoList objectAtIndex:0];
    NSString *summary = [[NSString alloc] init];
    NSString *details = [[NSString alloc] init];
    summary=[memo objectForKey: @"summary"];
    details=[memo objectForKey:@"details"];
    NSLog(@"summary:%@/n details:%@",summary,details);
    
}

@end
