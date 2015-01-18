//
//  BQThemeCreationView.m
//  PersonalMemo
//
//  Created by st2 on 14-10-9.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQThemeCreationView.h"

@implementation BQThemeCreationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //通过plist给各个位置数据赋值
        self.themeCreatePanel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.themeCreatePanel setBackgroundColor:[UIColor greenColor]];
        self.labelRect = CGRectMake(7, 25, 170, 20);
        self.textRect = CGRectMake(20, 54, 86, 30);
        self.confirmRect =CGRectMake(150, 100, 60, 30);
        self.cancelRect = CGRectMake(10, 100, 60, 30);
        
        [self loadThemeCreationView];
    }
    return self;
}

- (void)reLoadText
{
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc]initWithFrame:self.textRect];
    self.textField.backgroundColor = [UIColor lightTextColor];
    self.textField.alpha = 1.0;
    self.textField.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.textField];
}

- (void)loadThemeCreationView
{
    self.label = [[UILabel alloc]initWithFrame:self.labelRect];
    self.label.text = @"请输入新主题的名字:";
    
    [self reLoadText];
    
    self.confirmBtn = [[UIButton alloc]initWithFrame:self.confirmRect];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:self.cancelRect];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

    [self addSubview:self.themeCreatePanel];
    [self addSubview:self.label];
    [self addSubview:self.textField];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.cancelBtn];
}


@end
