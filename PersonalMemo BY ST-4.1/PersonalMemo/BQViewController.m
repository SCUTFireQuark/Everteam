//
//  BQViewController.m
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQViewController.h"
#import "BQThemeCreationView.h"
@interface BQViewController ()

@property(strong, nonatomic) BQMemoBoard *memoBoard;
@property(strong, nonatomic) BQMemoTransmition *memoTransmition;
@property(strong, nonatomic) BQThemeCreationView *themeCreateView;
@property (retain, nonatomic) UIButton *themeCreateButton;
@property (weak, nonatomic) IBOutlet UIImageView *themePanelView;
@property (weak, nonatomic) IBOutlet UIScrollView *memoPanelView;
@property (weak, nonatomic) IBOutlet UIButton *memoCreateButton;

@property(strong, nonatomic) NSMutableArray *memoViewArray;
@property(strong, nonatomic) NSMutableArray *themeButtonArray;
@property(strong, nonatomic) NSMutableArray *themeDeleteButtonArray;

@property(strong, nonatomic) BQMemoView *memoViewToDelete;
@property(strong, nonatomic) UIDatePicker *remindTimeDatePicker;

@property(strong, nonatomic) BQMemoModel *memoModel;

@property(nonatomic) BOOL pressDown;
@property(nonatomic) int height;

@end

@implementation BQViewController

- (BQMemoModel *)memoModel
{
    if (_memoModel == nil) {
        _memoModel = [[BQMemoModel alloc] init];
    }
    return _memoModel;
}

- (BQMemoBoard *)memoBoard
{
    if (_memoBoard == nil) {
        _memoBoard = [[BQMemoBoard alloc] init];
    }
    return _memoBoard;
}

- (BQMemoTransmition *)memoTransmition
{
    if (_memoTransmition == nil) {
        _memoTransmition = [[BQMemoTransmition alloc] init];
    }
    return _memoTransmition;
}

- (NSMutableArray *)memoViewArray
{
    if (_memoViewArray == nil) {
        _memoViewArray = [[NSMutableArray alloc] init];
    }
    return _memoViewArray;
}

- (NSMutableArray *)themeButtonArray
{
    if (_themeButtonArray == nil) {
        _themeButtonArray = [[NSMutableArray alloc] init];
    }
    return _themeButtonArray;
}

- (NSMutableArray *)themeDeleteButtonArray
{
    if (_themeDeleteButtonArray == nil) {
        _themeDeleteButtonArray = [[NSMutableArray alloc] init];
    }
    return _themeDeleteButtonArray;
}

