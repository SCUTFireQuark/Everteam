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

@interface STMemoDisplayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addNewMemoBtn;
@property (weak, nonatomic) IBOutlet UIButton *editOverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *scrollView1;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIView *createThemeView;
@property (weak, nonatomic) IBOutlet UITextField *createThemeTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *UIMemoIV;
@property (nonatomic)int from;
@property (nonatomic)int to;

@property (strong,nonatomic)NSMutableArray *displays;
@property (strong,nonatomic)NSMutableArray *themes;
@property (strong,nonatomic)NSMutableArray *memos;
@property (strong,nonatomic)NSMutableArray *btns;
@property (strong,nonatomic)NSMutableArray *memoBtns;
@property (strong,nonatomic)NSMutableArray *deletebtns;
@property (strong,nonatomic)NSMutableArray *ivs;
@property (strong,nonatomic)NSMutableArray *memodeletebtns;
@property (strong,nonatomic)NSString *currentTheme;

@end

@implementation STMemoDisplayViewController


const CGFloat IV_HEIGHT = 140;
const CGFloat SUMMARY_HEIGHT = 30;
const CGFloat DETAIL_HEIGHT = 20;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadMemoAction
{
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
    NSArray *memos2 = [app2.managedObjectContext executeFetchRequest:request3 error:Nil];
    
    app2.presentThemeName = _currentTheme;
    for (Memo *memo in memos2) {
        if ([memo.theme isEqualToString:_currentTheme]) {
            [self.displays addObject:memo];
        }
    }
    self.UIMemoIV.contentSize = CGSizeMake(0, 160*self.displays.count+20);

    for (int i=0; i<self.displays.count; i++) {
        NSLog(@"出现一条便签");
        //一条便签
        UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(30,10+i*150, 270, 140)];
        iv.tag = i;
        UILongPressGestureRecognizer * panG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [iv addGestureRecognizer:panG];
        
        //iv.backgroundColor = [UIColor redColor];
        iv.image = [UIImage imageNamed:@"5.png"];
        Memo *memo = self.displays[i];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 260, 30)];
        //自动折行设置
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 260, 20)];
        //自动折行设置
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 130, 10)];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(135, 70, 130, 10)];
        label1.text = memo.summary;
        label1.font = [UIFont boldSystemFontOfSize:25];
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
        iv.tag = i;
        [self.ivs addObject:iv];
        //在每个view上添加memodeletebtn
        UIButton *memodeletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memodeletebtn.backgroundColor = [UIColor whiteColor];
        memodeletebtn.frame = CGRectMake(0,0, 10,10);
        [memodeletebtn setTitle:@"X" forState:UIControlStateNormal];
        [memodeletebtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        //执行删除操作
        [memodeletebtn addTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
        memodeletebtn.tag = iv.tag;
        [self.memodeletebtns addObject:memodeletebtn];
        [iv addSubview:memodeletebtn];
        
        
        //放大button
        UIButton *largebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 300, 90)];
        //     btn.backgroundColor = [UIColor blueColor];   // use for debug
        [largebtn setTitle:@" " forState:UIControlStateNormal];
        [self.memoBtns addObject:largebtn];
        [largebtn addTarget:self action:@selector(touchMemo:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:largebtn];
        
        
        iv.userInteractionEnabled = YES;
        [self.UIMemoIV addSubview:iv];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
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
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-5, i*30+10, 70, 20)];
        Theme * theme = (Theme *)self.themes[i];
        [btn setTitle:theme.name forState:UIControlStateNormal];
        [self.scrollView1 addSubview:btn];
        [btn addTarget:self action:@selector(jumpTheme:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.btns addObject:btn];
        UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.backgroundColor = [UIColor whiteColor];
        deletebtn.frame = CGRectMake(0,0, 10,10);
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
        
        
    }
    //绘制便签界面
    UIImageView *imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    imv.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:imv];
    [self.view insertSubview:imv atIndex:0];
    
    
    
    [self loadMemoAction];
    
    //add swipe gesture
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

