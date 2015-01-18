//
//  NewTaskMemoViewController.h
//  PersonalMemo
//
//  Created by new45 on 15-1-12.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskMemoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton3;
@property NSMutableArray * selectedUserID;
@property NSString * userID;
@property NSString *selectedProjectID;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *deadline;
@property (strong, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
- (void)DatePickerAppear;
- (void)DatePickerDisappear;
- (void)memoMovement:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect;

@end