- (UIDatePicker *)remindTimeDatePicker
{
    if (_remindTimeDatePicker == nil) {
        NSNumber *x = [self.memoModel.timePicker objectForKey:@"x"];
        NSNumber *y = [self.memoModel.timePicker objectForKey:@"y"];
        NSNumber *width = [self.memoModel.timePicker objectForKey:@"width"];
        NSNumber *height = [self.memoModel.timePicker objectForKey:@"height"];
        _remindTimeDatePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake([x intValue], [y intValue], [width intValue], [height intValue])];
        _remindTimeDatePicker.backgroundColor=[UIColor whiteColor];
    }
    return _remindTimeDatePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pressDown = NO;
    [self.memoCreateButton setUserInteractionEnabled:YES];

    [self loadThemeView];
    [self loadMemoView];

    NSNumber *cx = [self.memoModel.themeCreateView objectForKey:@"x"];
    NSNumber *cy = [self.memoModel.themeCreateView objectForKey:@"y"];
    NSNumber *cwidth = [self.memoModel.themeCreateView objectForKey:@"width"];
    NSNumber *cheight = [self.memoModel.themeCreateView objectForKey:@"height"];
    self.themeCreateView = [[BQThemeCreationView alloc] initWithFrame:CGRectMake([cx intValue], [cy intValue], [cwidth intValue], [cheight intValue])];
    [self.themeCreateView.confirmBtn addTarget:self action:@selector(onConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.themeCreateView.cancelBtn addTarget:self action:@selector(onCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(themeKeyboardMiss:)];
    [self.themeCreateView addGestureRecognizer:tap];
    
    //添加左划右划手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.memoPanelView addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.memoPanelView addGestureRecognizer:swipeGestureLeft];
    
}

- (void)loadThemeView
{
    [self.themeButtonArray removeAllObjects];
    [self.themeDeleteButtonArray removeAllObjects];
    
    NSNumber *x = [self.memoModel.themeBtn objectForKey:@"x"];
    NSNumber *y = [self.memoModel.themeBtn objectForKey:@"y"];
    NSNumber *width = [self.memoModel.themeBtn objectForKey:@"width"];
    NSNumber *height = [self.memoModel.themeBtn objectForKey:@"height"];
    NSNumber *shift = [self.memoModel.themeBtn objectForKey:@"shift"];
    
    NSNumber *dx = [self.memoModel.themeDeleteBtn objectForKey:@"x"];
    NSNumber *dy = [self.memoModel.themeDeleteBtn objectForKey:@"y"];
    NSNumber *dwidth = [self.memoModel.themeDeleteBtn objectForKey:@"width"];
    NSNumber *dheight = [self.memoModel.themeDeleteBtn objectForKey:@"height"];
    
    NSNumber *cx = [self.memoModel.themeCreateBtn objectForKey:@"x"];
    NSNumber *cy = [self.memoModel.themeCreateBtn objectForKey:@"y"];
    NSNumber *cwidth = [self.memoModel.themeCreateBtn objectForKey:@"width"];
    NSNumber *cheight = [self.memoModel.themeCreateBtn objectForKey:@"height"];
        
    //绘制主题界面
    for (int i=0; i<self.memoBoard.themeArray.count; i++) {
        
        UIButton *themeButton = [[UIButton alloc]initWithFrame:CGRectMake([x intValue], i * [y intValue] + [shift intValue], [width intValue], [height intValue])];
        //设置图片
        NSString *name = [NSString stringWithFormat:@"1%d.png",1+arc4random()%4];
        [themeButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
        BQTheme *theme = (BQTheme *)self.memoBoard.themeArray[i];
        
        [themeButton setTitle:theme.name forState:UIControlStateNormal];
        [self.themePanelView addSubview:themeButton];
        
        [themeButton addTarget:self action:@selector(switchThemeClick:) forControlEvents:UIControlEventTouchUpInside];
        themeButton.tag = i;
        [self.themeButtonArray addObject:themeButton];
        
        //删除主题按钮
        UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.backgroundColor = [UIColor whiteColor];
        
        deletebtn.frame = CGRectMake([dx intValue], [dy intValue], [dwidth intValue], [dheight intValue]);
        [deletebtn setTitle:@"X" forState:UIControlStateNormal];
        [deletebtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        //添加删除操作
        [deletebtn addTarget:self action:@selector(removeThemeAction:) forControlEvents:UIControlEventTouchUpInside];
        deletebtn.tag = themeButton.tag;
        [self.themeDeleteButtonArray addObject:deletebtn];
        [themeButton addSubview:deletebtn];
        deletebtn.hidden = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteButton:)];
        longPress.minimumPressDuration = 1.0;
        [themeButton addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGestureInView:)];
        [self.themePanelView addGestureRecognizer:tapGesture];
        
        
    }
    
    [self.themeDeleteButtonArray[0] removeFromSuperview];
    
    self.themeCreateButton = [[UIButton alloc]initWithFrame:CGRectMake([cx intValue], [cy intValue], [cwidth intValue], [cheight intValue])];
    [self.themeCreateButton setBackgroundImage:[UIImage imageNamed:@"1 (1).png"] forState:UIControlStateNormal];
    [self.themeCreateButton addTarget:self action:@selector(onCreateThemeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.themePanelView addSubview:self.themeCreateButton];
    
    //绘制便签界面
    NSNumber *bx = [self.memoModel.backgroundSize objectForKey:@"x"];
    NSNumber *by = [self.memoModel.backgroundSize objectForKey:@"y"];
    NSNumber *bwidth = [self.memoModel.backgroundSize objectForKey:@"width"];
    NSNumber *bheight = [self.memoModel.backgroundSize objectForKey:@"height"];
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    background.frame = CGRectMake([bx intValue], [by intValue], [bwidth intValue], [bheight intValue]);
    [self.view addSubview:background];
    [self.view insertSubview:background atIndex:0];
}

- (void)loadMemoView
{
    [self.memoViewArray removeAllObjects];
    
    for (UIView *view in [self.memoPanelView subviews]) {
        [view removeFromSuperview];
    }
    self.memoPanelView.contentSize = CGSizeMake(0, 160*self.memoBoard.memoArray.count+20);
    
    NSDictionary *imageView = [self.memoModel.normalState objectForKey:@"imageView"];
    NSNumber *x = [imageView objectForKey:@"x"];
    NSNumber *y = [imageView objectForKey:@"y"];
    NSNumber *width = [imageView objectForKey:@"width"];
    NSNumber *height = [imageView objectForKey:@"height"];
    NSNumber *shift = [imageView objectForKey:@"shift"];
    self.height = [height intValue];

    for (int i=0; i<self.memoBoard.memoArray.count; i++) {
        //一条便签
        BQMemoView* memoView = [[BQMemoView alloc]initWithFrame:CGRectMake([x intValue],i*[y intValue] + [shift intValue], [width intValue], [height intValue])];
        [memoView initSizeWithDictionaryForNormalState:self.memoModel.normalState andEditState:self.memoModel.editState];
        BQMemo *memo = [self.memoBoard.memoArray objectAtIndex:i];
        
        memoView.tag =[memo.memoOrder intValue];
        UILongPressGestureRecognizer * panG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [memoView addGestureRecognizer:panG];
        
        [memoView writeSummary:memo.summary];
        [memoView writeDetail:memo.details];
        
        NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *remindTime = [dateFormat1 stringFromDate:memo.remindTime];
        [memoView writeRemindTime:remindTime];
        [memoView writeCreateTime:memo.createTime];
        
        //添加删除操作
        [memoView.deleteButton addTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加放大操作
        [memoView.memoButton addTarget:self action:@selector(changeMemoWidgetSize:) forControlEvents:UIControlEventTouchUpInside];
        
        //加入memoViewArray数组
        [self.memoViewArray addObject:memoView];
        
        memoView.userInteractionEnabled = YES;
        [self.memoPanelView addSubview:memoView];
        
    }
}

- (IBAction)onCreateThemeClick:(UIButton *)sender
{
    self.themeCreateView.hidden = NO;
    [self.themeCreateView reLoadText];
    [self.view addSubview:self.themeCreateView];
    [self.view bringSubviewToFront:self.themeCreateView];
    [self.memoPanelView setUserInteractionEnabled:NO];
    [self.memoCreateButton setUserInteractionEnabled:NO];
    
}

- (IBAction)onConfirmBtnClick:(UIButton *)sender
{
    [self createTheme];
    [self.memoPanelView setUserInteractionEnabled:YES];
    [self.memoCreateButton setUserInteractionEnabled:YES];

}

- (IBAction)onCancelBtnClick:(UIButton *)sender
{
    self.themeCreateView.hidden = YES;
    [self.themeCreateView.textField resignFirstResponder];
    [self.themeCreateView removeFromSuperview];
    [self.memoPanelView setUserInteractionEnabled:YES];
    [self.memoCreateButton setUserInteractionEnabled:YES];

}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self.themePanelView setUserInteractionEnabled:YES];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        if (self.memoPanelView.center.x <= self.view.center.x+5) {
            [self.memoPanelView setCenter:CGPointMake(self.memoPanelView.center.x+80, self.memoPanelView.center.y)];
            [self.memoPanelView setHidden:NO];
            //让self.scrollerView1 右移
            self.themePanelView.center = CGPointMake(self.themePanelView.center.x+65, self.themePanelView.center.y);
        }
        
        
        [UIView commitAnimations];
    }
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self.themePanelView setUserInteractionEnabled:NO];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if (self.memoPanelView.center.x > self.view.center.x+30) {
            [self.memoPanelView setCenter:CGPointMake(self.memoPanelView.center.x-80, self.memoPanelView.center.y)];
            //让self.scrollerView1 左移
            self.themePanelView.center = CGPointMake(self.themePanelView.center.x-65, self.themePanelView.center.y);
        }
        
        [UIView commitAnimations];
    }
    
}