-(void) panAction:(UILongPressGestureRecognizer *)longP{
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
-(void)updateUI{
    for (int i=0; i<self.ivs.count; i++) {
        UIImageView *iv = self.ivs[i];
        //更新自己最新的位置
        iv.tag = i;
        
        
        if (i==self.to) {
            //            如果是当前正在拖动的图片就不做动画
            continue;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            iv.frame = CGRectMake(0,10+i*100, 300, 90);
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
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self.createButton setUserInteractionEnabled:NO];
        [self.addNewMemoBtn setUserInteractionEnabled:NO];
        _editOverBtn.hidden = NO;
        for (UIButton* Onedeletebtn in _deletebtns) {
            Onedeletebtn.hidden = NO;
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
    
    
}
//删除便签操作
-(void)deleteMemo:(UIButton*)sender
{
    //取到sender的父视图
    UIImageView * iv = (UIImageView*)sender.superview;
    //取到父视图中summary的内容
    UILabel *label1 = (UILabel*)iv.subviews[0];
    NSString *str = label1.text;
    //用summary的内容找到数据库中对应的那条便签删除之
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *persons = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Memo *m in persons) {
        if([m.summary isEqualToString:str])
        {
            [app.managedObjectContext deleteObject:m];
        }
    }
    [app saveContext];
    [self.ivs removeObject:iv];
    //初始化垃圾桶
    UIImageView *ljt1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt1.png"]];
    UIImageView *ljt2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt2.png"]];
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
        
        [UIView animateWithDuration:0.3 animations:^{
            //纸掉下去
            //的同时大小改变
            //iv.center = CGPointMake(iv.center.x, 600);
            iv.frame = CGRectMake(iv.frame.origin.x+100, 600, 30, 30);
        } completion:^(BOOL finished) {
            [iv removeFromSuperview];
            [UIView animateWithDuration:1 animations:^{
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
    //让下面的便签做动画移动上去
    
    
    /*
    for (int i=sender.tag; i<=_ivs.count; i++) {
        if (i == sender.tag) {
            UIImageView* obj = [_ivs objectAtIndex:i];
            obj.backgroundColor = [UIColor whiteColor];
            [self.UIMemoIV addSubview:obj];
            [obj removeFromSuperview];
            [_ivs removeObjectAtIndex:i];
            [_memodeletebtns removeObjectAtIndex:i];
            STAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K = %@",@"theme",_currentTheme];
            [request setPredicate:pred];
            NSError* error;
            NSArray* records = [context executeFetchRequest:request error:&error];
            
            Memo*memo = [records objectAtIndex:i];
            [context deleteObject:memo];
            [appDelegate saveContext];
        } else{
            UIImageView* obj = [_ivs objectAtIndex:i-1];
            UIButton* deleteObj = [_memodeletebtns objectAtIndex:i-1];
            obj.tag = obj.tag - 1;
            deleteObj.tag = deleteObj.tag - 1;
            [obj setFrame:CGRectMake(0,10+(i-1)*100, 300, 90)];
        }
    }
     */
    
}
-(void)deleteTheme:(UIButton*)sender
{
    NSLog(@"Function used!");
    for (int i=sender.tag; i<= _btns.count; i++) {
        if (i == sender.tag) {
            //UI删除操作
            UIButton* obj = [_btns objectAtIndex:i];
            [obj removeFromSuperview];
            [self.btns removeObjectAtIndex:i];
            [self.deletebtns removeObjectAtIndex:i];
            //数据库记录删除theme操作
            STAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Theme"];
            //NSPredicate *pred=[NSPredicate predicateWithFormat:@"%K=%d",@"name",obj.titleLabel.text];
            //[request setPredicate:pred];
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
            UIButton* obj = [_btns objectAtIndex:i-1];
            UIButton* deleteObj = [_deletebtns objectAtIndex:i-1];
            obj.tag = obj.tag - 1;
            deleteObj.tag = deleteObj.tag - 1;
            [obj setFrame:CGRectMake(0,10+(i-1)*100, obj.frame.size.width,obj.frame.size.height)];
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
    NSString * summary = label1.text;
    NSString * detail = label2.text;
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:25]};
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    CGSize summarySize = [summary boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute1 context:nil].size;
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil].size;
    CGSize titleSize = CGSizeMake(detailSize.width,summarySize.height+detailSize.height+25);
    
    
    if (iv.frame.size.height == IV_HEIGHT) {
        if (titleSize.height < IV_HEIGHT) titleSize.height = IV_HEIGHT + 1;
        CGRect newPos = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, titleSize.height);
        [self moveMent:iv initialFrame:iv.frame FinalFrame:newPos];
        newPos =  CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, titleSize.height);
        [self moveMent:sender initialFrame:sender.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, label1.frame.size.width, summarySize.height);
        [self moveMentBig:label1 initialFrame:label1.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label2.frame.origin.x, summarySize.height+10, label2.frame.size.width, detailSize.height);
        
        [self moveMentBig:label2 initialFrame:label2.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label3.frame.origin.x, titleSize.height-15, label3.frame.size.width, label3.frame.size.height);
        
        [self moveMent:label3 initialFrame:label3.frame FinalFrame:newPos];
        
        newPos = CGRectMake(label4.frame.origin.x, titleSize.height-15, label4.frame.size.width, label4.frame.size.height);
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
        
        newPos = CGRectMake(label2.frame.origin.x, 40, label2.frame.size.width, DETAIL_HEIGHT);
        [self moveMent:label2 initialFrame:label2.frame FinalFrame:newPos];
        
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
        label1.numberOfLines = 0;
        label2.numberOfLines = 0;
    }
}

- (IBAction)neThemeClicked:(UIButton *)sender
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, [_btns count]*30+10, 70, 20)];
    
    //Theme * theme = (Theme *)self.themes[i];
   
    //把Button的title设成每个主题的名字
    [btn setTitle:self.createThemeTextField.text forState:UIControlStateNormal];
    
    //把每个button加入到侧边栏底视图（scrollView1）
    [self.scrollView1 addSubview:btn];
    
    //每个button响应jumpTheme函数
    [btn addTarget:self action:@selector(jumpTheme:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=[_btns count];
    
    //把每个btn加入btns数组
    [self.btns addObject:btn];
    
    UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebtn.backgroundColor=[UIColor whiteColor];
    deletebtn.frame = CGRectMake(0,0, 10,10);
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
    
}

- (IBAction)neThemeCancel:(UIButton *)sender
{
    self.createThemeView.hidden = YES;
    [self.createThemeTextField resignFirstResponder];
}

- (IBAction)neThemeAction:(UIButton *)sender
{
    [self.view bringSubviewToFront:self.createThemeView];
    self.createThemeView.hidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void) swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        //  [self.scrollView1 setHidden:NO];
        [self.scrollView1 setUserInteractionEnabled:YES];
        //[self.createButton];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        if (self.UIMemoIV.center.x == self.view.center.x+5) {
            [self.UIMemoIV setCenter:CGPointMake(self.UIMemoIV.center.x+80, self.UIMemoIV.center.y)];
            [self.createButton setHidden:NO];
            //让self.scrollerView1 右移
            self.scrollView1.center = CGPointMake(self.scrollView1.center.x+65, self.scrollView1.center.y);
        }
        
        
        [UIView commitAnimations];
    }
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        // [self.scrollView1 setHidden:YES];
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

- (IBAction)keyboardMiss:(UITextField *)sender
{
    [self.createThemeTextField resignFirstResponder];
}

- (void)miss
{
    [self.createThemeTextField resignFirstResponder];
    
}



@end
