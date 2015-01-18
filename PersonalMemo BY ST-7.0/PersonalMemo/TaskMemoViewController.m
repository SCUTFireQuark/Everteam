//
//  NewTaskMemoViewController.m
//  PersonalMemo
//
//  Created by new45 on 15-1-12.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "TaskMemoViewController.h"
#import "STProjectNameSelectViewController.h"
#import"BQMemoTransmition.h"
#import "STAppDelegate.h"

@interface TaskMemoViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *nv;
@property (nonatomic) BOOL isSetted;
@end

@implementation TaskMemoViewController

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
    
    STAppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    self.detailTextView.text = delegate.editDetail;
    self.summaryTextField.text = delegate.editSummary;
    self.deadline.titleLabel.text = delegate.deadLine;
    
    self.view.backgroundColor = [UIColor   greenColor];
    self.isSetted = false;
    delegate.taskcc = self;
    // Do any additional setup after loading the view.
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
- (IBAction)clickBackButton3:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)toProjectView:(UIButton *)sender {
    
    STAppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.editDetail = self.detailTextView.text;
    delegate.editSummary = self.summaryTextField.text;
    delegate.deadLine = self.deadline.titleLabel.text;
    
    STProjectNameSelectViewController * controller = [[STProjectNameSelectViewController alloc]init] ;
    controller.taskView = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)Send:(id)sender {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingPathComponent:@"userifo.plist"];
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
    //NSLog(@"projectView :%@",writeData);
    self.userID = [writeData objectForKey:@"userID"];
    
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"aaaaaaaaa");
    NSLog(@"%@",self.summaryTextField.text);
    NSLog(@"%@",self.detailTextView.text);
    NSLog(@"%@",self.deadline.titleLabel.text);
    NSLog(@"%@",date);
    NSLog(@"%@",_selectedProjectID);
    //NSLog(@"%@",_userID);
    BQMemoTransmition * TR = [[BQMemoTransmition alloc]init];
    TR.delegate_sent = self;
    [TR newMemoSummary:self.summaryTextField.text detail:self.detailTextView.text remindtime:self.deadline.titleLabel.text createtime:date       projectid:_selectedProjectID source:_userID memostate:@"未完成"];
    
    //[self.delegate_sendMemo newMemoSummary:self.summaryTextField.text detail:self.detailTextView.text remindtime:self.deadline.titleLabel.text createtime:date       projectid:_selectedProjectID source:_userID memostate:@"-1"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onClickDeadlineButton:(id)sender{
    [self.summaryTextField resignFirstResponder];
    [self.detailTextView resignFirstResponder];
    //
    if(self.isSetted==false){
        [self DatePickerAppear];
        self.isSetted = true;
    }else{
        [self DatePickerDisappear];
        self.isSetted = false;
    }
}
//DatePick向上移动动画
- (void)DatePickerAppear
{
    
    [self.view addSubview:self.deadlineDatePicker];
    [self.view bringSubviewToFront:self.deadlineDatePicker];
    CGRect newPos = CGRectMake(self.deadlineDatePicker.frame.origin.x, self.deadlineDatePicker.frame.origin.y - 200, self.deadlineDatePicker.frame.size.width, self.deadlineDatePicker.frame.size.height);
    [self memoMovement:self.deadlineDatePicker initialFrame:self.deadlineDatePicker.frame FinalFrame:newPos];
    
}

//闹钟的DatePicker下移（消失）动画
- (void)DatePickerDisappear
{
    //DatePicker下移
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *deadlinetime=[dateFormatter stringFromDate:[self.deadlineDatePicker date]];
    [self.deadline setTitle:deadlinetime forState:UIControlStateNormal];
    CGRect newPos = CGRectMake(self.deadlineDatePicker.frame.origin.x, self.deadlineDatePicker.frame.origin.y + 200, self.deadlineDatePicker.frame.size.width, self.deadlineDatePicker.frame.size.height);
    [self memoMovement:self.deadlineDatePicker initialFrame:self.deadlineDatePicker.frame FinalFrame:newPos];
    [self.deadlineDatePicker removeFromSuperview];
    
}
- (void)memoMovement:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
    [UIView commitAnimations];
}
- (UIDatePicker *)deadlineDatePicker
{
    if (_deadlineDatePicker == nil) {
        
        _deadlineDatePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,580,320,150)];
        _deadlineDatePicker.backgroundColor=[UIColor whiteColor];
    }
    return _deadlineDatePicker;
}

@end
