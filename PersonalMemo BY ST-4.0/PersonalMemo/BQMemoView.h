//
//  BQMemoView.h
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQMemoView : UIView

//一般状态显示的成员
@property(strong, nonatomic) UIImageView *memoImageView;
@property(strong, nonatomic) UILabel *summaryLabel;
@property(strong, nonatomic) UILabel *detailLabel;
@property(strong, nonatomic) UILabel *createTimeLabel;
@property(strong, nonatomic) UILabel *remindTimeLabel;
@property(strong, nonatomic) UIButton *memoButton;
@property(strong, nonatomic) UIButton *deleteButton;
@property(strong, nonatomic) UIButton *editCompleteButton;

//编辑状态显示的成员
@property(strong, nonatomic) UITextField *summaryTextField;
@property(strong, nonatomic) UITextView *detailTextView;
@property(strong, nonatomic) UIButton *pigeon;    //信鸽
@property(strong, nonatomic) UIButton *clock;     //闹钟

@property(nonatomic) BOOL isRemind;
@property(nonatomic) BOOL isForSend;

//设置属性值
- (void)writeSummary:(NSString *)summary;
- (void)writeDetail:(NSString *)detail;
- (void)writeCreateTime:(NSString *)createTime;
- (void)writeRemindTime:(NSString *)remindTime;
- (void)changePigeonState;
- (void)changeClockState;

//改变便签状态
- (void)changeMemoState;

- (IBAction)keyboardMissBoth:(id)sender;

@end