- (void)panAction:(UILongPressGestureRecognizer *)sender
{
    if (self.pressDown) {
        return ;
    }
    
    int from;
    int to;
    
    if(((BQMemoView *)(sender.view)).frame.size.height == self.height){
        //取到长按的那一条标签
        BQMemoView *dragView = (BQMemoView *)sender.view;
        //记录手指移动到得点得坐标
        CGPoint p = [sender locationInView:self.memoPanelView];
        //设置点中的那一条便签到手指移动地方
        dragView.center = p;
        //将该便签移动到最前端
        [self.memoPanelView bringSubviewToFront:dragView];
        //该视图从便签视图数组中删除
        [self.memoViewArray removeObject:dragView];
        //记录该便签从哪个位置来
        from = (int)dragView.tag;
        //遍历数组 看改便签在手指的操控下移动到哪个另外的便签上面
        for (BQMemoView *iv in self.memoViewArray) {
            //碰撞检测
            if (CGRectContainsPoint(iv.frame, p)) {
                //如果碰撞成功
                //记录被碰撞的视图的位置
                to = (int)iv.tag;
                //交换位置
                [self.memoViewArray insertObject:dragView atIndex:to];
                //更新视图并且做动画
                [self updateUIWithStart:from andEnd:to];
                
                break;
            }
        }
        if (sender.state == UIGestureRecognizerStateEnded) {
            //松手时把当前拖动的图片添加到它该在的地方
            [self.memoViewArray insertObject:dragView atIndex:dragView.tag];
            //松手时避免更新位置的时候仍然把当前拖动的图片过滤掉 所以让to=-1
            to = -1;
            [self updateUIWithStart:from andEnd:to];
        }
        
    }
    else {
        self.pressDown = YES;
        [self.memoCreateButton setUserInteractionEnabled:NO];
        
        BQMemoView *memoView = (BQMemoView *)sender.view;
        [memoView.memoButton setUserInteractionEnabled:NO];
        [memoView.deleteButton setUserInteractionEnabled:NO];
        [memoView changeMemoState];
        [memoView.pigeon addTarget:self action:@selector(onSendMemoClick:) forControlEvents:UIControlEventTouchUpInside];
        [memoView.clock addTarget:self action:@selector(settingClock:) forControlEvents:UIControlEventTouchUpInside];
        
        for (BQMemoView *memoView in self.memoViewArray) {
            [memoView.memoButton setUserInteractionEnabled:NO];
            [memoView.deleteButton setUserInteractionEnabled:NO];
        }
        [memoView.editCompleteButton addTarget:self action:@selector(completeEditMemo:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:memoView action:@selector(keyboardMissBoth:)];
        [self.memoPanelView addGestureRecognizer:tap];
        
    }
    
}

- (IBAction)memoCreateButtonClick:(UIButton *)sender
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createMemoAction) userInfo:nil repeats:NO];
    
    [ self moveAllMemosForDistance:310];
    //不能再点新建按钮
    [self.memoCreateButton setUserInteractionEnabled:NO];
}

