//
//  STCreatePersonalMemoViewController.m
//  PersonalMemo
//
//  Created by st on 14-7-10.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "STCreatePersonalMemoViewController.h"
#import "Memo.h"
#import "STAppDelegate.h"

@interface STCreatePersonalMemoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *remindTimeDatePicker;
@property Memo * memoSave;

@end

@implementation STCreatePersonalMemoViewController

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
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss)];
    [self.view addGestureRecognizer:tap];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeAction:(UIButton *)sender {
    //保存进数据库
    STAppDelegate * app = [UIApplication sharedApplication].delegate;
    Memo* memoSave = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:app.managedObjectContext];
    memoSave.summary = self.summaryTextField.text;
    memoSave.details = self.detailsTextView.text;
    //memoSave.theme = self.theme;
    memoSave.theme = app.presentThemeName;
    NSNumber * number = [NSNumber numberWithInt:self.topButton.tag];
    memoSave.isHighlight = number;
    memoSave.remindTime =self.remindTimeDatePicker.date;
    //NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    //float i = time;
    //NSString *str = [NSString stringWithFormat:@"%f",i];
    //memoSave.createTime = str;
    [app saveContext];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str=[dateFormatter stringFromDate:[NSDate date]];
    
    memoSave.createTime = str;
    [app saveContext];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	//得到当前日期
	NSDate *pickerDate = [self.remindTimeDatePicker date];
	
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
	//[dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    UILocalNotification *localNotif=[[UILocalNotification alloc] init];
    if (localNotif!=nil) {
        //NSDate *now=[NSDate new];
        localNotif.fireDate = itemDate;
        
        localNotif.timeZone=[NSTimeZone defaultTimeZone];
        localNotif.applicationIconBadgeNumber=1; //应用的红色数字
        localNotif.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        localNotif.alertBody=self.summaryTextField.text;//提示信息 弹出提示框
        localNotif.alertAction = @"打开";  //提示框按钮
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
 
    //发送消息给消息中心
    NSNotification *notification=[NSNotification notificationWithName:@"newMemo" object:self];
    NSNotificationCenter * notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter postNotification:notification];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)keyboardMiss:(UITextField *)sender {
    [self.summaryTextField resignFirstResponder];
}
- (IBAction)keyBoardMiss:(UIButton *)sender {
    
    
    [self.summaryTextField resignFirstResponder];
    [self.detailsTextView resignFirstResponder];
    
}
-(void)miss{
    [self.summaryTextField resignFirstResponder];
    [self.detailsTextView resignFirstResponder];

}

- (IBAction)beTopAction:(UIButton *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setTitle:@"★" forState:UIControlStateNormal];
    }else if (sender.tag == 1){
        sender.tag = 0;
        [sender setTitle:@"☆" forState:UIControlStateNormal];
    }
    
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
