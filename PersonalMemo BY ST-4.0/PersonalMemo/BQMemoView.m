//
//  BQMemoView.m
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQMemoView.h"

@interface BQMemoView()

@property(nonatomic) BOOL isNormalState;

@end

@implementation BQMemoView

- (void)writeSummary:(NSString *)summary
{
    self.summaryLabel.text = summary;
}

- (void)writeDetail:(NSString *)detail
{
    self.detailLabel.text = detail;
}

- (void)writeCreateTime:(NSString *)createTime
{
    self.createTimeLabel.text = createTime;
}

- (void)writeRemindTime:(NSString *)remindTime
{
    self.remindTimeLabel.text = remindTime;
}

- (UITextField *)summaryTextField
{
    if (_summaryTextField == nil) {
        _summaryTextField = [[UITextField alloc ] initWithFrame:CGRectMake(10, 55, 250, 20)] ;
        _summaryTextField.backgroundColor = [UIColor lightTextColor];
        _summaryTextField.alpha = 1.0;
        _summaryTextField.font = [UIFont boldSystemFontOfSize:18];
    }
    return _summaryTextField;
}

- (UITextView *)detailTextView
{
    if (_detailTextView == nil) {
        _detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 85, 250,150)];
        _detailTextView.backgroundColor = [UIColor lightTextColor];
        _detailTextView.alpha = 1.0;
        _detailTextView.font = [UIFont boldSystemFontOfSize:15];

    }
    return _detailTextView;
}

- (UIButton *)clock
{
    if (_clock == nil) {
        _clock = [UIButton buttonWithType:UIButtonTypeCustom];
        _clock.frame = CGRectMake(160, 15, 30, 30);
        [_clock setBackgroundImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];
    }
    return _clock;
}

- (UIButton *)pigeon
{
    if (_pigeon == nil) {
        _pigeon = [UIButton buttonWithType:UIButtonTypeCustom];
        _pigeon.frame = CGRectMake(200, 15, 30, 30);
        [_pigeon setBackgroundImage:[UIImage imageNamed:@"信鸽.png"] forState:UIControlStateNormal];
    }
    return _pigeon;
}

- (UIButton *)editCompleteButton
{
    if (_editCompleteButton == nil) {
        _editCompleteButton = [[UIButton alloc]initWithFrame:CGRectMake(100, -8, 30, 30)];
        [_editCompleteButton setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
    }
    return _editCompleteButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isRemind = NO;
        self.isForSend = NO;
        self.isNormalState = YES;
        self.memoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.memoImageView.image = [UIImage imageNamed:@"5.png"];

        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 260, 30)];
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 260, 20)];
        self.createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 130, 10)];
        self.remindTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 70, 130, 10)];
        
        self.summaryLabel.font = [UIFont boldSystemFontOfSize:18];
        self.detailLabel.font = [UIFont boldSystemFontOfSize:15];
        self.summaryLabel.numberOfLines = 1;
        self.detailLabel.numberOfLines = 1;

        self.createTimeLabel.font=[UIFont boldSystemFontOfSize:10];
        self.remindTimeLabel.font=[UIFont boldSystemFontOfSize:10];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(120, -8, 21, 42)];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];

        self.memoButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 270, 90)];
        [self.memoButton setTitle:@" " forState:UIControlStateNormal];

        [self addSubview:self.memoImageView];
        [self addSubview:self.summaryLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.createTimeLabel];
        [self addSubview:self.remindTimeLabel];
        [self addSubview:self.memoButton];
        [self addSubview:self.deleteButton];

        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.memoImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)changeMemoState
{
    self.isNormalState = !self.isNormalState;
    if (self.isNormalState == NO) {
        self.summaryTextField.text = self.summaryLabel.text;
        self.detailTextView.text = self.detailLabel.text;
        
        [self.memoButton removeFromSuperview];
        [self.summaryLabel removeFromSuperview];
        [self.detailLabel removeFromSuperview];
        [self.createTimeLabel removeFromSuperview];
        [self.remindTimeLabel removeFromSuperview];
        [self.deleteButton removeFromSuperview];

        [self addSubview:self.pigeon];
        [self addSubview:self.clock];
        [self addSubview:self.summaryTextField];
        [self addSubview:self.detailTextView];
        [self addSubview:self.editCompleteButton];
        
        [self.summaryTextField addTarget:self action:@selector(keyboardMissForSummary:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
    } else {
        self.summaryLabel.text = self.summaryTextField.text;
        self.detailLabel.text = self.detailTextView.text;
        
        [self.summaryTextField removeFromSuperview];
        [self.detailTextView removeFromSuperview];
        [self.editCompleteButton removeFromSuperview];
        [self.pigeon removeFromSuperview];
        [self.clock removeFromSuperview];
        
        [self addSubview:self.summaryLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.createTimeLabel];
        [self addSubview:self.remindTimeLabel];
        [self addSubview:self.memoButton];
        [self addSubview:self.deleteButton];
    }
}

- (void)changePigeonState
{
    self.isForSend = !self.isForSend;
    if (self.isForSend) {
        [self.pigeon setBackgroundImage:[UIImage imageNamed:@"盖章的信鸽.png"] forState:UIControlStateNormal];
    } else {
        [self.pigeon setBackgroundImage:[UIImage imageNamed:@"信鸽.png"] forState:UIControlStateNormal];
    }
}

- (void)changeClockState
{
    self.isRemind = !self.isRemind;
    if (self.isRemind) {
        [self.clock setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
    } else {
        [self.clock setBackgroundImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];

    }

}

- (IBAction)keyboardMissForSummary:(UITextField *)sender
{
    [self.summaryTextField resignFirstResponder];
}

- (IBAction)keyboardMissBoth:(id)sender
{
    [self.summaryTextField resignFirstResponder];
    [self.detailTextView resignFirstResponder];
}

@end