- (void)createMemoAction
{
    self.pressDown = YES;
    NSDictionary *imageView = [self.memoModel.normalState objectForKey:@"imageView"];
    NSNumber *x = [imageView objectForKey:@"x"];
    NSNumber *width = [imageView objectForKey:@"width"];
    NSNumber *height = [imageView objectForKey:@"createHeight"];
    NSNumber *shift = [imageView objectForKey:@"shift"];

    BQMemoView *memoView = [[BQMemoView alloc] initWithFrame:CGRectMake([x intValue], [shift intValue], [width intValue], [height intValue])];
    [memoView initSizeWithDictionaryForNormalState:self.memoModel.normalState andEditState:self.memoModel.editState];
    
    [memoView changeMemoState];
    [self.memoPanelView addSubview:memoView];
    [memoView.pigeon addTarget:self action:@selector(onSendMemoClick:) forControlEvents:UIControlEventTouchUpInside];
    [memoView.clock addTarget:self action:@selector(settingClock:) forControlEvents:UIControlEventTouchUpInside];
    
    for (BQMemoView *memo in self.memoViewArray) {
        [memo.memoButton setUserInteractionEnabled:NO];
        [memo.deleteButton setUserInteractionEnabled:NO];
    }
    
    [memoView.editCompleteButton addTarget:self action:@selector(completeCreateMemo:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:memoView action:@selector(keyboardMissBoth:)];
    [self.memoPanelView addGestureRecognizer:tap];
}

- (void)completeCreateMemo:(UIButton *)sender
{
    NSString *summaryTooLong = [self.memoModel.completeAlert objectForKey:@"summaryTooLong"];
    NSString *summaryTooShort = [self.memoModel.completeAlert objectForKey:@"summaryTooShort"];
    NSString *summaryDuplicate = [self.memoModel.completeAlert objectForKey:@"summaryDuplicate"];
    NSString *detailTooLong = [self.memoModel.completeAlert objectForKey:@"detailTooLong"];
    NSString *message = [self.memoModel.completeAlert objectForKey:@"message"];
    NSString *cancel = [self.memoModel.completeAlert objectForKey:@"cancel"];
    
    NSNumber *longestSummary = [self.memoModel.completeAlert objectForKey:@"longestSummary"];
    NSNumber *shortestSummary = [self.memoModel.completeAlert objectForKey:@"shortestSummary"];
    NSNumber *longestDetail = [self.memoModel.completeAlert objectForKey:@"longestDetail"];
    
    BQMemoView *memoView = (BQMemoView *)[sender superview];
    BOOL isSummaryDuplicate = [self.memoBoard isDataBaseContainMemoWithSummary:memoView.summaryTextField.text];
    if (isSummaryDuplicate) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryDuplicate message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (memoView.summaryTextField.text.length == [shortestSummary intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryTooShort message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        
    } else if (memoView.summaryTextField.text.length > [longestSummary intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryTooLong message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
    } else if (memoView.detailTextView.text.length > [longestDetail intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:detailTooLong message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        
    } else {
        [self.memoBoard increaseMemoOderForAllMemo];
        
        BQMemo *memo = [[BQMemo alloc] init];
        memo.summary = memoView.summaryTextField.text;
        memo.details = memoView.detailTextView.text;
        memo.theme = self.memoBoard.currentTheme.name;
        memo.memoOrder = @"0";
        //创建时间
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *createTime=[dateFormatter stringFromDate:[NSDate date]];
        memo.createTime = createTime;
        
        [self DatePickerDisappear];
        
        //如果设置了闹钟
        if (memoView.isRemind) {
            memo.remindTime = self.remindTimeDatePicker.date;
            //设置便签通知时间
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            
            //得到当前日期
            NSDate *pickerDate = self.remindTimeDatePicker.date;
            // Break the date up into components
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:pickerDate];
            NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:pickerDate];
            
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
                localNotif.alertBody = memoView.summaryTextField.text;//提示信息 弹出提示框
                localNotif.alertAction = @"打开";  //提示框按钮
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
            
        }
        [memoView writeCreateTime:memo.createTime];
        [memoView writeRemindTime:[dateFormatter stringFromDate:memo.remindTime]];
        [self.memoBoard.memoArray insertObject:memo atIndex:0];
        //把便签存入数据库
        [self.memoBoard createMemoInDataBase:memo];
        
        //移除DatePicker
        [self.remindTimeDatePicker removeFromSuperview];
        
        //判断是否要发送
        if (memoView.isForSend) {
            [self.memoTransmition startRequest:memo];//发送self.memoSave到服务器
        }
                
        [memoView changeMemoState];
        //添加删除操作
        [memoView.deleteButton addTarget:self action:@selector(deleteMemo:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加放大操作
        [memoView.memoButton addTarget:self action:@selector(changeMemoWidgetSize:) forControlEvents:UIControlEventTouchUpInside];

        [self.memoViewArray insertObject:memoView atIndex:0];
        //下面的便签向上移位
        CGFloat distance = self.height - memoView.frame.size.height;

        CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, self.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        
        [self moveAllMemosForDistance:distance];
        
        for (BQMemoView *memoView in self.memoViewArray) {
            [memoView.memoButton setUserInteractionEnabled:YES];
            [memoView.deleteButton setUserInteractionEnabled:YES];
        }
        // [self loadMemo];
    }
    
    self.pressDown = NO;
    [self.memoCreateButton setUserInteractionEnabled:YES];

}

- (void)settingClock:(UIButton *)sender
{
    BQMemoView *memoView = (BQMemoView *)[sender superview];
    [memoView.summaryTextField resignFirstResponder];
    [memoView.detailTextView resignFirstResponder];
    [memoView changeClockState];
    //要开闹钟
    if (memoView.isRemind) {
        //DatePick向上移动动画
        [self DatePickerAppear];
    }
    //要关闹钟
    else{
        //DatePicker下移
        [self DatePickerDisappear];
    }
}

- (IBAction)onSendMemoClick:(UIButton *)sender
{
    BQMemoView *memoView = (BQMemoView *)[sender superview];
    [memoView changePigeonState];
}

//DatePick向上移动动画
- (void)DatePickerAppear
{
    NSNumber *shift = [self.memoModel.timePicker objectForKey:@"shift"];
    [self.memoPanelView addSubview:self.remindTimeDatePicker];
    [self.view bringSubviewToFront:self.remindTimeDatePicker];
    CGRect newPos = CGRectMake(self.remindTimeDatePicker.frame.origin.x, self.remindTimeDatePicker.frame.origin.y - [shift intValue], self.remindTimeDatePicker.frame.size.width, self.remindTimeDatePicker.frame.size.height);
    [self memoMovement:self.remindTimeDatePicker initialFrame:self.remindTimeDatePicker.frame FinalFrame:newPos];
}

//闹钟的DatePicker下移（消失）动画
- (void)DatePickerDisappear
{
    //DatePicker下移
    NSNumber *shift = [self.memoModel.timePicker objectForKey:@"shift"];
    CGRect newPos = CGRectMake(self.remindTimeDatePicker.frame.origin.x, self.remindTimeDatePicker.frame.origin.y + [shift intValue], self.remindTimeDatePicker.frame.size.width, self.remindTimeDatePicker.frame.size.height);
    [self memoMovement:self.remindTimeDatePicker initialFrame:self.remindTimeDatePicker.frame FinalFrame:newPos];
    [self.remindTimeDatePicker removeFromSuperview];
}

- (IBAction)completeEditMemo:(id)sender
{
    BQMemoView *memoView = (BQMemoView *)[sender superview];
    
    NSString *summaryTooLong = [self.memoModel.completeAlert objectForKey:@"summaryTooLong"];
    NSString *summaryTooShort = [self.memoModel.completeAlert objectForKey:@"summaryTooShort"];
    NSString *summaryDuplicate = [self.memoModel.completeAlert objectForKey:@"summaryDuplicate"];
    NSString *detailTooLong = [self.memoModel.completeAlert objectForKey:@"detailTooLong"];
    NSString *message = [self.memoModel.completeAlert objectForKey:@"message"];
    NSString *cancel = [self.memoModel.completeAlert objectForKey:@"cancel"];
    
    NSNumber *longestSummary = [self.memoModel.completeAlert objectForKey:@"longestSummary"];
    NSNumber *shortestSummary = [self.memoModel.completeAlert objectForKey:@"shortestSummary"];
    NSNumber *longestDetail = [self.memoModel.completeAlert objectForKey:@"longestDetail"];
    
    BOOL isSummaryDuplicate = [self.memoBoard isDataBaseContainMemoWithSummary:memoView.summaryTextField.text];
    if (isSummaryDuplicate) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryDuplicate message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (memoView.summaryTextField.text.length == [shortestSummary intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryTooShort message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        
    } else if (memoView.summaryTextField.text.length > [longestSummary intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:summaryTooLong message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
    } else if (memoView.detailTextView.text.length > [longestDetail intValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:detailTooLong message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [alertView show];
        
    } else {
        NSString *memoOrder = [NSString stringWithFormat:@"%ld",(long)memoView.tag];
        [self.memoBoard updateMemoContextWithTheme:self.memoBoard.currentTheme.name andOrder:memoOrder newSummary:memoView.summaryTextField.text newDetail:memoView.detailTextView.text];
        [memoView changeMemoState];
        
        CGFloat distance = self.height - memoView.frame.size.height;
        CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, self.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        
        [self moveAllMemosForDistance:distance];
        for (BQMemoView *memoView in self.memoViewArray) {
            [memoView.memoButton setUserInteractionEnabled:YES];
            [memoView.deleteButton setUserInteractionEnabled:YES];

        }
        
    }
    self.pressDown = NO;
    [self.memoCreateButton setUserInteractionEnabled:YES];
    
}

- (void)updateUIWithStart:(int)from andEnd:(int)to
{
    NSDictionary *imageView = [self.memoModel.normalState objectForKey:@"imageView"];
    NSNumber *x = [imageView objectForKey:@"x"];
    NSNumber *y = [imageView objectForKey:@"y"];
    NSNumber *width = [imageView objectForKey:@"width"];
    NSNumber *height = [imageView objectForKey:@"height"];
    NSNumber *shift = [imageView objectForKey:@"shift"];
    for (int i=0; i<self.memoViewArray.count; i++) {
        BQMemoView *memoView = self.memoViewArray[i];
        //更新自己最新的位置
        memoView.tag = i;
        //从iv中找到子视图summary中的text对应数据中的那一条数据
        NSString *summary = memoView.summaryLabel.text;
        
        NSString *newOrder = [NSString stringWithFormat:@"%ld",(long)memoView.tag];
        [self.memoBoard updateMemoOrderWithTitle:summary newOrder:newOrder];
        
        if (i == to) {
            //如果是当前正在拖动的图片就不做动画
            continue;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            memoView.frame = CGRectMake([x intValue],i*[y intValue] + [shift intValue], [width intValue], [height intValue]);
        }];
        
    }
    
}

//删除便签操作
- (void)deleteMemo:(UIButton*)sender
{
    NSString *isDelete = [self.memoModel.deleteMemo objectForKey:@"isDelete"];
    NSString *message = [self.memoModel.deleteMemo objectForKey:@"message"];
    NSString *cancel = [self.memoModel.deleteMemo objectForKey:@"cancel"];
    NSString *other = [self.memoModel.deleteMemo objectForKey:@"other"];
    self.memoViewToDelete = (BQMemoView *)sender.superview;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:isDelete message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:other, nil];
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    BQMemoView *memoView = self.memoViewToDelete;
    //取到父视图中summary的内容
    NSString *summary = memoView.summaryLabel.text;
    
    [self.memoBoard removeMemoInDataBaseWithMemoTitle:summary];
    
    [self.memoViewArray removeObject:memoView];
    //初始化垃圾桶
    
    NSNumber *x = [self.memoModel.trash objectForKey:@"x"];
    NSNumber *y = [self.memoModel.trash objectForKey:@"y"];
    NSNumber *width = [self.memoModel.trash objectForKey:@"width"];
    NSNumber *height = [self.memoModel.trash objectForKey:@"height"];
    NSNumber *move1 = [self.memoModel.trash objectForKey:@"move1"];
    NSNumber *move2 = [self.memoModel.trash objectForKey:@"move2"];
    
    NSNumber *x2 = [self.memoModel.moveToTrash objectForKey:@"x"];
    NSNumber *y2 = [self.memoModel.moveToTrash objectForKey:@"y"];
    NSNumber *width2 = [self.memoModel.moveToTrash objectForKey:@"width"];
    NSNumber *height2 = [self.memoModel.moveToTrash objectForKey:@"height"];
    
    UIImageView *trash1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt1-1.png"]];
    UIImageView *trash2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljt2-2.png"]];
    trash1.frame = CGRectMake([x intValue], [y intValue], [width intValue], [height intValue]);
    trash2.frame = CGRectMake([x intValue], [y intValue], [width intValue], [height intValue]);
    [self.memoPanelView addSubview:trash1];
    [self.memoPanelView addSubview:trash2];
    [self.memoPanelView bringSubviewToFront:trash1];
    [self.memoPanelView bringSubviewToFront:memoView];
    [self.memoPanelView bringSubviewToFront:trash2];
    
    [UIView animateWithDuration:1 animations:^{
        //垃圾桶出来
        trash1.center = CGPointMake(trash1.center.x, [move1 intValue]);
        trash2.center = CGPointMake(trash2.center.x, [move1 intValue]);
        
    } completion:^(BOOL finished) {
        //字不要了
        [memoView.summaryLabel removeFromSuperview];
        [memoView.detailLabel removeFromSuperview];
        [memoView.createTimeLabel removeFromSuperview];
        [memoView.remindTimeLabel removeFromSuperview];
        [memoView.memoButton removeFromSuperview];
        
        [UIView animateWithDuration:1.5 animations:^{
            //纸掉下去
            //的同时大小改变
            memoView.frame = CGRectMake(memoView.frame.origin.x + [x2 intValue], [y2 intValue], [width2 intValue], [height2 intValue]);
            
        } completion:^(BOOL finished) {
            [memoView removeFromSuperview];
            [UIView animateWithDuration:1.5 animations:^{
                //垃圾桶上来
                trash1.center = CGPointMake(trash1.center.x, [move2 intValue]);
                trash2.center = CGPointMake(trash2.center.x, [move2 intValue]);
                //其余的纸正确排队
                
                
            } completion:^(BOOL finished) {
                [trash1 removeFromSuperview];
                [trash2 removeFromSuperview];
            }];
            
        }];
        
    }];
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reSortMemos) userInfo:nil repeats:NO];
}

- (void)reSortMemos
{
    for (NSInteger i=0; i<self.memoViewArray.count; i++) {
        BQMemoView *memoView = [self.memoViewArray objectAtIndex:i];
        if (memoView.frame.origin.y > self.memoViewToDelete.frame.origin.y) {
            CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y-100, memoView.frame.size.width, memoView.frame.size.height);
            [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        }
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadMemoView) userInfo:nil repeats:NO];
    self.memoViewToDelete = nil;
}

//移动所有便签distance距离
-(void)moveAllMemosForDistance:(CGFloat)distance
{
    if (distance > 0) {
        for (NSInteger i=self.memoViewArray.count-1; i>=0; i--) {
            BQMemoView *memoView = [self.memoViewArray objectAtIndex:i];
            CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y+distance, memoView.frame.size.width, memoView.frame.size.height);
            [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
            
        }
    }
    if (distance < 0) {
        for (NSInteger i=1; i<self.memoViewArray.count; i++) {
            BQMemoView *memoView = [self.memoViewArray objectAtIndex:i];
            CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y+distance, memoView.frame.size.width, memoView.frame.size.height);
            [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
            
        }
    }
    
    [self.memoPanelView setContentSize:CGSizeMake(self.memoPanelView.contentSize.width, self.memoPanelView.contentSize.height+distance)];
    
    
}

- (void)memoMovement:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
    [UIView commitAnimations];
}

- (void)memoMovementWithAnimation:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    BQMemoView *memoView = (BQMemoView *)[selectedView superview];
    [UIView animateWithDuration:0.5 animations:^{
        selectedView.frame = endRect;
    } completion:^(BOOL finished){
        if (memoView.summaryLabel.numberOfLines == 1) {
            memoView.summaryLabel.numberOfLines = 0;
            memoView.detailLabel.numberOfLines = 0;
        }
        [memoView.detailLabel setHidden:NO];
    }];
}

- (void)createTheme
{
    NSString *themeTooLong = [self.memoModel.createThemeAlert objectForKey:@"themeTooLong"];
    NSString *themeTooMany = [self.memoModel.createThemeAlert objectForKey:@"themeTooMany"];
    NSString *themeTooShort = [self.memoModel.createThemeAlert objectForKey:@"themeTooShort"];
    NSString *themeDuplicate = [self.memoModel.createThemeAlert objectForKey:@"themeDuplicate"];
    NSString *message = [self.memoModel.createThemeAlert objectForKey:@"message"];
    NSString *cancel = [self.memoModel.createThemeAlert objectForKey:@"cancel"];
    
    NSNumber *longestTheme = [self.memoModel.createThemeAlert objectForKey:@"longestTheme"];
    NSNumber *shortestTheme = [self.memoModel.createThemeAlert objectForKey:@"shortestTheme"];
    NSString *themeLimit = [self.memoModel.createThemeAlert objectForKey:@"themeLimit"];

    if (self.memoBoard.themeArray.count == [themeLimit intValue]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:themeTooMany message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [av show];
        return;
    }
    
    for (BQTheme *theme in self.memoBoard.themeArray) {
        NSString * themeName = theme.name;
        if ([themeName isEqualToString:self.themeCreateView.textField.text]) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:themeDuplicate message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
            [av show];
            return;
        }
    }
    
    //限制主题字数
    if (self.themeCreateView.textField.text.length == [shortestTheme intValue]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:themeTooShort message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [av show];
        
    }else if (self.themeCreateView.textField.text.length > [longestTheme intValue]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:themeTooLong message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
        [av show];
    }else {
        //存进数据库
        BQTheme *theme = [[BQTheme alloc]init];
        theme.name = self.themeCreateView.textField.text;
        [self.memoBoard createThemeInDataBase:theme];
        
        self.themeCreateView.hidden = YES;
        [self.themeCreateView.textField resignFirstResponder];
        [self.themeCreateView removeFromSuperview];
        
        [self loadThemeView];
    }
    
    
}

- (IBAction)switchThemeClick:(UIButton *)sender
{
    BQTheme *themeToSwitch = [[BQTheme alloc] init];
    themeToSwitch.name = [sender titleForState:UIControlStateNormal];
    [self.memoBoard switchThemeAction:themeToSwitch];
    [self loadMemoView];
}

//显示删除按钮
- (IBAction)showDeleteButton:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //抖动
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.1, 0, 0, 1)];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self.memoCreateButton setUserInteractionEnabled:NO];
        [self.themeCreateView setUserInteractionEnabled:NO];
        [self.themeCreateButton setUserInteractionEnabled:NO];

        for (UIButton* deleteButton in self.themeDeleteButtonArray) {
            deleteButton.hidden = NO;
        }
        for (UIButton* deleteButton in self.themeButtonArray) {
            if ([self.themeButtonArray indexOfObject:deleteButton] != 0) {
                [deleteButton.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
            }
            
        }
        
    }
    
}

- (IBAction)themeKeyboardMiss:(id)sender
{
    [self.themeCreateView resignFirstResponder];
}

- (IBAction)removeGestureInView:(id)sender
{
    [self.themeCreateButton setUserInteractionEnabled:YES];
    [self.memoCreateButton setUserInteractionEnabled:YES];
    [self.themeCreateView setUserInteractionEnabled:YES];
    for (UIButton *themeDeletebtn in self.themeDeleteButtonArray) {
        themeDeletebtn.hidden = YES;
    }
    for (UIButton *themeButton in self.themeButtonArray) {
        [themeButton.layer removeAnimationForKey:@"shakeAnimation"];
    }

}

- (IBAction)changeMemoWidgetSize:(UIButton *)sender
{
    BQMemoView *memoView = (BQMemoView *)[sender superview];
    NSString *summary = memoView.summaryLabel.text;
    NSString *detail = memoView.detailLabel.text;
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:25]};
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    CGSize summarySize = [summary boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute1 context:nil].size;
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(250,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil].size;
    CGSize titleSize = CGSizeMake(detailSize.width,summarySize.height+detailSize.height+25);
    
    if (memoView.frame.size.height == self.height) {
        if (titleSize.height < self.height + 60) titleSize.height = self.height + 60;
        else titleSize.height += 60;
        CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, titleSize.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        newPos =  CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, titleSize.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        
        newPos = CGRectMake(memoView.summaryLabel.frame.origin.x, memoView.summaryLabel.frame.origin.y, memoView.summaryLabel.frame.size.width, summarySize.height);
        [self memoMovementWithAnimation:memoView.summaryLabel initialFrame:memoView.summaryLabel.frame FinalFrame:newPos];
        
        [memoView.detailLabel setHidden:YES];
        newPos = CGRectMake(memoView.detailLabel.frame.origin.x, summarySize.height+20, memoView.detailLabel.frame.size.width, detailSize.height);
        
        [self memoMovementWithAnimation:memoView.detailLabel initialFrame:memoView.detailLabel.frame FinalFrame:newPos];
        
        newPos = CGRectMake(memoView.remindTimeLabel.frame.origin.x, titleSize.height-55, memoView.remindTimeLabel.frame.size.width, memoView.remindTimeLabel.frame.size.height);
        
        [self memoMovement:memoView.remindTimeLabel initialFrame:memoView.remindTimeLabel.frame FinalFrame:newPos];
        
        newPos = CGRectMake(memoView.createTimeLabel.frame.origin.x, titleSize.height-55, memoView.createTimeLabel.frame.size.width, memoView.createTimeLabel.frame.size.height);
        [self memoMovement:memoView.createTimeLabel initialFrame:memoView.createTimeLabel.frame FinalFrame:newPos];
        
        
        [self.memoPanelView setContentSize:CGSizeMake(self.memoPanelView.contentSize.width, self.memoPanelView.contentSize.height+titleSize.height-self.height)];
        
        for (BQMemoView *memo in self.memoViewArray) {
            if (memo.frame.origin.y > memoView.frame.origin.y) {
                newPos = CGRectMake(memo.frame.origin.x, memo.frame.origin.y+titleSize.height-self.height, memo.frame.size.width, memo.frame.size.height);
                [self memoMovement:memo initialFrame:memo.frame FinalFrame:newPos];
            }
        }
        
    } else{
        CGFloat shrink = memoView.frame.size.height - self.height;
        
        CGRect newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, self.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        
        newPos = CGRectMake(memoView.frame.origin.x, memoView.frame.origin.y, memoView.frame.size.width, self.height);
        [self memoMovement:memoView initialFrame:memoView.frame FinalFrame:newPos];
        
        NSDictionary *temp = [self.memoModel.normalState objectForKey:@"summary"];
        NSNumber *sumHeight = [temp objectForKey:@"height"];
        
        newPos = CGRectMake(memoView.summaryLabel.frame.origin.x, memoView.summaryLabel.frame.origin.y, memoView.summaryLabel.frame.size.width, [sumHeight intValue]);
        [self memoMovement:memoView.detailLabel initialFrame:memoView.detailLabel.frame FinalFrame:newPos];
        [memoView.detailLabel setHidden:YES];
        
        temp = [self.memoModel.normalState objectForKey:@"detail"];
        NSNumber *detHeight = [temp objectForKey:@"height"];
        NSNumber *detY = [temp objectForKey:@"y"];
        newPos = CGRectMake(memoView.detailLabel.frame.origin.x, [detY intValue], memoView.detailLabel.frame.size.width, [detHeight intValue]);
        [self memoMovementWithAnimation:memoView.detailLabel initialFrame:memoView.detailLabel.frame FinalFrame:newPos];
        
        temp = [self.memoModel.normalState objectForKey:@"remindTime"];
        detY = [temp objectForKey:@"y"];
        newPos = CGRectMake(memoView.remindTimeLabel.frame.origin.x, [detY intValue], memoView.remindTimeLabel.frame.size.width, memoView.remindTimeLabel.frame.size.height);
        
        [self memoMovement:memoView.remindTimeLabel initialFrame:memoView.remindTimeLabel.frame FinalFrame:newPos];
        
        temp = [self.memoModel.normalState objectForKey:@"createTime"];
        detY = [temp objectForKey:@"y"];
        newPos = CGRectMake(memoView.createTimeLabel.frame.origin.x, [detY intValue], memoView.createTimeLabel.frame.size.width, memoView.createTimeLabel.frame.size.height);
        [self memoMovement:memoView.createTimeLabel initialFrame:memoView.createTimeLabel.frame FinalFrame:newPos];
        
        [self.memoPanelView setContentSize:CGSizeMake(self.memoPanelView.contentSize.width, self.memoPanelView.contentSize.height-shrink)];
        
        memoView.summaryLabel.numberOfLines = 1;
        memoView.detailLabel.numberOfLines = 1;
        
        for (BQMemoView *memo in self.memoViewArray) {
            if (memo.frame.origin.y > memoView.frame.origin.y) {
                newPos = CGRectMake(memo.frame.origin.x, memo.frame.origin.y-shrink, memo.frame.size.width, memo.frame.size.height);
                [self memoMovement:memo initialFrame:memo.frame FinalFrame:newPos];
            }
        }
    }
}

- (IBAction)removeThemeAction:(UIButton *)sender
{
    for (NSInteger i = sender.tag; i <= self.themeButtonArray.count; i++) {
        if (i == sender.tag) {
            //UI删除操作
            UIButton *themeButtonToDelete = [self.themeButtonArray objectAtIndex:i];
            NSString *themeName = themeButtonToDelete.titleLabel.text;
            [themeButtonToDelete removeFromSuperview];
            [self.themeButtonArray removeObjectAtIndex:i];
            [self.themeDeleteButtonArray removeObjectAtIndex:i];
            
            //数据库记录删除theme操作
            [self.memoBoard removeThemeInDataBaseWithThemeName:themeName];

            //数据库记录删除memo操作
            [self.memoBoard removeAllMemosInTheme:themeName];
            if (self.memoBoard.currentTheme.name == themeName) {
                [self loadMemoView];
            }
            
        } else{
            UIButton* themeButton = [self.themeButtonArray objectAtIndex:i-1];
            UIButton* themeDeleteButton = [self.themeDeleteButtonArray objectAtIndex:i-1];
            themeButton.tag = themeButton.tag - 1;
            themeDeleteButton.tag = themeDeleteButton.tag - 1;
            NSNumber *x = [self.memoModel.themeBtn objectForKey:@"x"];
            NSNumber *y = [self.memoModel.themeBtn objectForKey:@"y"];
            NSNumber *shift = [self.memoModel.themeBtn objectForKey:@"shift"];
            CGRect newPos = CGRectMake([x intValue], [shift intValue] + (i-1) * [y intValue], themeButton.frame.size.width,themeButton.frame.size.height);
            [self memoMovement:themeButton initialFrame:themeButton.frame FinalFrame:newPos];
        }
    }
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
